# Azure Pipelines Templates

## `detect-changed-paths.yml`

Path-based change detection. Outputs boolean variables per path group so downstream stages can
conditionally run.

| Parameter    | Type   | Default | Purpose                                         |
| ------------ | ------ | ------- | ----------------------------------------------- |
| `pathGroups` | object | `{}`    | Map of group names to `include`/`exclude` globs |
| `fetchDepth` | number | `100`   | Shallow clone depth for the checkout            |

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

## `run-pre-commit.yml`

Runs [pre-commit](https://pre-commit.com/) checks on pull requests. Supports optional .NET, pnpm,
and Terraform toolchains.

| Parameter          | Type    | Default         | Purpose                           |
| ------------------ | ------- | --------------- | --------------------------------- |
| `pnpmCommands`     | object  | `[]`            | Extra pnpm commands before checks |
| `terraformVersion` | string  | `1.12.1`        | Terraform version to install      |
| `useDotNet`        | boolean | `false`         | Restore .NET tools                |
| `usePnpm`          | boolean | `false`         | Install and restore pnpm deps     |
| `pnpmVersion`      | string  | `^10`           | pnpm version constraint           |
| `usePnpmCache`     | boolean | `true`          | Cache the pnpm store              |
| `useTerraform`     | boolean | `false`         | Install Terraform and TFLint      |
| `vmImage`          | string  | `ubuntu-latest` | Agent pool VM image               |

```yaml
jobs:
  - template: templates/run-pre-commit.yml@build
    parameters:
      usePnpm: true
      useDotNet: true
```

## `pnpm-tasks.yml`

Step template that installs pnpm, authenticates against an internal npm feed, and restores
dependencies.

| Parameter  | Type    | Default | Purpose                 |
| ---------- | ------- | ------- | ----------------------- |
| `version`  | string  | `^10`   | pnpm version constraint |
| `useCache` | boolean | `true`  | Cache the pnpm store    |

```yaml
steps:
  - template: templates/pnpm-tasks.yml@build
    parameters:
      useCache: false
```

**Important:** Always include `pnpm-variables.yml` in the job's variables when using this template.

## `pnpm-variables.yml`

Variable template that sets the `PnpmStorePath` variable used by `pnpm-tasks.yml`. Must always be
included alongside `pnpm-tasks.yml`.

```yaml
variables:
  - template: templates/pnpm-variables.yml@build
```

## `publish-github-pages.yml`

Deploys a build artifact to the `gh-pages` branch. The `github-pages` environment is hardcoded so
Azure DevOps can enforce template requirements on the environment.

| Parameter  | Type   | Default      | Purpose                            |
| ---------- | ------ | ------------ | ---------------------------------- |
| `artifact` | string | _(required)_ | Build artifact containing the site |

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
