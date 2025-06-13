# toolbox
toolbox docker image to be used for debugging network in kubernetes cluster



## Usage

To use it in the AKS:

To use it in the local machine:

```bash
docker pull "ghcr.io/eguisse/toolbox:latest"

docker run -it --rm ghcr.io/eguisse/toolbox:latest /bin/bash
```


To become root:

```bash
sudo su -
```


## Tools installed

* curl
* openssl
* jq
* dig
* nslookup
* net-tools
* mssql-tools
* mongodb-tools
* redis-tools


