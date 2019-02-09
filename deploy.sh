#!/usr/bin/env bash

HUGO_ENV="production"

hugo --gc

cp versions.json public/

s3deploy -bucket ${DEST_BUCKET} -path ${PUBLISH_VERSION} -public-access -source public/

