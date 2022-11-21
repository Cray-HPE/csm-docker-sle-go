# MIT License
# 
# (C) Copyright [2021-2022] Hewlett Packard Enterprise Development LP
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

# Find the latest go-version here: https://go.dev/VERSION?m=text
ARG GO_VERSION=''
ENV GOCACHE=/tmp

RUN if [ -z "${GO_VERSION}" ]; then export GO_VERSION="$(curl https://golang.org/VERSION?m=text)"; fi

RUN curl -O "https://dl.google.com/go/$GO_VERSION.linux-amd64.tar.gz" \
    && tar -C /usr/local -xzf "$GO_VERSION.linux-amd64.tar.gz"

ENV PATH="$PATH:/usr/local/go/bin"

RUN SUSEConnect --cleanup
WORKDIR /build
