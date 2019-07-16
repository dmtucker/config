# Contributing Guidelines

[GitHub](https://github.com/) hosts the project.

## Development

Develop changes by [forking](https://help.github.com/articles/fork-a-repo) and [cloning](https://help.github.com/articles/cloning-a-repository) this repository.

[![GitHub forks](https://img.shields.io/github/forks/dmtucker/config.svg)](https://github.com/dmtucker/config/network/members)
[![GitHub repo size](https://img.shields.io/github/repo-size/dmtucker/config.svg)](https://github.com/dmtucker/config)

### Version Control

Use [`git`](https://git-scm.com/doc) to manage the project source code.

``` sh
git add -p
git status
git commit -S
git log
```

### Test Environment

Use [`docker`](https://docs.docker.com/) to deploy and run the project source code.

``` sh
docker build -t dmtucker/config:dev .  # Build the project.
docker run -it dmtucker/config:dev     # Deploy the project.
```

## Continuous Integration

Discuss changes by [creating an issue](https://help.github.com/articles/creating-an-issue).
Propose changes by [creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

[![GitHub issues](https://img.shields.io/github/issues/dmtucker/config.svg)](https://github.com/dmtucker/config/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/dmtucker/config.svg)](https://github.com/dmtucker/config/pulls)

### Automation

[Docker Cloud](https://cloud.docker.com/) builds, tests, and deploys the project to [Docker Hub](https://hub.docker.com/).

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/dmtucker/config.svg)](https://cloud.docker.com/repository/docker/dmtucker/config)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmtucker/config.svg)](https://hub.docker.com/r/dmtucker/config)

## Releases

Publish changes by [creating a release](https://help.github.com/articles/creating-releases).

[![GitHub release](https://img.shields.io/github/release/dmtucker/config.svg)](https://github.com/dmtucker/config/releases)

1. [Change the version.](https://semver.org/)
2. [Create a tag.](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
3. [Release the tag.](https://help.github.com/articles/about-releases)
