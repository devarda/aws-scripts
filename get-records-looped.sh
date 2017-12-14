#!/usr/bin/env bash

trap 'exit 1' ERR

STREAM_NAME=$1; shift
LIMIT=$1; shift

SHARD_ID=$(aws kinesis describe-stream --stream-name ${STREAM_NAME} | jq -r '.StreamDescription.Shards[0].ShardId')
SHARD_ITERATOR=$(aws kinesis get-shard-iterator --stream-name ${STREAM_NAME} --shard-id ${SHARD_ID} --shard-iterator-type TRIM_HORIZON | jq -r '.ShardIterator')
>&2 echo Quering records…
until [[ ${RECORDS} ]]; do
    RECORDS=$(aws kinesis get-records --shard-iterator ${SHARD_ITERATOR} --limit ${LIMIT})
    >&2 echo MillisBehindLatest: $(echo ${RECORDS} | jq -r '.MillisBehindLatest')
    SHARD_ITERATOR=$(echo ${RECORDS} | jq -r '.NextShardIterator')
    RECORDS=$(echo ${RECORDS} | jq '.Records[]')
done
echo ${RECORDS}