#!/usr/bin/env bash

BUILD_AUTHOR="jwalter"
BUILD_NAME="postman"
BUILD_VERSION="${VERSION:-0.1.0}"

if grep -qE '^(y(es)?|t(rue)?|1)$' <<<"${LATEST}"; then
	BUILD_LATEST=("--tag" "${BUILD_AUTHOR}/${BUILD_NAME}:latest")
elif grep -qE '^(no?|f(alse)?|0)$' <<<"${LATEST}"; then
	BUILD_LATEST=()
else
	BUILD_LATEST=()
fi

docker build --squash --tag "${BUILD_AUTHOR}/${BUILD_NAME}:${BUILD_VERSION}" "${BUILD_LATEST[@]}" .
exit $?
