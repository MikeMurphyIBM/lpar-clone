#!/bin/sh
set -e

WORKSPACE_ID="us-south.workspace.clone-test.8c45db95"

APIKEY="$apikey"

TOKEN=$(curl -s -X POST \
  "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$APIKEY" \
  -u bx:bx \
  | jq -r .access_token)

echo "IAM token acquired."

echo "Triggering Schematics APPLY on workspace $WORKSPACE_ID ..."

curl -s -X PUT \
  "https://private-us-south.schematics.cloud.ibm.com/v1/workspaces/${WORKSPACE_ID}/apply" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}' \
  -o /tmp/apply_response.json


echo "Schematics APPLY triggered. Response saved."

cat /tmp/apply_response.json
