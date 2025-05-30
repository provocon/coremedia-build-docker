#!/bin/sh
#
# Copyright 2022-2025 Martin Goellnitz.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Login into CoreMedia's NPM Registry
#
OUTPUT_FILE=npmrc
usage () {
   echo "Usage: $MYNAME [-o host] [filter]" 1>&2
   echo "" 1>&2
   echo "  -h         This help message" 1>&2
   echo "  -o file    File to place results in - default ${OUTPUT_FILE}" 1>&2
   echo "  -u user    GitHub user to log in - default ${GITHUB_COM_USER}" 1>&2
   echo "  -t token   Above user's token to log in - default ${GITHUB_COM_TOKEN}" 1>&2
   echo "" 1>&2
   exit
}

if [ -z "$(which jq)" ] ; then
  echo "To use this tool, jq must be installed."
  exit
fi

while getopts "ho:u:t:" opt ; do
  case "${opt}" in
    h)
      usage
      ;;
    o)
      OUTPUT_FILE=$OPTARG
      ;;
    u)
      GITHUB_COM_USER=$OPTARG
      ;;
    t)
      GITHUB_COM_TOKEN=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "$GITHUB_COM_USER" ] ; then
  usage
fi

RESULT=$(curl -s -H "Accept: application/json" -H "Content-Type:application/json" \
  -X PUT --data '{"name": "'${GITHUB_COM_USER}'", "password": "'${GITHUB_COM_TOKEN}'"}' \
  https://npm.coremedia.io/-/user/org.couchdb.user:${GITHUB_COM_USER})
if [ "$(echo $RESULT|jq '.error' 2> /dev/null)" != "null" ] ; then
  echo $RESULT|jq '.error' 2> /dev/null
  echo $RESULT|jq '.'
  exit 1
fi

echo $RESULT|jq '.ok'
TOKEN=$(echo $RESULT|jq '.token'|sed -e 's/"//g')

echo '@coremedia:registry=https://npm.coremedia.io' > $OUTPUT_FILE
echo '@jangaroo:registry=https://npm.coremedia.io' >> $OUTPUT_FILE
echo "//npm.coremedia.io/:_authToken=$TOKEN" >> $OUTPUT_FILE
echo 'unsafe-perm=true' >> $OUTPUT_FILE
