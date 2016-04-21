# config

All you need is `make`.

``` sh
make help
```

## bash

* Minimal
* Lots of Color

``` bash
env | less
declare -f
alias
```

# Docker

[Try this environment out with Docker!](https://registry.hub.docker.com/u/dmtucker/config)


# Auto-deploy

I like to be able to reimage often (or quickly setup a new workstation).
That is what `deploy.sh` is for.

``` sh
wget -qO- https://dmtucker.github.io/config/deploy.sh | sh
```
