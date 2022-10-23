# CoreMedia Build Image

This repository provides a Docker image with the few required tools to build
[CoreMedia][coremedia] Platforms starting from 17nm up to 22nm as used in
CoreMedia Content Cloud 11, CoreMedia Content Cloud 10, CMS-9, and CoreMedia
Live Context 3 workspaces.

Ready to use examples for some CI environments are also included for unchanged
integration with platform workspaces without customizations.

The home for the sources to create the image lives at [GitHub][github] with a
mirror at [GitLab][gitlab].


## Feedback

Please use the [issues][issues] section of this repository at [GitHub][github]
for feedback. 


## Goals

This image is intended for use in container based CI system like the
[GitLab][gitlabci] CI or [GitHub][actions] Actions. Example starting points are
included with this repository.

Also, some common tools for additional preparation steps are included like

* `git`
* `gnupg`
* `cosign`
* `openssh`

and some compression tools.


## Availability

This container can be used via the canonical name `provocon/coremedia-build`.
The tag `latest` should be expected to usable for the latest release by
[CoreMedia][coremedia].

Tags are named after the first release for which the implemented changes are
required. Thus, `1801` can be used for releases e.g. cms-9-1801 and onwards. 
`1904` is the last release intended for CMS-9 and LiveContext 3, while `1907`
is the first release for CMCC-10, which can be used at least up to CMCC-10-2004.
The latest Tag works with - at least again - CMCC-11-2207.


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
docker build -t provocon/coremedia-build:2207.1 .
docker build -t provocon/coremedia-build:2207 .
docker build -t provocon/coremedia-build:latest .
```

```
docker push provocon/coremedia-build:2207.1
docker push provocon/coremedia-build:2207
docker push provocon/coremedia-build:latest
```

### Scripted Build

Alternatively, you could use the [Gradle Build Tool][gradle] and issue

```
./gradlew -PbuildTag=2207.1 dockerPush
./gradlew -PbuildTag=2207   dockerPush
./gradlew -PbuildTag=latest dockerPush
```

which does all the steps above for you.


## Test

Test the generated resulting container with

```
$ docker run --name docker --rm -it --entrypoint=docker provocon/coremedia-build version
Client:
 Version:           20.10.18
 API version:       1.41
 Go version:        go1.18.6
 Git commit:        b40c2f6
 Built:             Thu Sep  8 23:05:51 2022
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
Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
Maven home: /usr/local/maven
Java version: 11.0.16.1, vendor: Eclipse Adoptium, runtime: /usr/local/jdk-11.0.16.1+1
Default locale: de_DE, platform encoding: UTF-8
OS name: "linux", version: "5.10.0-18-amd64", arch: "amd64", family: "unix"
```

```
$ docker run --name sencha --rm -it --entrypoint=sencha provocon/coremedia-build which
Sencha Cmd v7.6.0.87
/usr/local/sencha/7.6.0.87/
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
[dockerhub]: https://hub.docker.com/
[issues]: https://github.com/provocon/coremedia-build-docker/issues
[github]: https://github.com/provocon/coremedia-build-docker
[gitlab]: https://gitlab.com/provocon/coremedia-build-docker
