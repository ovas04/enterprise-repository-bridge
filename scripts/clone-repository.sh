#!/bin/bash

set -e

SOURCE_PAT="$1"
SOURCE_ORG="$2"
REPO_NAME="$3"
TARGET_PAT="$4"
TARGET_ORG="$5"

echo "🔍 Cloning repository: $REPO_NAME from $SOURCE_ORG"
git clone --mirror "https://${SOURCE_PAT}@github.com/${SOURCE_ORG}/${REPO_NAME}.git"

echo "🔧 Creating repository in $TARGET_ORG organization..."
HTTP_STATUS=$(curl -s -o response.json -w "%{http_code}" -L -X POST \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer ${TARGET_PAT}" \
"https://api.github.com/orgs/${TARGET_ORG}/repos" \
-d "{\"name\":\"${REPO_NAME}\",\"private\":true}")

if [[ $HTTP_STATUS -lt 200 || $HTTP_STATUS -ge 300 ]]; then
  echo "❌ Error: API returned status code $HTTP_STATUS"
  cat response.json
  exit 1
fi

echo "✅ Repository created successfully with status code $HTTP_STATUS"

echo "📤 Pushing cloned repository to target organization..."
cd "${REPO_NAME}.git"
git push --mirror "https://${TARGET_PAT}@github.com/${TARGET_ORG}/${REPO_NAME}.git"
echo "✅ Repository content pushed successfully"