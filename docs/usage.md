# Usage Guide for Enterprise Repository Bridge

This guide provides detailed instructions for using the Enterprise Repository Bridge action to clone repositories between GitHub organizations with advanced configuration options.

## 🚀 Quick Start

```yaml
- name: Clone Repository
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    repository_name: 'my-awesome-repo'
    source_org: 'source-company'
    target_org: 'target-company'
    source_pat: ${{ secrets.SOURCE_PAT }}
    target_pat: ${{ secrets.TARGET_PAT }}
```

## 📋 Complete Workflow Example

```yaml
name: Repository Cloner
run-name: Clone ${{ github.event.inputs.repository_name }} Repository

on:
  workflow_dispatch:
    inputs:
      repository_name:
        description: 'Name of the repository to clone'
        required: true
        type: string
      target_org:
        description: 'Target organization'
        required: false
        type: string
        default: 'my-target-org'
      default_ruleset:
        description: 'Apply branch protection rules?'
        required: false
        type: boolean
        default: true

jobs:
  clone-repository:
    runs-on: ubuntu-latest
    steps:
      - name: Clone Repository
        id: clone-repo
        uses: ovas04/enterprise-repository-bridge@v1.0.0
        with:
          repository_name: ${{ github.event.inputs.repository_name }}
          source_org: 'my-source-org'
          target_org: ${{ github.event.inputs.target_org }}
          default_ruleset: ${{ github.event.inputs.default_ruleset }}
          source_pat: ${{ secrets.SOURCE_PAT }}
          target_pat: ${{ secrets.TARGET_PAT }}

      - name: Display Results
        run: |
          echo "✅ Repository cloned successfully!"
          echo "📁 Repository: ${{ steps.clone-repo.outputs.repository_name }}"
          echo "🔗 URL: ${{ steps.clone-repo.outputs.repository_url }}"
```

## 🎯 Input Methods

### Method 1: Using inputs (Recommended)

```yaml
- name: Clone Repository
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    repository_name: 'my-repo'
    source_org: 'source-organization'
    target_org: 'target-organization'
    source_pat: ${{ secrets.SOURCE_PAT }}
    target_pat: ${{ secrets.TARGET_PAT }}
```

### Method 2: Using environment variables

```yaml
- name: Clone Repository
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    repository_name: 'my-repo'
    target_org: 'target-organization'
    source_pat: ${{ secrets.SOURCE_PAT }}
    target_pat: ${{ secrets.TARGET_PAT }}
  env:
    SOURCE_ORG: 'source-organization'
```

### Method 3: Mixed approach

```yaml
- name: Clone Repository
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    repository_name: 'my-repo'
    target_org: 'target-organization'
    source_pat: ${{ secrets.SOURCE_PAT }}
    target_pat: ${{ secrets.TARGET_PAT }}
  env:
    SOURCE_ORG: 'source-organization'
    SOURCE_GHEC_URL: 'github.com'
    TARGET_GHEC_URL: 'github.com'
```

**Note:** If both input and environment variable are provided for `source_org`, the input value takes precedence.

## 📤 Action Outputs

The action provides the following outputs that you can use in subsequent steps:

| Output | Description | Example |
|--------|-------------|---------|
| `repository_url` | Full URL of the cloned repository | `https://github.com/target-org/my-repo` |
| `repository_name` | Full repository name | `target-org/my-repo` |
| `clone_status` | Status of the cloning operation | `success` |
| `target_org` | Target organization name | `target-org` |

### Using Outputs Example

```yaml
- name: Clone Repository
  id: clone-step
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    # ... inputs

- name: Send Notification
  run: |
    echo "Repository cloned: ${{ steps.clone-step.outputs.repository_url }}"
    # Send to Slack, Teams, etc.

- name: Update Documentation
  run: |
    echo "New repository created: ${{ steps.clone-step.outputs.repository_name }}" >> CHANGELOG.md
```

## 🏢 Enterprise Server Support

For GitHub Enterprise Server instances, use the URL parameters:

```yaml
- name: Clone Between Enterprise Servers
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    repository_name: 'enterprise-repo'
    source_org: 'source-corp'
    target_org: 'target-corp'
    source_ghec_url: 'github.enterprise1.com'
    target_ghec_url: 'github.enterprise2.com'
    source_pat: ${{ secrets.ENTERPRISE1_PAT }}
    target_pat: ${{ secrets.ENTERPRISE2_PAT }}
```

## 🔐 Token Requirements and Bypass Configuration

### TARGET_PAT Bypass Requirements

When using `default_ruleset: true`, the `TARGET_PAT` must be configured as a bypass actor in the ruleset. This is essential for:

- **Sync Workflow Operation**: Allows the sync workflow to push changes without status check blocking
- **Emergency Access**: Provides fallback access for critical repository operations
- **SCBM Compliance**: Meets enterprise Source Control Branch Management requirements

**Important**: The ruleset automatically configures bypass permissions for Organization Admins and Enterprise Owners. Ensure your `TARGET_PAT` has the appropriate organizational permissions.

## 🔒 Security & Configuration Options

### Branch Protection Rules

The default ruleset includes comprehensive security rules:

- ✅ **Required Status Checks**: `sync-branch` status check
- ✅ **Pull Request Reviews**: Required approving review count (1)
- ✅ **Code Owner Reviews**: Required
- ✅ **Signed Commits**: All commits must be signed
- ✅ **Linear History**: Enforces linear commit history
- ✅ **Merge Methods**: Only squash merging allowed

```yaml
- name: Clone with Branch Protection
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    # ... other inputs
    default_ruleset: 'true'  # Applies comprehensive branch protection
```

### GitHub Advanced Security

```yaml
- name: Clone with GHAS
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    # ... other inputs
    ghas_config: 'enable-all'  # Configure GHAS features
```

## 📊 What Gets Cloned

The action performs a **mirror clone**, which includes:

- ✅ All commits and history
- ✅ All branches
- ✅ All tags
- ✅ All refs
- ❌ Issues, PRs, and project data (GitHub-specific features)
- ❌ Actions workflows (optional, can be manually re-enabled)

## 🔧 Process Steps

The action executes the following steps:

1. 🔍 **Validate Configuration** - Checks inputs and environment variables
2. 📥 **Clone Source Repository** - Creates mirror clone from source
3. 🔑 **Get Runner Token** - Retrieves GitHub Actions runner token
4. 📊 **Get Repository Metadata** - Fetches repository information
5. 🔒 **Apply Branch Protection** - Configures branch protection rules (if enabled)
6. 🛡️ **Activate GHAS** - Sets up GitHub Advanced Security (if configured)
7. 📋 **Summary & Annotations** - Displays results and creates GitHub Actions summary

## ❌ Troubleshooting

| Issue | Solution |
|-------|----------|
| `SOURCE_ORG is required` | Pass `source_org` as input or `SOURCE_ORG` as environment variable |
| `Permission Denied` | Verify PAT scopes include `repo`, `admin:org` permissions |
| `Repository Exists` | Repository already exists in target org - choose different name |
| `Rate Limits` | Add delays between multiple repository clones or use different PATs |
| `Clone failed` | Check source repository exists and PAT has access |

## 🛡️ Security Best Practices

1. **Use Repository Secrets** for PATs - Never hardcode tokens
2. **Limit PAT Scopes** to minimum required (`repo`, `admin:org`)
3. **Rotate Tokens Regularly** - Set expiration dates on PATs
4. **Monitor Workflow Runs** for failures and suspicious activity
5. **Use Environment Variables** for sensitive configuration

## 📝 Input Parameters Reference

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `repository_name` | ✅ | - | Name of repository to clone |
| `source_org` | 🔄 | - | Source organization (or use env var) |
| `target_org` | ✅ | - | Target organization |
| `source_pat` | ✅ | - | Source PAT token |
| `target_pat` | ✅ | - | Target PAT token (must have bypass permissions for sync-branch) |
| `source_ghec_url` | ❌ | `github.com` | Source GitHub URL |
| `target_ghec_url` | ❌ | `github.com` | Target GitHub URL |
| `default_ruleset` | ❌ | `true` | Apply branch protection |
| `ghas_config` | ❌ | `''` | GHAS configuration |

## 🔄 Continuous Synchronization

### ⚠️ Critical Ruleset Consideration

When `default_ruleset: true` is enabled, the action applies branch protection rules that **require a `sync-branch` status check**. This is specifically designed for repositories that need to **periodically receive updates from the source repository**.

### Why the Sync Workflow is Essential

The `sync-branch` status check serves as a gate to ensure repository synchronization. Here's what happens:

- **Without sync workflow**: Pull requests will be **blocked** and cannot be merged
- **With sync workflow**: The status check passes, allowing normal development flow
- **Enterprise benefit**: Ensures compliance with Source Control Branch Management (SCBM) requirements

### ✅ Required Sync Workflow

**This workflow is MANDATORY when using `default_ruleset: true`**

Add this workflow to your cloned repository as `.github/workflows/sync-origin.yml`:

```yaml
name: Sync Origin Repository

on:
  workflow_dispatch:
  schedule:
    - cron: '0 0 28 * *'  # Monthly sync on 28th
  pull_request_target:
    branches:
      - main

jobs:
  sync-branch:
    if: github.event.repository.fork == false && github.repository_owner != 'source-enterprise-org'
    runs-on: ubuntu-latest
    env:
      SOURCE_PAT: ${{ secrets.ENTERPRISE_GITHUB_TOKEN }}
      TARGET_PAT: ${{ secrets.TARGET_PAT }}
      SOURCE_GHEC_URL: 'github.com' 
      SOURCE_ORG: 'source-enterprise-org'
      TARGET_GHEC_URL: 'github.com'
      REPO_NAME: ${{ github.event.repository.name }}
    steps:
      - name: Checkout main branch
        uses: actions/checkout@v4
        with:
          ref: main
          fetch-depth: 0

      - name: Clone main branch from source organization
        run: |
          git clone --branch main --single-branch "https://${SOURCE_PAT}@${SOURCE_GHEC_URL}/${SOURCE_ORG}/${REPO_NAME}.git"

      - name: Push main branch to target organization
        run: |
          cd "${REPO_NAME}"
          git push "https://${TARGET_PAT}@${TARGET_GHEC_URL}/${GITHUB_REPOSITORY}.git" main

      - name: Create sync status check
        run: |
          curl -X POST \
            -H "Authorization: Bearer ${{ secrets.TARGET_PAT }}" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/repos/${{ github.repository }}/statuses/${{ github.sha }}" \
            -d '{
              "state": "success",
              "context": "sync-branch",
              "description": "Repository synchronized with source"
            }'
```

### Configuration Options

**If you DON'T need periodic synchronization:**
```yaml
- name: Clone Repository
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    # ... other parameters
    default_ruleset: 'false'  # Disable ruleset to avoid sync-branch requirement
```

**If you DO need periodic synchronization:**
```yaml
- name: Clone Repository
  uses: ovas04/enterprise-repository-bridge@v1.0.0
  with:
    # ... other parameters
    default_ruleset: 'true'  # Enable ruleset with sync-branch requirement
```

Then implement the sync workflow shown above in your cloned repository.

### Benefits of This Approach

✅ **Source Control Integration**: Combines cloning with SCBM (Source Control Branch Management)  
✅ **Automatic Sync**: Monthly automatic synchronization from source repository  
✅ **Manual Trigger**: On-demand sync via `workflow_dispatch`  
✅ **Pull Request Integration**: Ensures sync before merging changes  

## 📁 Additional Resources

- **Complete Sync Workflow Example**: See [sync-workflow-example.yml](sync-workflow-example.yml) for a ready-to-use template
- **PAT Setup Guide**: See [PAT-SETUP.md](PAT-SETUP.md) for security best practices
- **Example Implementation**: See [example-workflow.yml](example-workflow.yml) for basic usage patterns

**Next Steps After Cloning:**

1. Set up the sync workflow in your cloned repository
2. Configure the required secrets (`ENTERPRISE_GITHUB_TOKEN`, `TARGET_PAT`)
3. Test the sync process with `workflow_dispatch`
4. Verify the `sync-branch` status check appears in pull requests
