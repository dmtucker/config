# config

[![Build Status](https://img.shields.io/travis/dmtucker/config.svg)](https://travis-ci.org/dmtucker/config) [![Docker Build Status](https://img.shields.io/docker/automated/dmtucker/config.svg)](https://hub.docker.com/r/dmtucker/config/)


All you need is `make`.

``` sh
make help
```

## bash

``` bash
env | less
declare -f
alias
```

# Automatic Deployment

I like to be able to reimage often (or quickly setup a new workstation).
That is what `deploy.sh` is for.

``` sh
curl -sSL https://dmtucker.github.io/config/deploy.sh | sh
```
OR
``` sh
wget -qO- https://dmtucker.github.io/config/deploy.sh | sh
```

* Note: Only `dpkg` systems are officially supported.
