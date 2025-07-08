#!/bin/bash

set -e

required_vars=(TARGET_PAT TARGET_ORG REPO_NAME TARGET_GHEC_URL)

for var in "${required_vars[@]}"; do
  if [[ -z "${!var}" ]]; then
    echo "❌ Error: $var is required"
    exit 1
  fi
done

echo "🔑 Requesting Actions Runner registration token..."
HTTP_STATUS_CODE=$(curl -s -w "%{http_code}" -L -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TARGET_PAT}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.${TARGET_GHEC_URL}/repos/${TARGET_ORG}/${REPO_NAME}/actions/runners/registration-token" \
  -o runner_token_response.json)

if [[ "$HTTP_STATUS_CODE" -eq 201 ]]; then
  echo "✅ Successfully retrieved runner registration token."
  echo "Token response saved to runner_token_response.json"
else
  echo "❌ Error: API returned status code $HTTP_STATUS_CODE when requesting runner token."
  echo "Response:"
  cat runner_token_response.json
  exit 1
fi
