#
# Copyright 2017-2019 Martin Goellnitz.
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
FROM maven:3.6-jdk-11

# sencha:
ENV PATH $PATH:/usr/local/sencha

RUN \
  apt-get update && \
  apt-get -yq install zip p7zip-full parallel && \
  apt-get -yq install git sudo && \
  curl http://cdn.sencha.com/cmd/6.7.0.63/no-jre/SenchaCmd-6.7.0.63-linux-amd64.sh.zip > /usr/local/sencha.zip && \
  cd /usr/local && \
  unzip /usr/local/sencha.zip && \
  /usr/local/SenchaCmd-6.7.0.63-linux-amd64.sh -q -dir /usr/local/sencha/6.7.0.63 && \
  mkdir /usr/local/sencha/repo && \
  chmod 777 /usr/local/sencha/repo && \
  grep -v export.PATH.*sencha.* ~/.bashrc > ~/.brc && \
  cat ~/.brc > ~/.bashrc && \
  rm -f ~/.brc && \
  curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 > phantomjs.tar.bz2 && \
  tar xjf phantomjs.tar.bz2 && \
  ln -s /usr/local/phantomjs-*/bin/phantomjs /usr/local/bin/phantomjs && \
  rm -f sencha.zip phantomjs.tar.bz2 SenchaCmd-6.7.0.63-linux-amd64.sh
