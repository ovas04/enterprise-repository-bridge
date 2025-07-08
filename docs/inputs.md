# Input Parameters Reference

## Required Parameters

| Parameter | Description | Type |
|-----------|-------------|------|
| `repository_name` | Name of the repository to clone | string |
| `source_org` | Source organization containing the repository | string |

## Optional Parameters

| Parameter | Description | Type | Default |
|-----------|-------------|------|---------|
| `target_org` | Target organization for the new repository | string | Current user |
| `source_ghec_url` | Source GitHub Enterprise Server URL | string | `github.com` |
| `target_ghec_url` | Target GitHub Enterprise Server URL | string | `github.com` |
| `default_ruleset` | Apply default branch protection rules | boolean | `true` |
| `ghas_config` | GitHub Advanced Security configuration name | string | - |

## Environment Variables

The action requires these secrets to be configured:

- **`SOURCE_PAT`**: Personal Access Token for source organization access
- **`TARGET_PAT`**: Personal Access Token for target organization access

## Example Usage

```yaml
uses: ovas04/enterprise-repo-bridge@v1
env:
  SOURCE_PAT: ${{ secrets.SOURCE_PAT }}
  TARGET_PAT: ${{ secrets.TARGET_PAT }}
with:
  repository_name: 'my-repo'
  source_org: 'source-org'
  target_org: 'target-org'
  default_ruleset: true
```