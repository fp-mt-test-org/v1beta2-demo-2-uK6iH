#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

brew install jfrog-cli

jfrog_output=$(jfrog config show artifactory 2>&1 || true)
does_not_exist_pattern='does not exist'

if [[ ${jfrog_output} =~ ${does_not_exist_pattern} ]]; then
    jfrog c add artifactory \
        --url="${artifactory_base_url}" \
        --user="${artifactory_username}" \
        --access-token="${artifactory_password}" \
        --artifactory-url="${artifactory_base_url}/artifactory" \
        --interactive=false
fi

jfrog rt \
    gradle clean \
    artifactoryPublish -b build.gradle \
    --build-name=v1beta2-demo-2-uK6iH \
    --build-number=1 \
    -Pversion=1.1.0
