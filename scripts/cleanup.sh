#!/bin/bash

echo "⚠️ Cleaning up resources..."

# Check if the repository name is provided
if [ -z "$REPOSITORY_NAME" ]; then
  echo "❌ Error: No repository name provided for cleanup."
  exit 1
fi

# Attempt to delete the repository
HTTP_STATUS=$(curl -s -o delete_response.json -w "%{http_code}" -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TARGET_PAT}" \
  "https://api.${TARGET_GHEC_URL}/repos/${TARGET_ORG}/${REPOSITORY_NAME}")

if [[ $HTTP_STATUS -lt 200 || $HTTP_STATUS -ge 300 ]]; then
  echo "❌ Warning: Failed to delete repository with status code $HTTP_STATUS"
  cat delete_response.json
else
  echo "✅ Repository ${TARGET_ORG}/${REPOSITORY_NAME} deleted successfully."
fi

echo "🧹 Cleanup process completed."