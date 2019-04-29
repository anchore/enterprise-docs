#!/usr/bin/env bash

# Get the version, use the input param if available, but if not, use the versions file
version=${1}

# Use the last version in the version file as 'current' and if matches, set up this deploy as current
if [[ -z "${version}" ]]
then
  # Get the last version in the versions file
  version=$(cat versions | tr -s '\n' | tail -n 1)
fi

# Verify the format is correct
if ! echo ${version} | grep -E -q '^[[:digit:]]+\.[[:digit:]]+(\.[[:digit:]]+)?$'
then
  echo "Invalid version ${version}, must be a semver with digits and period only" >&2
  exit 1
else
  echo ${version}
fi
