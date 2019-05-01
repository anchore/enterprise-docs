#!/usr/bin/env bash
set -e

# The url for the base, e.g. http://docs.anchore.com/
site_prefix=${1}

# The version to deploy, if available. If not, use the versions file
this_version=${2}
pub_path=""
versions=$(./get_version.sh ${this_version})
publish_version=$(echo ${versions} | cut -f 1 -d ' ')
latest_version=$(echo ${versions} | cut -f 2 -d ' ')

if [[ -z ${publish_version} ]]
then
  echo "No version found"
  exit 1
fi

export HUGO_ENV="production"

rm -rf public/

if [[ -n "${site_prefix}" ]]
then
  if [[ ${publish_version} = ${latest_version} ]]
  then
    echo Building "current" version
    pub_path="current"
  else
    echo Building non-current version ${publish_version}
    pub_path=${publish_version}
  fi

  echo Building with site prefix ${site_prefix}/${pub_path}
  hugo --gc -b ${site_prefix}/${pub_path}
else
  hugo --gc
fi
