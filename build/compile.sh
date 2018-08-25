#!/usr/bin/env bash

#
# Copyright 2016 LinkedIn Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
#

# exit on first error
set -e

function print_usage(){
  echo "usage: ./compile.sh PATH_TO_CONFIG_FILE(optional, default: ./compile.conf)"
}

function require_programs() {
  echo "Checking for required programs..."
  missing_programs=""
  
  for program in $@; do
    if ! command -v "$program" > /dev/null; then
      missing_programs=$(printf "%s\n\t- %s" "$missing_programs" "$program")
    fi
  done 

  if [ ! -z "$missing_programs" ]; then
    echo "[ERROR] The following programs are required and are missing: $missing_programs"
    exit 1
  else
    echo "[SUCCESS] Program requirement is fulfilled!"
  fi
}

require_programs zip unzip

# User should pass an optional argument which is a path to config file
if [ -z "$1" ];
then
  echo "Using default config file location"
  CONF_FILE_PATH="build/compile.conf"
else
  CONF_FILE_PATH=$1
  echo "Using config file: "$CONF_FILE_PATH
fi

# User must give a valid file as argument
if [ -f $CONF_FILE_PATH ];
then
  echo "Reading from config file..."
else
  echo "error: Couldn't find a valid config file at: " $CONF_FILE_PATH
  print_usage
  exit 1
fi

# Read the config file
source $CONF_FILE_PATH

# Fetch the Hadoop version
if [ -n "${hadoop_version}" ]; then
  HADOOP_VERSION=${hadoop_version}
fi

# Fetch the Spark version
if [ -n "${spark_version}" ]; then
  SPARK_VERSION=${spark_version}
fi

# Fetch other play opts
if [ -n "${play_opts}" ]; then
  PLAY_OPTS=${play_opts}
fi

project_root=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd ${project_root}

# Echo the value of pwd in the script so that it is clear what is being removed.
rm -rf ${project_root}/dist
mkdir dist

# Uses npm to compile the web UI
build/compile-web.sh $project_root

# Builds the backend
build/compile-backend.sh $HADOOP_VERSION $SPARK_VERSION $PLAY_OPTS


BACKEND_ZIP_NAME=`/bin/ls target/universal/*.zip`
unzip -d `dirname ${BACKEND_ZIP_NAME}` ${BACKEND_ZIP_NAME}
DIST_NAME=${BACKEND_ZIP_NAME%.zip}

chmod +x ${DIST_NAME}/bin/dr-elephant

# Append hadoop classpath and the ELEPHANT_CONF_DIR to the Classpath
sed -i.bak $'/declare -r app_classpath/s/.$/:`hadoop classpath`:${ELEPHANT_CONF_DIR}"/' ${DIST_NAME}/bin/dr-elephant

# Adding scripts / conf
start_script=${project_root}/scripts/start.sh
stop_script=${project_root}/scripts/stop.sh
app_conf=${project_root}/app-conf
pso_dir=${project_root}/scripts/pso

cp $start_script ${DIST_NAME}/bin/
cp $stop_script ${DIST_NAME}/bin/
cp -r $app_conf ${DIST_NAME}
mkdir ${DIST_NAME}/scripts/
cp -r $pso_dir ${DIST_NAME}/scripts/

# Zipping dist
DIST_ZIP_NAME=`basename ${DIST_NAME}`.zip
[ -e ${DIST_ZIP_NAME} ] && rm ${DIST_ZIP_NAME}
(cd ${DIST_NAME}; zip -r ${DIST_ZIP_NAME} .)
mv ${DIST_NAME}.zip ${project_root}/dist/

echo "Packaged to ${project_root}/dist/${DIST_ZIP_NAME}"