# Use Jenkins for CMCC on Cloud

Example configuration for the use of the container 
`blackappsolutions/coremedia-build:CMCC_S-2010.2` in a custom Jenkins instance.

CMCC-S stands for the `On Cloud` flavour of `CoreMedia Content Cloud` as hosted 
by the vendor.

## Purpose

You may ask: Why not using the Jenkins also provided by CoreMedia?

At the moment this Jenkins has several restrictions and is not capable of 
being used as a gate-keeper for pull-requests.

So the idea came up to use a separate jenkins for this purpose.

## Usage

With the `On Cloud` configuration you don't get your own account to access the 
central CoreMedia Nexus Artifact Repository containing all the artifacts needed  
by the Apache Maven based build.

Thus, you will have to use an SSH tunnel (with sshuttle) to the sandbox of your 
`On Cloud` environment to access the Nexus provided there.

To do so, you need to create a key pair for SSH access in the CMCC-S cloud 
manager upfront and store the private key part of this pair there. The even 
better option would be to use some credential storage inside Jenkins.

To make this clear the file `example-usage-jenkins-pipeline/workspace-configuration/id_rsa_CLIENTNAME_jenkins` 
is provided empty.

To make the example work, replace all `CLIENTNAME` ocurances with the actual 
client name you got from your customer. 
