# Enterprise Repository Bridge

[![GitHub Action](https://img.shields.io/badge/GitHub-Action-blue?logo=github-actions&logoColor=white)](https://github.com/marketplace/actions)
[![Version](https://img.shields.io/badge/version-v1.0.0-green?logo=git&logoColor=white)](https://github.com/ovas04/enterprise-repository-bridge/releases)
[![License](https://img.shields.io/badge/license-MIT-blue?logo=opensource&logoColor=white)](LICENSE)

## Overview

The Enterprise Repository Bridge is a GitHub Action designed to facilitate the cloning of repositories between private organizations. This action works with both GitHub.com and GitHub Enterprise Server, automating the process of creating a new repository in the target organization, pushing the cloned content, and configuring essential settings such as branch protection rules and GitHub Advanced Security (GHAS).

## Features

- Clone repositories from a specified source organization.
- Create an empty repository in a target organization.
- Push the cloned repository content to the target organization.
- Retrieve a registration token for GitHub Actions Runner.
- Fetch and display metadata from the newly created repository.
- Optionally apply comprehensive branch protection rules (includes signed commits requirement).
- Optionally activate GitHub Advanced Security (GHAS) configurations.

## 🔄 Continuous Synchronization Support

When cloning repositories that need periodic updates from the source, the action includes:

- **Smart Rulesets**: Branch protection rules that require `sync-branch` status checks
- **Sync Workflow Template**: Ready-to-use workflow for automated synchronization  
- **Enterprise Integration**: Designed for Source Control Branch Management workflows

**Use Case**: Perfect for repositories that need to stay synchronized with upstream changes while maintaining independent development and validation processes.

⚠️ **Important**: The default ruleset requires implementing a sync workflow to prevent blocking pull requests. See [docs/usage.md](docs/usage.md) for the complete setup guide.

## Prerequisites

Before using this action, you need to configure the following secrets in your repository:

### Required Secrets

1. **`SOURCE_PAT`**: Personal Access Token with access to the source organization
   - Scopes needed: `repo`, `read:org`
   - Must have access to read repositories in the source organization

2. **`TARGET_PAT`**: Personal Access Token with access to the target organization  
   - Scopes needed: `repo`, `admin:org`, `write:org`
   - Must have permissions to create repositories in the target organization
   - **Important for Sync**: Must be configured as a bypass actor in the ruleset for `sync-branch` status checks

### How to configure secrets

1. Go to your repository **Settings** > **Secrets and variables** > **Actions**
2. Click **New repository secret**
3. Add both `SOURCE_PAT` and `TARGET_PAT` with their respective token values

📖 **For detailed PAT setup instructions, see [PAT-SETUP.md](PAT-SETUP.md)**

## Usage

To use the Repository Cloner Action, include it in your GitHub workflow YAML file. Here’s a basic example:

```yaml
name: Clone Repository

on:
  workflow_dispatch:
    inputs:
      repository_name:
        description: 'Name of the repository to clone'
        required: true
        type: string
      source_org:
        description: 'Source organization to clone the repository from'
        required: true
        type: string
      target_org:
        description: 'Target organization to clone the repository'
        required: false
        type: string
      default_ruleset:
        description: 'Enable default branch protection rules?'
        required: false
        type: boolean
        default: true
      ghas_config:
        description: 'Configuration for GitHub Advanced Security'
        required: false
        type: string

jobs:
  clone:
    runs-on: ubuntu-latest
    steps:
      - name: Clone Repository Action
        uses: ovas04/enterprise-repo-bridge@v1
        env:
          SOURCE_PAT: ${{ secrets.SOURCE_PAT }}
          TARGET_PAT: ${{ secrets.TARGET_PAT }}
        with:
          repository_name: ${{ github.event.inputs.repository_name }}
          source_org: ${{ github.event.inputs.source_org }}
          target_org: ${{ github.event.inputs.target_org || 'new-company' }}
          default_ruleset: ${{ github.event.inputs.default_ruleset }}
          ghas_config: ${{ github.event.inputs.ghas_config }}
```

## Inputs

The action accepts the following inputs:

- `repository_name`: The name of the repository to clone (required).
- `source_org`: The source organization that contains the repository to clone (required).
- `target_org`: The target organization where the repository will be created (optional).
- `source_ghec_url`: Source GitHub URL (optional, default: github.com for GitHub Cloud).
- `target_ghec_url`: Target GitHub URL (optional, default: github.com for GitHub Cloud).
- `default_ruleset`: A boolean to enable default branch protection rules (optional, default is true).
- `ghas_config`: Configuration for GitHub Advanced Security (optional).

## Documentation

For detailed documentation on how to use the action, including examples and input descriptions, please refer to the [docs](docs/usage.md).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Changelog

For a list of changes and updates, please refer to the [CHANGELOG](CHANGELOG.md).

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.