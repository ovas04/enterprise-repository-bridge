#!/bin/bash

set -e

# Use environment variables instead of positional arguments
# These are set in action.yml
echo "🔍 Cloning repository: $REPO_NAME from $SOURCE_ORG"

# Validate required environment variables
if [[ -z "$SOURCE_PAT" ]]; then
    echo "❌ Error: SOURCE_PAT is required"
    exit 1
fi

if [[ -z "$SOURCE_ORG" ]]; then
    echo "❌ Error: SOURCE_ORG is required"
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

if [[ -z "$TARGET_ORG" ]]; then
    echo "❌ Error: TARGET_ORG is required"
    exit 1
fi
git clone --mirror "https://${SOURCE_PAT}@${SOURCE_GHEC_URL}/${SOURCE_ORG}/${REPO_NAME}.git"

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

echo "📤 Pushing cloned repository to target organization..."
cd "${REPO_NAME}.git"
git push --mirror "https://${TARGET_PAT}@${TARGET_GHEC_URL}/${TARGET_ORG}/${REPO_NAME}.git"
echo "✅ Repository content pushed successfully"