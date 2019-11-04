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

#################################################
# ----------------SenchaCmd----------------------
#################################################
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
  rm -f sencha.zip SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh

#################################################
# ----------------Chrome-------------------------
#################################################
# Taken from https://stackoverflow.com/a/48295423
ENV CHROME_BIN=/usr/bin/chromium-browser
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium chromium-chromedriver \
      nss@edge

# Default configuration
ENV DISPLAY :20.0
ENV SCREEN_GEOMETRY "1440x900x24"
ENV CHROMEDRIVER_PORT 4444
ENV CHROMEDRIVER_WHITELISTED_IPS "127.0.0.1"
ENV CHROMEDRIVER_URL_BASE ''
ENV CHROMEDRIVER_EXTRA_ARGS ''

EXPOSE 4444
