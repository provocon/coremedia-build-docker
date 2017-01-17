#
# Copyright 2017 Martin Goellnitz.
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
FROM maven:3-jdk-8-alpine

ADD build/Cmd /usr/local/Cmd
# ADD dxp-blueprint /usr/local/dxp-blueprint

# sencha:
ENV PATH $PATH:/usr/local/Cmd

# phantomjs:
RUN apk update
RUN apk add xz
RUN curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 > /usr/local/phantomjs.tar.bz2
RUN ln -s /usr/local/phantomjs-*/bin/phantomjs /usr/local/bin/phantomjs
