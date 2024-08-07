#
# Copyright 2017-2024 Martin Goellnitz, Markus Schwarz.
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
FROM docker:26.0

ARG MAVEN_VERSION=3.9.8
ARG MAVEN_SHA=7d171def9b85846bf757a2cec94b7529371068a0670df14682447224e57983528e97a6d1b850327e4ca02b139abaab7fcb93c4315119e6f0ffb3f0cbc0d0b9a2
ARG USER_HOME_DIR="/root"
ARG MAVEN_BASE_URL=https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries
ARG HELM_VERSION=3.15.2
ARG PNPM_VERSION=9.4.0
ARG MAINTAINER='PROVOCON https://codeberg.org/provocon'
ARG JDK_VERSIONS="amd64:17.0.11:17.50.19\narm64:17.0.11:17.50.19"

LABEL maintainer="$MAINTAINER"
LABEL Maven="$MAVEN_VERSION"
LABEL Helm="$HELM_VERSION"
LABEL PNPM="$PNPM_VERSION"

ENV DOCKER_TLS_CERTDIR=/certs
ENV MAVEN_HOME /usr/local/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV JAVA_HOME=/usr/local/java
ENV PNPM_HOME=/usr/local/bin
ENV PATH="$PATH:$JAVA_HOME/bin"
ENV LANG='de_DE.UTF-8' LANGUAGE='de_DE:en' LC_ALL='de_DE.UTF-8'
ENV DISPLAY :20.0
ENV SCREEN_GEOMETRY "1440x900x24"

WORKDIR /usr/local

# The tools cosign, xz, zip, openssh etc are helpers for common CI usages
RUN apk update && \
    apk upgrade && \
    apk add -q curl ca-certificates xz zip parallel sudo git bash openssh-client font-noto gnupg nodejs npm libxext libxrender libxtst libxi cosign && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    fc-cache -f && \
    PATH=/usr/bin:$PATH && \
    npm install -g pnpm@$PNPM_VERSION && \
    mkdir -p $MAVEN_HOME $MAVEN_HOME/ref  && \
    curl -Lo maven.tgz $MAVEN_BASE_URL/apache-maven-$MAVEN_VERSION-bin.tar.gz 2> /dev/null && \
    echo "$MAVEN_SHA  maven.tgz" | sha512sum -c - && \
    tar xzf maven.tgz -C $MAVEN_HOME --strip-components=1 && \
    ln -s $MAVEN_HOME/bin/mvn /usr/local/bin/mvn && \
    ARCH=$(uname -m|sed -e 's/x86_64/amd64/g'|sed -e 's/aarch64/arm64/g') && \
    MACHINE=$(uname -m|sed -e 's/86_//g') && \
    echo "Detecting architecture $ARCH / $MACHINE" && \
    curl -Lo helm.tgz "https://get.helm.sh/helm-v$HELM_VERSION-linux-$ARCH.tar.gz" 2> /dev/null && \
    tar xzf helm.tgz && \
    mv linux-$ARCH/helm bin && \
    JDK_VERSION=$(echo -e $JDK_VERSIONS|grep $ARCH|cut -d ':' -f 2) && \
    AZUL_VERSION=$(echo -e $JDK_VERSIONS|grep $ARCH|cut -d ':' -f 3) && \
    echo "Installing Java $JDK_VERSION / $AZUL_VERSION" && \
    URL="https://cdn.azul.com/zulu/bin/zulu$AZUL_VERSION-ca-jdk$JDK_VERSION-linux_musl_$MACHINE.tar.gz" && \
    curl -Lo java.tgz $URL 2> /dev/null && \
    tar xzf java.tgz && \
    ln -s zulu* java && \
    rm -rf linux-* *.tgz *.zip *.sh java/lib/src.zip java/legal java/[mNr]* /root/.[cjn]* /var/cache/apk/*

CMD ["bash"]
