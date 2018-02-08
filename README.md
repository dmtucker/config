# config

[![Build Status](https://img.shields.io/travis/dmtucker/config.svg)](https://travis-ci.org/dmtucker/config) [![Docker Build Status](https://img.shields.io/docker/automated/dmtucker/config.svg)](https://hub.docker.com/r/dmtucker/config/)


All you need is `make`.

``` sh
make help
```

* Note: Only Debian is officially supported.

## bash

``` bash
env | less
declare -f
alias
```

# Automatic Deployment


``` sh
wget -qO- https://dmtucker.github.io/config/deploy.sh | sh
```

OR

``` sh
curl -sSL https://dmtucker.github.io/config/deploy.sh | sh
```
