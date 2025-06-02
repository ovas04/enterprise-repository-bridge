#!/bin/bash

echo "🔑 Requesting Actions Runner registration token..."
HTTP_STATUS_CODE=$(curl -s -w "%{http_code}" -L -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $1" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$2/actions/runners/registration-token" \
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