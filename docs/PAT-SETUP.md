# Personal Access Token Setup Guide

## Overview

The Enterprise Repository Bridge action requires **two Personal Access Tokens (PATs)** stored as **GitHub Secrets**.

## Required Tokens

| Token | Purpose | Required Scopes |
|-------|---------|----------------|
| **`SOURCE_PAT`** | Read repositories from source organization | `repo`, `read:org` |
| **`TARGET_PAT`** | Create repositories in target organization | `repo`, `admin:org` |

## Step 1: Create PATs

1. Go to [GitHub Settings → Personal access tokens](https://github.com/settings/tokens)
2. Click **Generate new token (classic)**
3. Configure scopes as shown in the table above
4. Set expiration (recommended: 90 days)
5. **Copy the token immediately** (you won't see it again)

## Step 2: Add as Repository Secrets

1. Go to your repository **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add both secrets:
   - Name: `SOURCE_PAT`, Value: [your source token]
   - Name: `TARGET_PAT`, Value: [your target token]

## Usage

```yaml
- name: Clone Repository
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    repository_name: 'my-repository'
    source_org: 'source-org'
    target_org: 'target-org'
    source_pat: ${{ secrets.SOURCE_PAT }}
    target_pat: ${{ secrets.TARGET_PAT }}
```

## GitHub Enterprise Server

For GHES, add the server URLs:

```yaml
with:
  source_ghec_url: 'github.company.com'
  target_ghec_url: 'github.company.com'
  # ... other parameters
```

## Troubleshooting

| Error | Solution |
|-------|----------|
| `Bad credentials` | Regenerate PAT, verify scopes and expiration |
| `Not Found` | Ensure user has access to source/target organizations |
| `SOURCE_ORG is required` | Add `source_org` as input or `SOURCE_ORG` as env variable |

## Security Notes

- ✅ Store PATs as GitHub Secrets only
- ✅ Use minimum required scopes  
- ✅ Set expiration dates
- ❌ Never commit PATs in code
