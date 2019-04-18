#!/usr/bin/env bash

path_prefix=${1}
HUGO_ENV="production"


if [[ "$path_prefix" = "master" ]]
then
  path_prefix=""
  hugo --gc -b http://anchore-enterprise-docs-test.s3-website.us-west-2.amazonaws.com/${path_prefix}
  cp versions.json public/

  # This is a temp location for testing, to update with version path etc before final version
  s3deploy -bucket anchore-enterprise-docs-test -region us-west-2 -source public/
elif [[ -n "$path_prefix" ]]
then
  hugo --gc -b http://anchore-enterprise-docs-test.s3-website.us-west-2.amazonaws.com/${path_prefix}
  s3deploy -bucket anchore-enterprise-docs-test -region us-west-2 -source public/ -path ${path_prefix}
else
  exit 1
fi

#s3deploy -bucket ${DEST_BUCKET} -path ${PUBLISH_VERSION} -public-access -source public/

