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

echo "📥 Cloning repository from source..."
if ! git clone --mirror "https://${SOURCE_PAT}@${SOURCE_GHEC_URL}/${SOURCE_ORG}/${REPO_NAME}.git"; then
    echo "❌ Error: Failed to clone repository from source"
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

# Create a flag file to indicate the repository was created successfully
echo "true" > /tmp/repo_created_flag

echo "📤 Pushing cloned repository to target organization..."
cd "${REPO_NAME}.git"
if ! git push --mirror "https://${TARGET_PAT}@${TARGET_GHEC_URL}/${TARGET_ORG}/${REPO_NAME}.git"; then
    echo "❌ Error: Failed to push repository content to target"
    exit 1
fi
echo "✅ Repository content pushed successfully"

# Generate outputs for GitHub Actions
echo "repository_url=https://${TARGET_GHEC_URL}/${TARGET_ORG}/${REPO_NAME}" >> $GITHUB_OUTPUT
echo "repository_name=${TARGET_ORG}/${REPO_NAME}" >> $GITHUB_OUTPUT
echo "clone_status=success" >> $GITHUB_OUTPUT
echo "target_org=${TARGET_ORG}" >> $GITHUB_OUTPUT

# Create GitHub Actions annotations
echo "::notice title=Repository Cloned Successfully::📁 Repository: ${TARGET_ORG}/${REPO_NAME}"
echo "::notice title=Repository URL::🔗 https://${TARGET_GHEC_URL}/${TARGET_ORG}/${REPO_NAME}"
echo "::notice title=Cloning Status::✅ Clone operation completed successfully"

echo ""
echo "============================================"
echo "✨ REPOSITORY CLONING COMPLETED SUCCESSFULLY"
echo "============================================"
echo "📁 Repository: ${TARGET_ORG}/${REPO_NAME}"
echo "🔗 URL: https://${TARGET_GHEC_URL}/${TARGET_ORG}/${REPO_NAME}"
echo "============================================"