#!/bin/bash

set -e

# Validate required environment variables
if [[ -z "$TARGET_PAT" ]]; then
    echo "❌ Error: TARGET_PAT is required"
    exit 1
fi

if [[ -z "$TARGET_ORG" ]]; then
    echo "❌ Error: TARGET_ORG is required"
    exit 1
fi

if [[ -z "$REPO_NAME" ]]; then
    echo "❌ Error: REPO_NAME is required"
    exit 1
fi

if [[ -z "$TARGET_GHEC_URL" ]]; then
    echo "❌ Error: TARGET_GHEC_URL is required"
    exit 1
fi

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