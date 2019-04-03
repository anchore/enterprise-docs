#!/usr/bin/env bash

HUGO_ENV="production"

hugo --gc

cp versions.json public/

# This is a temp location for testing, to update with version path etc before final version
s3deploy -bucket anchore-enterprise-docs-test -region us-west-2 -source public/

#s3deploy -bucket ${DEST_BUCKET} -path ${PUBLISH_VERSION} -public-access -source public/

