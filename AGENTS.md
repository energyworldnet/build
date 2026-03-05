# energyworldnet/build

Shared Azure DevOps pipeline templates for EWN.

## Structure

All Azure Pipelines templates live in `templates/` and are referenced from consuming repos via `@build` resource syntax:

```yaml
resources:
  repositories:
  - repository: build
    type: github
    name: energyworldnet/build
    endpoint: proddev
```

## Conventions

- Consuming pipelines reference templates as `templates/<name>.yml@build`
- Environment names are hardcoded in deployment templates so Azure DevOps can enforce template requirements
- See [templates/README.md](templates/README.md) for parameter docs and examples
