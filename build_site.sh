#!/usr/bin/env bash

path_prefix=${1}
HUGO_ENV="production"


if [[ "$path_prefix" = "master" ]]
then
  path_prefix=""
  hugo --gc -b http://anchore-enterprise-docs-test.s3-website.us-west-2.amazonaws.com/${path_prefix}
  cp versions.json public/

elif [[ -n "$path_prefix" ]]
then
  hugo --gc -b http://anchore-enterprise-docs-test.s3-website.us-west-2.amazonaws.com/${path_prefix}
else
  exit 1
fi

