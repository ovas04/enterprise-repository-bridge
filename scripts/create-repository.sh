#!/bin/bash

# This script creates an empty repository in the target organization.

set -e

TARGET_ORG="$1"
REPO_NAME="$2"
TARGET_PAT="$3"
TARGET_GHEC_URL="$4"

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