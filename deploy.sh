#!/usr/bin/env bash

set -e

source_dir=${1}
bucket=${2}
input_version=${3}

HUGO_ENV="production"

publish_version=$(./get_version.sh ${input_version})
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

if [[ -z ${source_dir} ]]
then
  echo No content in source dir, aborting deploy
  exit 1
else
  echo "Deploying contents of ${source_dir} to ${bucket}/${publish_version}"
  # Add -public-access to make objects public for public site
  s3deploy -bucket ${bucket} -region us-west-2 -source ${source_dir} -path ${publish_version}
fi

