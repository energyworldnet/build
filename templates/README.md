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

On non-PR builds, a `ValidatePreCommit` job checks whether the branch is in `skipRefs`. If it is,
the job succeeds silently. Otherwise it fails with an error to prevent bypassing pre-commit by
manually triggering a build on a non-PR branch.

| Parameter          | Type    | Default              | Purpose                                    |
| ------------------ | ------- | -------------------- | ------------------------------------------ |
| `pnpmCommands`     | object  | `[]`                 | Extra pnpm commands before checks          |
| `terraformVersion` | string  | `1.12.1`             | Terraform version to install               |
| `useDotNet`        | boolean | `false`              | Restore .NET tools                         |
| `usePnpm`          | boolean | `false`              | Install and restore pnpm deps              |
| `pnpmVersion`      | string  | `^10`                | pnpm version constraint                    |
| `usePnpmCache`     | boolean | `true`               | Cache the pnpm store                       |
| `usePipCache`      | boolean | `true`               | Cache pip downloads                        |
| `useTerraform`     | boolean | `false`              | Install Terraform and TFLint               |
| `skipRefs`         | object  | `[refs/heads/main]`  | Branch refs that skip pre-commit on non-PR |
| `nodeVersion`      | string  | `24.x`               | Node.js version to install                 |
| `vmImage`          | string  | `ubuntu-latest`      | Agent pool VM image                        |

```yaml
jobs:
  - template: templates/run-pre-commit.yml@build
    parameters:
      usePnpm: true
      useDotNet: true
      skipRefs:
        - refs/heads/dev
        - refs/heads/test
        - refs/heads/main
```

## `pip-tasks.yml`

Step template that resolves the Python version, caches pip downloads, and installs dependencies from
a requirements file.

| Parameter          | Type    | Default            | Purpose                      |
| ------------------ | ------- | ------------------ | ---------------------------- |
| `cachePath`        | string  | _(see template)_   | pip download cache directory |
| `requirementsPath` | string  | `requirements.txt` | Path to requirements file    |
| `useCache`         | boolean | `true`             | Cache pip downloads          |

```yaml
steps:
  - template: templates/pip-tasks.yml@build
    parameters:
      requirementsPath: requirements.txt
```

The template sets a `PythonVersion` pipeline variable that callers can reference (e.g., for a
pre-commit cache key).

## `pnpm-tasks.yml`

Step template that installs pnpm, authenticates against an internal npm feed, and restores
dependencies.

| Parameter | Type | Default | Purpose |
| --- | --- | --- | --- |
| `storePath` | string | `$(Pipeline.Workspace)/.pnpm-store` | pnpm store cache directory |
| `useCache` | boolean | `true` | Cache the pnpm store |
| `version` | string | `^10` | pnpm version constraint |

```yaml
steps:
  - template: templates/pnpm-tasks.yml@build
    parameters:
      useCache: false
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
