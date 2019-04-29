#!/usr/bin/env bash
set -e

# The url for the base, e.g. http://docs.anchore.com/
site_prefix=${1}

# The version to deploy, if available. If not, use the versions file
this_version=${2}

publish_version=$(./get_version.sh ${this_version})

if [[ -z ${publish_version} ]]
then
  echo "No version found"
  exit 1
fi

export HUGO_ENV="production"

rm -rf public/

if [[ -n "${site_prefix}" ]]
then
  echo Building with site prefix ${site_prefix}/${publish_version}/
  hugo --gc -b ${site_prefix}/${publish_version}/
else
  hugo --gc
fi
