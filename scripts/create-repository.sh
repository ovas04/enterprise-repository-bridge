#!/bin/bash

# This script creates an empty repository in the target organization.

set -e

# Use environment variables instead of positional arguments
# These are set in action.yml

# Validate required environment variables
if [[ -z "$TARGET_ORG" ]]; then
    echo "❌ Error: TARGET_ORG is required"
    exit 1
fi

if [[ -z "$REPO_NAME" ]]; then
    echo "❌ Error: REPO_NAME is required"
    exit 1
fi

if [[ -z "$TARGET_PAT" ]]; then
    echo "❌ Error: TARGET_PAT is required"
    exit 1
fi

if [[ -z "$TARGET_GHEC_URL" ]]; then
    echo "❌ Error: TARGET_GHEC_URL is required"
    exit 1
fi

echo "🔧 Creating repository in $TARGET_ORG organization..."

HTTP_STATUS=$(curl -s -o response.json -w "%{http_code}" -L -X POST \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer ${TARGET_PAT}" \
"https://api.${TARGET_GHEC_URL}/orgs/${TARGET_ORG}/repos" \
-d "{\"name\":\"${REPO_NAME}\",\"private\":true}")

if [[ $HTTP_STATUS -lt 200 || $HTTP_STATUS -ge 300 ]]; then
  echo "❌ Error: API returned status code $HTTP_STATUS"
  cat response.json
  exit 1
fi

echo "✅ Repository created successfully with status code $HTTP_STATUS"