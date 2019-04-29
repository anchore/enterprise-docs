#!/usr/bin/env bash

set -e

source_dir=${1}
input_version=${2}
bucket=${3}

HUGO_ENV="production"

publish_version=$(./get_version.sh)
echo "Publish version = ${publish_version}"

if [[ -z "${source_dir}" ]]
then
  echo "Source dir not set. Quitting deploy"
  exit 1
fi

if [[ -z "${bucket}" ]]
then
  echo "Bucket must be set. Quitting deploy"
  exit 1
fi


# Use the last version in the version file as 'current' and if matches, set up this deploy as current
latest_version=$(cat versions | tr -s '\n' | tail -n 1)
echo Current latest version = ${latest_version}
if [[ "${publish_version}" = ${latest_version} ]]
then
  echo "Publish version is current version, also deploying to latest/"
  s3deploy -bucket ${bucket} -region us-west-2 -source ${source_dir} -path latest/
fi

echo "Deploying contents of ${source_dir} to ${bucket}/${publish_version}"
# Add -public-access to make objects public for public site
s3deploy -bucket ${bucket} -region us-west-2 -source ${source_dir} -path ${publish_version}

