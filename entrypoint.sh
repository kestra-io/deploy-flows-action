#!/bin/bash

# Set up auth if required
auth=""
if [[ $3 && $4 ]]; then
    auth="--user=$3:$4"
fi

# Check if we delete or not resources
delete=""
if [[ $5 == true ]]; then
  delete="--delete"
fi

# Check if there is a tenant id
tenant=""
if [[ $6 ]]; then
  tenant="--tenant=$6"
fi

# Check if there is a API Token
apiToken=""
if [[ ${7} ]]; then
  apiToken="--api-token=${7}"
fi

# Check if there is a namespace
if [[ $8 ]]; then
  namespace="--namespace=${8}"
fi

# Track usage
CONFIG=$(curl -s https://api.kestra.io/v1/config)
PH_TOKEN=$(echo "$CONFIG" | sed -E  's/.*"token":"([^"]+)".*/\1/')
PH_API_HOST=$(echo "$CONFIG" | sed -E  's/.*"apiHost":"([^"]+)".*/\1/')
PH_ID=$(echo "$CONFIG" | sed -E  's/.*"id":"([^"]+)".*/\1/')

curl -v -L -H "Content-Type: application/json" -d '{
    "api_key": "'"$PH_TOKEN"'",
    "event": "Github Actions",
    "distinct_id": "'"$PH_ID"'",
    "properties": {
        "gha": {
            "name": "deploy-flows-action",
            "resource": "'"$4"'",
            "namespace": "'"$1"'"
        }
    }
}' "$PH_API_HOST"capture/ > /dev/null

# Run it
/app/kestra flows updates "$1" "$2" --server="$5" $auth $delete $namespace $tenant $apiToken
