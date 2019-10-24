 ## Build
```shell script
docker build -t blackappsolutions/alpine-docker-jdk11-maven3.6:1 .
docker build -f Dockerfile.1.SenchaPhantom -t blackappsolutions/coremedia-build:1907.1 .
```      
## Test
```shell script
$ docker run --name mvn --rm -it --entrypoint=mvn 91488c7152da -v
Apache Maven 3.6.1 (d66c9c0b3152b2e69ee9bac180bb8fcc8e6af555; 2019-04-04T19:00:29Z)
Maven home: /usr/share/maven
Java version: 11.0.4, vendor: AdoptOpenJDK, runtime: /opt/java/openjdk
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "4.9.184-linuxkit", arch: "amd64", family: "unix"

$ docker run --name mvn --rm -it --entrypoint=sencha d52dfb1624c3 which
Sencha Cmd v6.7.0.63
/usr/local/sencha/6.7.0.63/
```      
