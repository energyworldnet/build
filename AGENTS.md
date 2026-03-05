# energyworldnet/build

Shared Azure DevOps pipeline templates for the energyworldnet GitHub organization.

## Structure

All templates live in `templates/` and are referenced from consuming repos via `@build` resource syntax:

```yaml
resources:
  repositories:
  - repository: build
    type: github
    name: energyworldnet/build
    endpoint: proddev
```

## Templates

### `check-paths.yml`

Job-level template for path-based change detection. Outputs boolean variables per path group so downstream stages can conditionally run.

### `publish-github-pages.yml`

Job-level deployment template that publishes a build artifact to the `gh-pages` branch.

**Parameters:**

| Parameter  | Type   | Required | Purpose                     |
|------------|--------|----------|-----------------------------|
| `artifact` | string | yes      | Build artifact to download  |

The `github-pages` environment is hardcoded in this template. Configure the Azure DevOps environment to require this template for deployment approval and gating.

#### `gh-pages` branch protection

Consuming repos must configure branch protection on `gh-pages` to restrict pushes to authorized actors only:

- **Restrict who can push**: `ewnbot` (user) and `azure-pipelines` (app)
- **Block creations**: enabled — prevents new branches matching the rule
- **Allow force pushes**: disabled
- **Allow deletions**: disabled

This ensures only the pipeline (via `ewnbot` credentials) can update the deployed site.

## Conventions

- Templates are job-level (they define `jobs:`), not step-level
- Consuming pipelines reference templates as `templates/<name>.yml@build`
- Environment names are hardcoded in deployment templates so Azure DevOps can enforce template requirements
