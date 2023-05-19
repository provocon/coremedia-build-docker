# CoreMedia Build Image

This repository provides an image for use with [podman][podman], Docker, and
similar systems with the required tools to build [CoreMedia][coremedia] Content
Cloud 11, Content Cloud 10, CMS-9, and CoreMedia Live Context 3 workspaces.
Supports platform versions range from 17nm to 23nm.

Images started to be available for AMD64/x86_64 and ARM64/Aarch64 respectively.

Ready to use examples for some CI environments are also included. They are
meant for unchanged integration with platform workspaces in their state without
any customizations. Thus they should form a good starting point for real world
projects.

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
The tag `latest` should be expected to be usable for the latest release by
[CoreMedia][coremedia].

Tags are named after the first release for which the implemented changes are
required. Thus, `1801` can be used for releases e.g. cms-9-1801 and onwards.
`1904` is the last release intended for CMS-9 and LiveContext 3, while `1907`
is the first release for CMCC-10, which can be used at least up to CMCC-10-2004.
The latest Tag works with - at least again - CMCC-11-2304.

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

* `CM_MAVEN_USER`
* `CM_MAVEN_PASSWORD`

CoreMedia NPM Registry Token:

* `NPMRC_TOKEN`

Optionally add Maven Options

* `MAVEN_OPTS`

and use Docker Hub login to extend the download rate.

* `DH_REGISTRY_USER`
* `DH_REGISTRY_PASSWORD`


## Build

### Manual Build

The preparation of the container is accomplished using the usual

```
docker build -t <myname> .
```

So, for the current version, this is

```
docker build -t provocon/coremedia-build:2304.1 .
docker build -t provocon/coremedia-build:2304 .
docker build -t provocon/coremedia-build:latest .
```

```
docker push provocon/coremedia-build:2304.1
docker push provocon/coremedia-build:2304
docker push provocon/coremedia-build:latest
```

You could as well use [podman][podman] instead of docker in each of the lines.


### Scripted Build

Alternatively, you could use the [Gradle Build Tool][gradle] and issue

```
./gradlew -Ptag=2304.1 dockerPush
./gradlew -Ptag=2304   dockerPush
./gradlew -Ptag=latest dockerPush
```

which does all the steps above for you.


## Test

Test the generated resulting container with

```
$ docker run --name docker --rm -it --entrypoint=docker provocon/coremedia-build version
lient:
 Version:           20.10.24
 API version:       1.41
 Go version:        go1.19.7
 Git commit:        297e128
 Built:             Tue Apr  4 18:17:06 2023
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true
```

```
$ docker run --name buildx --rm -it --entrypoint=docker provocon/coremedia-build buildx version
github.com/docker/buildx v0.10.4 c513d34049e499c53468deac6c4267ee72948f02
```

```
$ docker run --name mvn --rm -it --entrypoint=mvn provocon/coremedia-build -v
Apache Maven 3.8.8 (4c87b05d9aedce574290d1acc98575ed5eb6cd39)
Maven home: /usr/local/maven
Java version: 11.0.19, vendor: Azul Systems, Inc., runtime: /usr/local/zulu11.64.19-ca-jdk11.0.19-linux_musl_x64
Default locale: de_DE, platform encoding: UTF-8
OS name: "linux", version: "5.10.0-21-amd64", arch: "amd64", family: "unix"
```

```
$ docker run --name sencha --rm -it --entrypoint=sencha provocon/coremedia-build which
Sencha Cmd v7.6.0.87
/usr/local/sencha/7.6.0.87/
```

```
$ docker run --name node --rm -it --entrypoint=node provocon/coremedia-build -v
v18.16.0
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
