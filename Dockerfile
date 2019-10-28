#
# Copyright 2017-2019 Martin Goellnitz, Markus Schwarz.
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
FROM provocon/alpine-docker-jdk11-maven3.6:latest

# sencha:
ARG SENCHA_VERSION=6.7.0.63
ENV PATH $PATH:/usr/local/sencha

RUN \
  apk update && \
  apk add xz zip p7zip parallel sudo && \
  apk add font-noto && \
  fc-cache -fv && \
  curl -o /usr/local/sencha.zip http://cdn.sencha.com/cmd/${SENCHA_VERSION}/no-jre/SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh.zip && \
  cd /usr/local && \
  unzip /usr/local/sencha.zip && \
  /usr/local/SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh -q -d --illegal-access=warn -dir /usr/local/sencha/${SENCHA_VERSION} && \
  mkdir /usr/local/sencha/repo && \
  chmod 777 /usr/local/sencha/repo && \
  ln -s /usr/local/sencha/sencha-${SENCHA_VERSION} /usr/local/bin/sencha && \
  curl -Lo phantomjs.tar.bz2  https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
  tar xjf phantomjs.tar.bz2 && \
  ln -s /usr/local/phantomjs-*/bin/phantomjs /usr/local/bin/phantomjs && \
  rm -f sencha.zip phantomjs.tar.bz2 SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh
