#
# Copyright 2017-2022 Martin Goellnitz, Markus Schwarz.
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
# https://github.com/docker-library/docker/blob/master/20.10/Dockerfile
FROM docker:20.10

# Maven
# Helm to support using charts from within your build:
# SenchaCmd:
ARG MAVEN_VERSION=3.8.5 \
    MAVEN_SHA=89ab8ece99292476447ef6a6800d9842bbb60787b9b8a45c103aa61d2f205a971d8c3ddfb8b03e514455b4173602bd015e82958c0b3ddc1728a57126f773c743 \
    USER_HOME_DIR="/root"
ARG MAVEN_BASE_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries \
    HELM_VERSION=3.7.2 \
    SENCHA_VERSION=7.2.0.84 \
    MAINTAINER='PROVOCON https://github.com/provocon/'

LABEL maintainer="${MAINTAINER}"

# Inspired by https://github.com/timbru31/docker-alpine-java-maven/blob/master/Dockerfile
ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT

# Maven package depends on openjdk8-jre, so a manual installation is necessary
# https://github.com/Docker-Hub-frolvlad/docker-alpine-glibc/blob/master/Dockerfile
RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.34-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add -q --no-cache --virtual=.build-dependencies wget ca-certificates && \
    echo \
        "-----BEGIN PUBLIC KEY-----\
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ2u1KJKUu/fW4A25y9m\
        y70AGEa/J3Wi5ibNVGNn1gT1r0VfgeWd0pUybS4UmcHdiNzxJPgoWQhV2SSW1JYu\
        tOqKZF5QSN6X937PTUpNBjUvLtTQ1ve1fp39uf/lEXPpFpOPL88LKnDBgbh7wkCp\
        m2KzLVGChf83MS0ShL6G9EQIAUxLm99VpgRjwqTQ/KfzGtpke1wqws4au0Ab4qPY\
        KXvMLSPLUp7cfulWvhmZSegr5AdhNw5KNizPqCJT8ZrGvgHypXyiFvvAH5YRtSsc\
        Zvo9GI2e2MaZyo9/lvb+LbLEJZKEQckqRj4P26gmASrZEPStwc+yqy1ShHLA0j6m\
        1QIDAQAB\
        -----END PUBLIC KEY-----" | sed 's/   */\n/g' > "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget -q \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk del libc6-compat && \
    apk add -q --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    (/usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true) && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    apk del glibc-i18n && \
    rm "/root/.wget-hsts" && \
    apk del --purge .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
  wget -qO /etc/apk/keys/amazoncorretto.rsa.pub  https://apk.corretto.aws/amazoncorretto.rsa.pub && \
  echo "https://apk.corretto.aws/" >> /etc/apk/repositories && \
  apk update && \
  apk upgrade && \
  apk add -q curl amazon-corretto-11 && \
  mkdir -p /usr/share/maven /usr/share/maven/ref  && \
  curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
  echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - && \
  tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 && \
  ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
  rm -rf /tmp/apache-maven.tar.gz /tmp/*.apk /tmp/gcc /tmp/gcc-libs.tar.xz /tmp/libz /tmp/libz.tar.xz /var/cache/apk/*

# Default configuration
LABEL PNPM_VERSION="6.29.1"
ENV MAVEN_HOME /usr/share/maven \
    MAVEN_CONFIG "$USER_HOME_DIR/.m2" \
    JAVA_VERSION 11.0.14.9.1-r0 \
    JAVA_HOME=/usr/lib/jvm/default-jvm \
    PNPM_HOME=/usr/local/bin \
    PATH="$JAVA_HOME/bin:$PATH:/usr/local/sencha" \
    LANG='de_DE.UTF-8' LANGUAGE='de_DE:en' LC_ALL='de_DE.UTF-8' \
    DISPLAY :20.0 \
    SCREEN_GEOMETRY "1440x900x24" \
        CHROMEDRIVER_PORT 4444 \
    CHROMEDRIVER_WHITELISTED_IPS "127.0.0.1" \
    CHROMEDRIVER_URL_BASE '' \
    CHROMEDRIVER_EXTRA_ARGS '' \
    CHROME_BIN=/usr/bin/chromium-browser

# The tools cosign, xz, zip, openssh etc are helpers for common CI usages
RUN \
  apk add -q xz zip p7zip parallel sudo git bash openssh-client font-noto gnupg && \
  fc-cache -fv && \
  curl -o /usr/local/sencha.zip http://cdn.sencha.com/cmd/${SENCHA_VERSION}/no-jre/SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh.zip 2> /dev/null && \
  cd /usr/local && \
  unzip /usr/local/sencha.zip && \
  /usr/local/SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh -q -d --illegal-access=warn -dir /usr/local/sencha/${SENCHA_VERSION} && \
  mkdir /usr/local/sencha/repo && \
  chmod 777 /usr/local/sencha/repo && \
  ln -s /usr/local/sencha/sencha-${SENCHA_VERSION} /usr/local/bin/sencha && \
  rm -f sencha.zip SenchaCmd-${SENCHA_VERSION}-linux-amd64.sh && \
  apk add -q nodejs npm && \
  npm install -g pnpm@6.29.1 && \
  export PNPM_HOME=/usr/local/bin && \
  pnpm install -g pnpm@6.29.1 && \
  curl -Lo helm.tar.gz "https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz" 2> /dev/null && \
  tar xvzf helm.tar.gz && \
  mv linux-amd64/helm /usr/local/bin && \
  rm -rf helm.tar.gz linux-amd

# Chromium: Taken from https://stackoverflow.com/a/48295423
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add -q --no-cache \
      chromium chromium-chromedriver \
      nss@edge

# Cosign images signing option
RUN \
  apk add -q cosign@edge

EXPOSE 4444

CMD ["bash"]
