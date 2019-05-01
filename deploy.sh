#!/usr/bin/env bash

set -e

source_dir=${1}
bucket=${2}
input_version=${3}

latest_version_path="current/"

HUGO_ENV="production"

versions=$(./get_version.sh ${input_version})
publish_version=$(echo ${versions} | cut -f 1 -d ' ')
latest_version=$(echo ${versions} | cut -f 2 -d ' ')

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
fi

if [[ ${publish_version} = ${latest_version} ]]
then
  echo Publish version is the latest version, publishing to the current/ path

  echo "Deploying contents of ${source_dir} to ${bucket}/${latest_version_path}"
  # Add -public-access to make objects public for public site
  s3deploy -bucket ${bucket} -region us-west-2 -source ${source_dir} -path ${latest_version_path}
else
  echo "Deploying contents of ${source_dir} to ${bucket}/${publish_version}"
  # Add -public-access to make objects public for public site
  s3deploy -bucket ${bucket} -region us-west-2 -source ${source_dir} -path ${publish_version}

fi

