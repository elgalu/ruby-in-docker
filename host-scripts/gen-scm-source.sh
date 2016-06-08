#!/usr/bin/env bash

GIT_AUTHOR=lgallucci
GIT_URL="https://github.com/elgalu/docker-ruby"
GIT_SHA1=$(git rev-parse HEAD)

cat >scm-source.json <<EOF
{
    "url": "${GIT_URL}",
    "revision": "${GIT_SHA1}",
    "author": "${GIT_AUTHOR}",
    "status": ""
}
EOF
