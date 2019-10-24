## Build 'Build'-Container 
without ENTRYPOINT 

```shell script                                    
mvn docker:build
# Test
docker run --name mvn --rm -it --entrypoint=mvn blackappsolutions/coremedia-build:latest -v               
```       
