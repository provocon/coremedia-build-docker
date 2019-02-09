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
FROM maven:3-jdk-8-slim

# sencha:
ENV PATH $PATH:/usr/local/sencha/cmd

# http://cdn.sencha.com/cmd/6.7.0.37/no-jre/SenchaCmd-6.7.0.37-linux-amd64.sh.zip
RUN \
  apt-get update && \
  apt-get -yq install zip && \
  apt-get -yq install git && \
  sed -i -e  's/^assistive_technologies/#assistive_technologies/g' /etc/java-8-openjdk/accessibility.properties && \
  grep assistive_technologies /etc/java-8-openjdk/accessibility.properties && \
  curl http://cdn.sencha.com/cmd/6.5.3.6/no-jre/SenchaCmd-6.5.3.6-linux-amd64.sh.zip > /usr/local/senchacmd.zip && \
  cd /usr/local && \
  unzip /usr/local/senchacmd.zip && \ 
  /usr/local/SenchaCmd-6.5.3.6-linux-amd64.sh -q -dir /usr/local/sencha/cmd && \
  mkdir /usr/local/sencha/repo && \
  chmod 777 /usr/local/sencha/repo && \
  curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 > phantomjs.tar.bz2 && \
  tar xjf phantomjs.tar.bz2 && \
  ln -s /usr/local/phantomjs-*/bin/phantomjs /usr/local/bin/phantomjs
