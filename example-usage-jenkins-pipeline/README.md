Example configuration for the use of the'blackappsolutions/coremedia-build:CMCC_S-2010.2' container.

CMCC-S stands for "CoreMedia Content Cloud" hosted by the vendor.

In this configuration you don't get an account to access the central CoreMedia Nexus containing all the artefacts needed 
by the maven build!

You have to use a ssh tunnel (with sshuttle) to the sandbox environment to access the nexus provided there.

You may ask: why not using the jenkins also provided by CoreMedia?

At the moment this jenkins has several restrictions and is not capable to be used as a gate-keeper for pull-requests.

So the idea came up to use a separate jenkins for this purpose. 

To do so, you need to create upfront in the CMCC-S cloud manager a ssh key pair and store your private key here (or better in some credential storage inside jenkins).

To make this clear the file `example-usage-jenkins-pipeline/workspace-configuration/id_rsa_CLIENTNAME_jenkins` was provided empty.

To make the example work, replace all `CLIENTNAME` ocurances with the actual client name you got from your customer. 
