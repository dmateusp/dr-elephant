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

function play_command() {
  if type activator 2>/dev/null; then
    activator "$@"
  elif type play 2>/dev/null; then
    play "$@"
  else
    sbt "$@"
  fi
}

HADOOP_VERSION=$1
SPARK_VERSION=$2
PLAY_OPTS=$3

echo "Hadoop Version : $HADOOP_VERSION"
echo "Spark Version  : $SPARK_VERSION"
echo "Other opts set : $PLAY_OPTS"

OPTS+=" -Dhadoopversion=$HADOOP_VERSION"
OPTS+=" -Dsparkversion=$SPARK_VERSION"
OPTS+=" $PLAY_OPTS"

play_command $OPTS clean test compile dist