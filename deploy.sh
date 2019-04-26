#!/usr/bin/env bash

path_prefix=${1}
HUGO_ENV="production"


if [[ "$path_prefix" = "master" ]]
then
  path_prefix=""

  # This is a temp location for testing, to update with version path etc before final version
  s3deploy -bucket anchore-enterprise-docs-test -region us-west-2 -source public/
elif [[ -n "$path_prefix" ]]
then
  s3deploy -bucket anchore-enterprise-docs-test -region us-west-2 -source public/ -path ${path_prefix}
else
  exit 1
fi

#s3deploy -bucket ${DEST_BUCKET} -path ${PUBLISH_VERSION} -public-access -source public/

