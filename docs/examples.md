# Example Configurations

## Basic Repository Cloning

```yaml
name: Clone Repository

on:
  workflow_dispatch:
    inputs:
      repository_name:
        description: 'Repository to clone'
        required: true
        type: string

jobs:
  clone-repository:
    runs-on: ubuntu-latest
    steps:
      - name: Clone Repository
        uses: ovas04/enterprise-repo-bridge@v1
        env:
          SOURCE_PAT: ${{ secrets.SOURCE_PAT }}
          TARGET_PAT: ${{ secrets.TARGET_PAT }}
        with:
          repository_name: ${{ github.event.inputs.repository_name }}
          source_org: 'acme-corp'
          target_org: 'new-company'
```

## With Branch Protection and Security

```yaml
name: Secure Repository Clone

on:
  push:
    branches: [main]

jobs:
  secure-clone:
    runs-on: ubuntu-latest
    steps:
      - name: Clone with Security Features
        uses: ovas04/enterprise-repo-bridge@v1
        env:
          SOURCE_PAT: ${{ secrets.SOURCE_PAT }}
          TARGET_PAT: ${{ secrets.TARGET_PAT }}
        with:
          repository_name: 'my-awesome-repo'
          source_org: 'acme-corp'
          target_org: 'new-company'
          default_ruleset: true
          ghas_config: 'advanced-security-config'
```

## GitHub Enterprise Server

```yaml
name: Enterprise Server Clone

on:
  workflow_dispatch:

jobs:
  enterprise-clone:
    runs-on: ubuntu-latest
    steps:
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
          default_ruleset: true
```

## Usage Tips

1. **Always specify both source and target organizations** to avoid confusion
2. **Use secrets for authentication tokens** - configure `SOURCE_PAT` and `TARGET_PAT`
3. **Test with simple repositories first** before cloning complex ones
4. **Review generated repositories** after cloning to verify settings
