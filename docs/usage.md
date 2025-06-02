# Usage Guide for Enterprise Repository Bridge

This guide provides detailed instructions for using the Enterprise Repository Bridge in your GitHub workflows.

## Basic Usage

```yaml
- name: Clone Repository
  uses: ovas04/enterprise-repo-bridge@v1
  env:
    SOURCE_PAT: ${{ secrets.SOURCE_PAT }}
    TARGET_PAT: ${{ secrets.TARGET_PAT }}
  with:
    repository_name: 'my-awesome-repo'
    source_org: 'acme-corp'
    target_org: 'new-company'
```

## Complete Workflow Example

```yaml
name: Repository Cloner Workflow

on:
  workflow_dispatch:
    inputs:
      repo_name:
        description: 'Repository to clone'
        required: true
        type: string

jobs:
  clone-repository:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Clone Repository
        uses: ovas04/enterprise-repo-bridge@v1
        env:
          SOURCE_PAT: ${{ secrets.SOURCE_PAT }}
          TARGET_PAT: ${{ secrets.TARGET_PAT }}
        with:
          repository_name: ${{ github.event.inputs.repo_name }}
          source_org: 'acme-corp'
          target_org: 'new-company'
          default_ruleset: true
```

## Advanced Configuration

### GitHub Enterprise Server Support

For GitHub Enterprise Server instances, use the `source_ghec_url` and `target_ghec_url` parameters:

```yaml
- name: Clone Between Enterprise Servers
  uses: ovas04/enterprise-repo-bridge@v1
  env:
    SOURCE_PAT: ${{ secrets.SOURCE_PAT }}
    TARGET_PAT: ${{ secrets.TARGET_PAT }}
  with:
    repository_name: 'my-awesome-repo'
    source_org: 'acme-corp'
    target_org: 'new-company'
    source_ghec_url: 'github.acme.com'
    target_ghec_url: 'github.newcompany.com'
```

### Branch Protection & Security

- **`default_ruleset: true`** - Applies standard branch protection rules
- **`ghas_config`** - Configures GitHub Advanced Security features

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Permission Denied | Verify PAT scopes and organization access |
| Repository Exists | Choose different target name or delete existing repo |
| Rate Limits | Add delays between multiple repository clones |

## Security Best Practices

1. Use repository secrets for PATs
2. Limit PAT scopes to minimum required
3. Regularly rotate access tokens
4. Monitor workflow runs for failures
