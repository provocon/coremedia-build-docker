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
FROM docker:20.10

ARG MAVEN_VERSION=3.9.6
ARG MAVEN_SHA=706f01b20dec0305a822ab614d51f32b07ee11d0218175e55450242e49d2156386483b506b3a4e8a03ac8611bae96395fd5eec15f50d3013d5deed6d1ee18224
ARG USER_HOME_DIR="/root"
ARG MAVEN_BASE_URL=https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries
ARG HELM_VERSION=3.14.0
ARG SENCHA_VERSION=7.6.0.87
ARG PNPM_VERSION=8.14.1
ARG MAINTAINER='PROVOCON https://codeberg.org/provocon'
ARG JDK_VERSIONS="amd64:11.0.22:11.70.15\narm64:11.0.21:11.68.17"

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
ENV PATH="$PATH:/usr/local/sencha:$JAVA_HOME/bin"
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
    echo "Installing SenchaCmd" && \
    URL="http://cdn.sencha.com/cmd/$SENCHA_VERSION/no-jre/SenchaCmd-$SENCHA_VERSION-linux-amd64.sh.zip" && \
    curl -Lo sencha.zip $URL 2> /dev/null && \
    unzip sencha.zip && \
    ./SenchaCmd-$SENCHA_VERSION-linux-amd64.sh -q -d --illegal-access=warn \
               -dir /usr/local/sencha/$SENCHA_VERSION && \
    mkdir -p sencha/repo && \
    chmod 777 sencha/repo && \
    ln -s /usr/local/zulu11* /usr/local/sencha/$SENCHA_VERSION/jre && \
    ln -s /usr/local/sencha/sencha-$SENCHA_VERSION /usr/local/bin/sencha && \
    rm sencha/$SENCHA_VERSION/bin/linux-x64/node/node && \
    ln -s $(which node) /usr/local/sencha/$SENCHA_VERSION/bin/linux-x64/node/node && \
    echo "Cleaning Up" && \
    rm -rf linux-* *.tgz *.zip *.sh java/lib/src.zip java/legal java/[mNr]* /root/.[cjn]* /var/cache/apk/*

CMD ["bash"]
