# CSM Docker: SLE Go

A SLE Server GoLang Docker image used for RPM builds.

## Building

The provided `Makefile` adds Jenkins Pipeline variables to the `docker build` command. The commands below are for use outside of the CSM Jenkins Pipeline.

```bash
export DOCKER_BUILDKIT=1
export SLES_REGISTRATION_CODE=<registration_code>

# Build GoLang with the latest GoLang from https://go.dev/VERSION?m=text
docker build --secret id=SLES_REGISTRATION_CODE .

# Build GoLang 1.18
docker build --secret id=SLES_REGISTRATION_CODE --build-arg GO_VERSION=go1.18 .

```

## Running

```bash
# Latest
docker run -it artifactory.algol60.net/csm-docker/stable/csm-docker-sle-go:latest

# Go Version
docker run -it artifactory.algol60.net/csm-docker/stable/csm-docker-sle-go:1.17

# Git Hash
docker run -it artifactory.algol60.net/csm-docker/stable/csm-docker-sle-go:<hash>
```

## GoLang Version(s)

The version is controlled by the `Dockerfile`. Each image built and pushed to Artifactory is tagged with:
- `latest`
- A short Git hash
- The GO Version from the [`Jenkinsfile`](https://github.com/Cray-HPE/csm-docker-sle-go/blob/main/Jenkinsfile.github#L4)

