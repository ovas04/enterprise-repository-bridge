#!/bin/bash

echo "📊 Retrieving repository metadata..."
HTTP_STATUS=$(curl -s -o metadata.json -w "%{http_code}" -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TARGET_PAT}" \
  "https://api.${TARGET_GHEC_URL}/repos/${TARGET_ORG}/${REPOSITORY_NAME}")

if [[ $HTTP_STATUS -lt 200 || $HTTP_STATUS -ge 300 ]]; then
  echo "⚠️ Warning: Could not retrieve repository metadata, status code: $HTTP_STATUS"
else
  FULL_NAME=$(jq -r '.full_name // "N/A"' metadata.json)
  DESCRIPTION=$(jq -r '.description // "No description"' metadata.json)
  DEFAULT_BRANCH=$(jq -r '.default_branch // "N/A"' metadata.json)

  if [[ "$DEFAULT_BRANCH" == "master" ]]; then
    echo "⚠️ Detected default branch as 'master', adjusting to 'main'."
    DEFAULT_BRANCH="main"
  fi

  IS_PRIVATE=$(jq -r '.private' metadata.json)
  CREATED_AT=$(jq -r '.created_at' metadata.json)

  echo "============================================"
  echo "📚 REPOSITORY METADATA"
  echo "============================================"
  echo "📝 Full name:      $FULL_NAME"
  echo "🔖 Description:    $DESCRIPTION"
  echo "🌿 Default branch: $DEFAULT_BRANCH"
  echo "🔒 Private:        $IS_PRIVATE"
  echo "🕒 Created at:     $CREATED_AT"
  echo "============================================"
fi