# energyworldnet/build

Shared Azure DevOps pipeline templates for EWN.

## Structure

All Azure Pipelines templates live in `templates/` and are referenced from consuming repos via
`@build` resource syntax:

```yaml
resources:
  repositories:
    - repository: build
      type: github
      name: energyworldnet/build
      endpoint: proddev
```

## Conventions

- Reference templates as `templates/<name>.yml@build`
- Environment names are hardcoded in deployment templates so Azure DevOps can enforce template
  requirements
- Use `.yml` extension (not `.yaml`) for all templates
- `pnpm-tasks.yml` accepts a `storePath` parameter (defaults to `$(Pipeline.Workspace)/.pnpm-store`)

## Templates

- `run-pre-commit.yml` — Job template that runs pre-commit checks on PRs. Supports .NET, pnpm, and
  Terraform toolchains. Non-PR builds on branches not in `skipRefs` fail to prevent bypassing
  pre-commit.
- `pnpm-tasks.yml` — Step template that installs pnpm, authenticates against an internal npm feed,
  and restores dependencies.
- `detect-changed-paths.yml` — Job template for path-based change detection. Outputs boolean
  variables per path group.
- `publish-github-pages.yml` — Job template that deploys a build artifact to the `gh-pages` branch.

See [templates/README.md](templates/README.md) for full parameter docs and examples.
