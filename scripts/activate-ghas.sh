#!/bin/bash

echo "🔍 Activating GitHub Advanced Security (GHAS) for the repository..."

# Get repository ID
HTTP_STATUS=$(curl -s -o repo_response.json -w "%{http_code}" -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TARGET_PAT}" \
  "https://api.${TARGET_GHEC_URL}/repos/${TARGET_ORG}/${REPO_NAME}")

if [[ $HTTP_STATUS -lt 200 || $HTTP_STATUS -ge 300 ]]; then
  echo "❌ Error: API returned status code $HTTP_STATUS when getting repository info"
  cat repo_response.json
  exit 1
fi

repo_id=$(cat repo_response.json | jq -r '.id')

# Attach code scanning configuration
if [[ -n "$repo_id" && "$repo_id" != "null" ]]; then
  echo "🔐 Activating GitHub Advanced Security with config: ${GHAS_CONFIG}"
  HTTP_STATUS=$(curl -s -o ghas_response.json -w "%{http_code}" -L -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${TARGET_PAT}" \
    "https://api.${TARGET_GHEC_URL}/orgs/${TARGET_ORG}/code-security/configurations/${GHAS_CONFIG}/attach" \
    -d "{\"scope\":\"selected\",\"selected_repository_ids\":[${repo_id}]}")

  if [[ $HTTP_STATUS -lt 200 || $HTTP_STATUS -ge 300 ]]; then
    echo "❌ Error: API returned status code $HTTP_STATUS when attaching GHAS configuration"
    cat ghas_response.json
    exit 1
  fi
  echo "✅ GitHub Advanced Security activated successfully"
else
  echo "❌ Error: Failed to fetch repository ID"
  exit 1
fi