# CoreMedia Build Image

This repository provides an image for use with [podman][podman], Docker, and
similar systems with the required tools to build [CoreMedia][coremedia] Content
Cloud 11, CoreMedia Content Cloud 10, CMS-9, and CoreMedia Live Context 3
workspaces. Supports platform versions range from 17nm to 22nm.

Images started to be available for AMD64/x86_64 and ARM64/Aarch64 respectively.

Ready to use examples for some CI environments are also included for unchanged
integration with platform workspaces without customizations.

The home for the sources to create the image lives at [GitHub][github] with a
mirror at [GitLab][gitlab].


## Feedback

Please use the [issues][issues] section of this repository at [GitHub][github]
for feedback.


## Goals

This image is intended for use in container based CI systems like the
[GitLab CI][gitlabci] or [GitHub Actions][actions]. Example starting points are
included with this repository, which work within the bounds of the public
shared runner limitations.

Also, some common tools for additional preparation steps are included like

* `git`
* `gnupg`
* `cosign`
* `openssh`

and some compression tools.

We like to support different hardware architectures where appropriate.


## Availability

This container can be used via the canonical name `provocon/coremedia-build`.
The tag `latest` should be expected to usable for the latest release by
[CoreMedia][coremedia].

Tags are named after the first release for which the implemented changes are
required. Thus, `1801` can be used for releases e.g. cms-9-1801 and onwards.
`1904` is the last release intended for CMS-9 and LiveContext 3, while `1907`
is the first release for CMCC-10, which can be used at least up to CMCC-10-2004.
The latest Tag works with - at least again - CMCC-11-2301.

Unpublished, daily builds are available from the [GitHub][github] and
[GitLab][gitlab] project registries.


## Usage

See the `examples/` directory with usage examples and don't forget the
[Maven][maven] and [NPM][npm] registry setup.

Examples for builds with [GitLab CI][gitlabci] and [GitHub Actions][actions]
will need the additional files in `examples/workspace-configuration` and
a personal `npmrc` needs to be created through `npm-registry-login.sh`.

Perhaps you still need to mind some parameters when building CoreMedia Content
Cloud, e.g.

```
mvn install -Dwebdriver.chrome.driver=/usr/bin/chromedriver -Dwebdriver.chrome.verboseLogging=true -DjooUnitWebDriverBrowserArguments=--no-sandbox,--disable-dev-shm-usage
```

So, with [GitLab CI][gitlabci] and [GitHub Actions][actions] the steps are

### Adding files

* `workspace-configuration/maven-settings.xml`
* `.gitlab-ci.yml`

### Adding secrets

These values have to be added as CI variables for GitLab or action secrets for
GitHub respectively.

CoreMedia Maven Artifacts Repository User and Password:

* CM_MAVEN_USER
* CM_MAVEN_PASSWORD

CoreMedia NPM Registry Token:

* NPMRC_TOKEN

Optionally add Maven Options

* MAVEN_OPTS

and use Docker Hub login to extend the download rate.

* DH_REGISTRY_USER
* DH_REGISTRY_PASSWORD


## Build

### Manual Build

The preparation of the container is accomplished using the usual

```
docker build -t <myname> .
```

So, for the current version, this is

```
docker build -t provocon/coremedia-build:2110.6 .
docker build -t provocon/coremedia-build:2110 .
docker build -t provocon/coremedia-build:latest .
```

```
docker push provocon/coremedia-build:2110.6
docker push provocon/coremedia-build:2110
docker push provocon/coremedia-build:latest
```

You could as well use [podman][podman] instead of docker in each of the lines.


### Scripted Build

Alternatively, you could use the [Gradle Build Tool][gradle] and issue

```
./gradlew -Ptag=2110.6 dockerPush
./gradlew -Ptag=2110   dockerPush
./gradlew -Ptag=latest dockerPush
```

which does all the steps above for you.


## Test

Test the generated resulting container with

```
$ docker run --name docker --rm -it --entrypoint=docker provocon/coremedia-build version
Client:
 Version:           20.10.20
 API version:       1.41
 Go version:        go1.18.7
 Git commit:        9fdeb9c
 Built:             Tue Oct 18 18:14:26 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true
```

```
$ docker run --name buildx --rm -it --entrypoint=docker provocon/coremedia-build buildx version
github.com/docker/buildx v0.9.1 ed00243a0ce2a0aee75311b06e32d33b44729689
```

```
$ docker run --name mvn --rm -it --entrypoint=mvn provocon/coremedia-build -v
Apache Maven 3.8.8 (4c87b05d9aedce574290d1acc98575ed5eb6cd39)
Maven home: /usr/local/maven
Java version: 11.0.18, vendor: Azul Systems, Inc., runtime: /usr/local/zulu11.62.17-ca-jdk11.0.18-linux_musl_x64
Default locale: de_DE, platform encoding: UTF-8
OS name: "linux", version: "5.10.0-19-amd64", arch: "amd64", family: "unix"
```

```
$ docker run --name sencha --rm -it --entrypoint=sencha provocon/coremedia-build which
Sencha Cmd v7.2.0.84
/usr/local/sencha/7.2.0.84/
```

```
$ docker run --name docker --rm -it --entrypoint=node provocon/coremedia-build -v
v16.20.0
```

To call the container image use

```
docker run -it --rm provocon/coremedia-build /bin/bash
```

[sencha]: https://www.sencha.com/products/extjs/cmd-download/
[coremedia]: http://www.coremedia.com/
[maven]: https://maven.apache.org/
[gradle]: https://gradle.org/
[npm]: https://www.npmjs.com/
[gitlabci]: https://docs.gitlab.com/ee/ci/
[actions]: https://github.com/features/actions
[podman]: https://podman.io/
[dockerhub]: https://hub.docker.com/
[issues]: https://github.com/provocon/coremedia-build-docker/issues
[github]: https://github.com/provocon/coremedia-build-docker
[gitlab]: https://gitlab.com/provocon/coremedia-build-docker
