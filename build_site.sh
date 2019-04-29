#!/usr/bin/env bash

site_prefix=${1}
input_tag=${2}

# Expect a semver: 0.0.0-somesuffix or 0.0 or 0.0.1
if ! echo ${input_tag} | grep -E -q '^[[:digit:]]+\.[[:digit:]]+(\.[[:digit:]]+)?(-.*)?$'
then
  echo Unexpected tag format, must use a semver with optional '-' delmited suffix, but expects vX.Y.Z format
  exit 1
fi

publish_version=$(echo $input_tag | cut -d '-' -f 1 | cut -d '.' -f 1,2,3 )
echo "Publish version = ${publish_version}"

HUGO_ENV="production"

if [[ -n "${site_prefix}" ]]
then
  rm -rf public/
  echo Building with site prefix ${site_prefix}/${publish_version}/
  hugo --gc -b ${site_prefix}/${publish_version}/
else
  hugo --gc
fi
