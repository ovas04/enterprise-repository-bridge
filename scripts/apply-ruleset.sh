#!/bin/bash

echo "🔒 Applying branch protection rules to the repository..."

HTTP_STATUS=$(curl -s -o ruleset_response.json -w "%{http_code}" -L -X POST \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer ${TARGET_PAT}" \
-H "X-GitHub-Api-Version: 2022-11-28" \
"https://api.${TARGET_GHEC_URL}/repos/${TARGET_ORG}/${REPO_NAME}/rulesets" \
-d '{
      "name": "rs-main-default",
      "target": "branch",
      "enforcement": "active",
      "bypass_actors": [
          { "actor_id": 1, "actor_type": "OrganizationAdmin", "bypass_mode": "always" },
          { "actor_id": 2, "actor_type": "EnterpriseOwner", "bypass_mode": "always" }
      ],
      "conditions": {
          "ref_name": {
              "include": ["refs/heads/main"],
              "exclude": []
          }
      },
      "rules": [
          {
              "type": "required_status_checks",
              "parameters": {
                  "strict_required_status_checks_policy": true,
                  "required_status_checks": [
                      { "context": "sync-branch" }
                  ]
              }
          },
          {
              "type": "pull_request",
              "parameters": {
                  "dismiss_stale_reviews_on_push": true,
                  "require_code_owner_review": true,
                  "required_approving_review_count": 1,
                  "require_last_push_approval": false,
                  "required_review_thread_resolution": false,
                  "allowed_merge_methods": ["squash"]
              }
          },
          {
              "type": "non_fast_forward",
              "parameters": {}
          },
          {
              "type": "required_linear_history",
              "parameters": {}
          },
          {
              "type": "required_signatures",
              "parameters": {}
          }
      ]
  }')

if [[ $HTTP_STATUS -lt 200 || $HTTP_STATUS -ge 300 ]]; then
  echo "❌ Error: Ruleset API returned status code $HTTP_STATUS"
  cat ruleset_response.json
  exit 1
fi

echo "✅ Branch protection rules applied successfully (includes signed commits requirement)"