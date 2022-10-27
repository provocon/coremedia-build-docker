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

ARG MAVEN_VERSION=3.8.6
ARG MAVEN_SHA=f790857f3b1f90ae8d16281f902c689e4f136ebe584aba45e4b1fa66c80cba826d3e0e52fdd04ed44b4c66f6d3fe3584a057c26dfcac544a60b301e6d0f91c26
ARG USER_HOME_DIR="/root"
ARG MAVEN_BASE_URL=https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries
ARG HELM_VERSION=3.7.2
ARG SENCHA_VERSION=7.2.0.84
ARG PNPM_VERSION=6.35.0
ARG MAINTAINER='PROVOCON https://github.com/provocon/'

LABEL maintainer="$MAINTAINER"
LABEL Maven="$MAVEN_VERSION"
LABEL SenchaCmd="$SENCHA_VERSION"
LABEL Helm="$HELM_VERSION"
LABEL PNPM="$PNPM_VERSION"

ENV DOCKER_TLS_CERTDIR=/certs
ENV MAVEN_HOME /usr/local/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV JAVA_HOME=/usr/local/java
ENV PNPM_HOME=/usr/local/bin
ENV PATH="$JAVA_HOME/bin:$PATH:/usr/local/sencha"
ENV LANG='de_DE.UTF-8' LANGUAGE='de_DE:en' LC_ALL='de_DE.UTF-8'
ENV DISPLAY :20.0
ENV SCREEN_GEOMETRY "1440x900x24"
ENV CHROMEDRIVER_PORT 4444
ENV CHROMEDRIVER_WHITELISTED_IPS "127.0.0.1"
ENV CHROMEDRIVER_URL_BASE ''
ENV CHROMEDRIVER_EXTRA_ARGS ''
ENV CHROME_BIN=/usr/bin/chromium-browser


WORKDIR /usr/local

# The tools cosign, xz, zip, openssh etc are helpers for common CI usages
RUN apk add -q curl ca-certificates xz zip parallel sudo git bash openssh-client font-noto gnupg nodejs npm cosign && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    fc-cache -f && \
    npm install -g pnpm@$PNPM_VERSION && \
    ARCH=$(uname -m|sed -e 's/x86_64/amd64/g'|sed -e 's/aarch64/arm64/g') && \
    MACHINE=$(uname -m|sed -e 's/86_//g') && \
    echo "Detecting architecture $ARCH / $MACHINE" && \
    curl -Lo java.tgz \
             "https://cdn.azul.com/zulu/bin/zulu11.60.19-ca-jdk11.0.17-linux_musl_${MACHINE}.tar.gz" 2> /dev/null && \
    tar xzf java.tgz && \
    ln -s zulu* java && \
    curl -Lo helm.tgz "https://get.helm.sh/helm-v$HELM_VERSION-linux-$ARCH.tar.gz" 2> /dev/null && \
    tar xzf helm.tgz && \
    mv linux-$ARCH/helm bin && \
    mkdir -p $MAVEN_HOME $MAVEN_HOME/ref  && \
    curl -Lo maven.tgz $MAVEN_BASE_URL/apache-maven-$MAVEN_VERSION-bin.tar.gz 2> /dev/null && \
    echo "$MAVEN_SHA  maven.tgz" | sha512sum -c - && \
    tar xzf maven.tgz -C $MAVEN_HOME --strip-components=1 && \
    ln -s $MAVEN_HOME/bin/mvn /usr/local/bin/mvn && \
    curl -Lo sencha.zip \
             http://cdn.sencha.com/cmd/$SENCHA_VERSION/no-jre/SenchaCmd-$SENCHA_VERSION-linux-amd64.sh.zip 2> /dev/null && \
    unzip sencha.zip && \
    ./SenchaCmd-$SENCHA_VERSION-linux-amd64.sh -q -d --illegal-access=warn -dir /usr/local/sencha/$SENCHA_VERSION && \
    mkdir -p sencha/repo && \
    chmod 777 sencha/repo && \
    ln -s /usr/local/sencha/sencha-$SENCHA_VERSION /usr/local/bin/sencha && \
    rm sencha/$SENCHA_VERSION/bin/linux-x64/node/node && \
    ln -s /usr/bin/node /usr/local/sencha/$SENCHA_VERSION/bin/linux-x64/node/node && \
    rm -rf linux-* *.tgz *.zip *.sh java/lib/src.zip java/legal java/[mNr]* /root/.[cjn]* /var/cache/apk/*

# Chromium: Taken from https://stackoverflow.com/a/48295423
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add -q --no-cache chromium chromium-chromedriver nss@edge && \
  rm -rf /var/cache/apk/*

EXPOSE 4444

CMD ["bash"]
