# build

Shared Azure DevOps pipeline templates for EWN.

## Usage

Add as a repository resource in your `azure-pipelines.yml`:

```yaml
resources:
  repositories:
    - repository: build
      type: github
      name: energyworldnet/build
      endpoint: proddev
```

Then reference pipeline templates. See [templates/](templates/) for available templates and
parameter docs.
