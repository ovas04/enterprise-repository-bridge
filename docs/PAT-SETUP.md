# Personal Access Token Setup Guide

## Required Tokens

The action needs two Personal Access Tokens:

- **`SOURCE_PAT`**: Read repositories from source organization
- **`TARGET_PAT`**: Create and configure repositories in target organization

## Token Creation

### 1. Create Tokens

1. Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens)
2. Click **Generate new token (classic)**
3. Configure scopes:

**For SOURCE_PAT:**
- ✅ `repo` (Full control of private repositories)
- ✅ `read:org` (Read org and team membership)

**For TARGET_PAT:**
- ✅ `repo` (Full control of private repositories)
- ✅ `admin:org` (Full control of orgs and teams)

4. Set appropriate expiration
5. Generate and **copy tokens immediately**

### 2. Add as Repository Secrets

1. Go to repository **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add secrets:
   - Name: `SOURCE_PAT`, Value: your source token
   - Name: `TARGET_PAT`, Value: your target token

## Verification

Your secrets should show in the repository settings (values hidden for security).
- ✅ `SOURCE_PAT` (Updated X minutes ago)
- ✅ `TARGET_PAT` (Updated X minutes ago)
- ✅ `SOURCE_PAT` (Updated X minutes ago)
- ✅ `TARGET_PAT` (Updated X minutes ago)

## Usage in Workflow

```yaml
steps:
  - name: Clone Repository
    uses: ovas04/enterprise-repo-bridge@v1
    env:
      SOURCE_PAT: ${{ secrets.SOURCE_PAT }}
      TARGET_PAT: ${{ secrets.TARGET_PAT }}
    with:
      repository_name: 'my-repo'
      source_org: 'source-org'
      target_org: 'target-org'
```

## GitHub Enterprise Server

For GHES instances, create PATs on each server and configure URLs:

```yaml
with:
  source_ghec_url: 'github.company1.com'
  target_ghec_url: 'github.company2.com'
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Bad credentials" | Verify PAT in secrets, check expiration and scopes |
| "Access denied" | Ensure user has org access and required permissions |
| PAT not working | Regenerate PAT, verify it's "classic" token, check SSO |

## Security Notes

- Never commit PATs in code
- Use minimum required scopes
- Set appropriate expiration dates
- Rotate tokens regularly
