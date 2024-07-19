# MIT License
#
# (C) Copyright 2022-2024 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
ARG SLE_VERSION
FROM artifactory.algol60.net/csm-docker/stable/csm-docker-sle:${SLE_VERSION} AS base

RUN --mount=type=secret,id=SLES_REGISTRATION_CODE SUSEConnect -r "$(cat /run/secrets/SLES_REGISTRATION_CODE)"
CMD ["/bin/bash"]
FROM base AS go-base

ARG GO_VERSION=''
ENV GOCACHE=/tmp
ARG TARGETPLATFORM

RUN echo "${TARGETPLATFORM}"

# Find the latest go-version here: https://go.dev/VERSION?m=text
# Archived Go versions are not listed at that URL.
# Lookup the latest major.minor.patch version for the desired major.minor version
RUN GO_FULL_VERSION=$(curl -s https://go.dev/dl/#archive | grep -oP "go${GO_VERSION}\.[0-9]+\.${TARGETPLATFORM//\//-}\.tar\.gz" | sort -V | sed -E 's/go([0-9]+\.[0-9]+\.[0-9]+).*/\1/' | tail -1) \
    && curl -OL "https://go.dev/dl/go${GO_FULL_VERSION}.${TARGETPLATFORM//\//-}.tar.gz" \
    && tar -C /usr/local -xzf "go${GO_FULL_VERSION}.${TARGETPLATFORM//\//-}.tar.gz" \
    && rm "go${GO_FULL_VERSION}.${TARGETPLATFORM//\//-}.tar.gz"

ENV PATH="$PATH:/usr/local/go/bin"

RUN SUSEConnect --cleanup
WORKDIR /build
