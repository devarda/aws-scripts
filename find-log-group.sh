#!/usr/bin/env bash

SUBSTRING=$1; shift
: "${SUBSTRING:?Need to set SUBSTRING non-empty}"

aws logs describe-log-groups | jq '.logGroups[] | select(.logGroupName | contains("'${SUBSTRING}'")) | .logGroupName'
