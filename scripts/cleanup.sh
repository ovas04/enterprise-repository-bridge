#!/bin/bash

echo "⚠️ Cleaning up resources..."

# Check if the repository name is provided
if [ -z "$REPO_NAME" ]; then
  echo "❌ Error: No repository name provided for cleanup."
  exit 1
fi

# Check if the repository was actually created
if [ ! -f "/tmp/repo_created_flag" ]; then
  echo "ℹ️ No repository was created, skipping cleanup."
  echo "🧹 Cleanup process completed."
  exit 0
fi

echo "🗑️ Repository was created, attempting to delete it..."

# Attempt to delete the repository
HTTP_STATUS=$(curl -s -o delete_response.json -w "%{http_code}" -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TARGET_PAT}" \
  "https://api.${TARGET_GHEC_URL}/repos/${TARGET_ORG}/${REPO_NAME}")

if [[ $HTTP_STATUS -lt 200 || $HTTP_STATUS -ge 300 ]]; then
  echo "❌ Warning: Failed to delete repository with status code $HTTP_STATUS"
  cat delete_response.json
else
  echo "✅ Repository ${TARGET_ORG}/${REPO_NAME} deleted successfully."
fi

# Clean up the flag file
rm -f /tmp/repo_created_flag

echo "🧹 Cleanup process completed."