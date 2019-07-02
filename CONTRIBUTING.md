# Contributing Guidelines

[GitHub](https://github.com/) hosts the project.

[![GitHub repo size](https://img.shields.io/github/repo-size/dmtucker/config.svg)](https://github.com/dmtucker/config)

## Development

Discuss changes by [creating an issue](https://help.github.com/articles/creating-an-issue).

[![GitHub issues](https://img.shields.io/github/issues/dmtucker/config.svg)](https://github.com/dmtucker/config/issues)

### Version Control

Use [`git`](https://git-scm.com/doc) to retrieve and manage the project source code.

``` sh
git clone https://github.com/dmtucker/config.git
```

### Test Environment

Use [`docker`](https://docs.docker.com/) to deploy and run the project source code.

``` sh
docker build -t dmtucker/config:dev .  # Build the project.
docker run -it dmtucker/config:dev     # Deploy the project.
```

## Merges

Propose changes by [creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

[![GitHub pull requests](https://img.shields.io/github/issues-pr/dmtucker/config.svg)](https://github.com/dmtucker/config/pulls)

- [Branch protection](https://help.github.com/articles/about-protected-branches/) enforces acceptance criteria.
- [Milestones](https://help.github.com/en/articles/about-milestones) serve as a changelog for the project.
- [Labels](https://help.github.com/en/articles/about-labels) track the intent of each change.

### Continuous Integration

[Travis CI](https://travis-ci.com/) builds, tests, and deploys the project automatically.

[![Travis (.com) branch](https://img.shields.io/travis/com/dmtucker/config/master.svg)](https://travis-ci.com/dmtucker/config)

## Releases

Distribute changes by [creating a release](https://help.github.com/en/articles/creating-releases).

[![GitHub release](https://img.shields.io/github/release/dmtucker/config.svg)](https://github.com/dmtucker/config/releases)

1. [Change the version.](http://semver.org/)
2. [Create a tag.](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
3. [Release the tag.](https://help.github.com/en/articles/creating-releases)

### Package Repository

[Docker Hub](https://hub.docker.com/) distributes releases.

[![Docker Build Status](https://img.shields.io/docker/build/dmtucker/config.svg)](https://cloud.docker.com/repository/docker/dmtucker/config)
