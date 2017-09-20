#!/bin/bash

set -e

#Sentinel-3 S3 ingester (https://github.com/asamerh4/sentinel3-s3-ingester) TaskGroupInfo generator
#Author: Hubert Asamer 2017
#jq required

#Creates a TaskGroupInfo Object needed for 'mesos-batch' from a Sentinel-3 product UUID list

#ENV-VARS - START

# CPUS=                    -> CPUS reserved for one ingestion task (int)
# DISK=                    -> DISK space (in MB) needed for one ingestion task (int)
# DOCKER_IMAGE=""          -> Docker image name of Sentinel-3 S3 ingester (string)
# DOCKER_MEM=""            -> Docker engine parameter for ingester mem-setting (string)
# DOCKER_SWAP=""           -> Docker engine parameter for ingester mem-swap-setting (string)
# MEM=                     -> RAM (in MB) needed for one ingestion task (int)
# DATAHUB_USER=""          -> datahub username (string)
# DATAHUB_PW=""            -> datahub-user password (string)
# TARGET_BUCKET_PREFIX=""  -> Bucket where results are written to (string)
# SENTINEL-3-UUID-LIST=""  -> relative path of uuid/url list (string)

#ENV-VARS - END

#JSON skeletons for TaskInfo mesos.proto
export TaskGroupInfo='{"tasks":[]}'
export resources='[{"name":"cpus","type":"SCALAR","scalar":{"value":'$CPUS'}},{"name":"mem","type":"SCALAR","scalar":{"value":'$MEM'}}]'
export command='{"shell": false,"environment":{"variables":[]}}'
export container='{"type":"DOCKER","docker":{"image":"","parameters":[{"key":"memory","value":"'$DOCKER_MEM'"},{"key":"memory-swap","value":"'$DOCKER_SWAP'"}]}}'

#query uuid-list and print TaskGroupInfo to stdout
cat $SENTINEL_3_UUID_LIST |
jq --slurp --raw-input 'split("\n") | map( . as $o | split("/")|
{
  ("name"):("ingester_"+(.[6] | .[13:30])),
  ("task_id"):(
    {
      ("value"):(.[6] | .[13:40])
    }),
  ("agent_id"):({"value": ""}),
  ("resources"):(env.resources | fromjson),
  ("command"): (env.command | fromjson |
    .environment.variables = 
    [
      {"name":"SOURCE_PRODUCT","value":($o)},
      {"name":"DATAHUB_USER","value":(env.DATAHUB_USER)},
	  {"name":"DATAHUB_PW","value":(env.DATAHUB_PW)},
	  {"name":"TARGET_BUCKET_PREFIX","value":(env.TARGET_BUCKET_PREFIX)}
     
    ]
  ),
  ("container"):(env.container | fromjson | .docker.image = (env.DOCKER_IMAGE))
}
)' > hash.json

echo $TaskGroupInfo | jq --slurpfile hash hash.json '.tasks=$hash[0]'

rm hash.json