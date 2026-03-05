# Azure Pipelines Templates

## `detect-changed-paths.yml`

Path-based change detection. Outputs boolean variables per path group so downstream stages can conditionally run.

### Parameters

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `pathGroups` | object | `{}` | Map of group names to `include`/`exclude` glob arrays |
| `fetchDepth` | number | `100` | Shallow clone depth for the checkout |

### Example

```yaml
jobs:
- template: templates/detect-changed-paths.yml@build
  parameters:
    pathGroups:
      build:
        include:
        - src/**
        - package.json
```

Outputs are available as `dependencies.<stage>.outputs['DetectChangedPaths.pathGroups.<group>']`.

## `publish-github-pages.yml`

Deploys a build artifact to the `gh-pages` branch. The `github-pages` environment is hardcoded so Azure DevOps can enforce template requirements on the environment.

### Parameters

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `artifact` | string | *(required)* | Build artifact containing the site |

### Example

```yaml
jobs:
- template: templates/publish-github-pages.yml@build
  parameters:
    artifact: site
```

### `gh-pages` branch protection

Consuming repos should configure branch protection on `gh-pages`:

- **Restrict who can push**: `ewnbot` (user) and `azure-pipelines` (app)
- **Block creations**: enabled
- **Allow force pushes**: disabled
- **Allow deletions**: disabled
