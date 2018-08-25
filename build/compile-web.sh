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

#if npm is installed, install bower,ember-cli and other components for new UI

project_root=$1

if hash npm 2>/dev/null; then
  echo "############################################################################"
  echo "npm installation found, we'll compile with the new user interface"
  echo "############################################################################"
  set -x
  sleep 3
  ember_assets=${project_root}/public/assets
  ember_resources_dir=${ember_assets}/ember
  ember_web_directory=${project_root}/web

  # cd to the ember directory
  cd ${ember_web_directory}

  npm install
  node_modules/bower/bin/bower install
  node_modules/ember-cli/bin/ember build --prod
  rm -r ${ember_resources_dir} 2> /dev/null
  mkdir ${ember_resources_dir}
  cp dist/assets/dr-elephant.css ${ember_resources_dir}/
  cp dist/assets/dr-elephant.js ${ember_resources_dir}/
  cp dist/assets/vendor.js ${ember_resources_dir}/
  cp dist/assets/vendor.css ${ember_resources_dir}/
  cp -r dist/fonts ${ember_assets}/
  cd ${project_root}
else
  echo "############################################################################"
  echo "npm installation not found. Please install npm in order to compile with new user interface"
  echo "############################################################################"
  sleep 3
fi

trap "exit" SIGINT SIGTERM