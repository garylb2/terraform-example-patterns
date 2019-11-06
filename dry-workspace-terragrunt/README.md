Using Terragrunt with separately deployed modules, using [Terraform Workspaces](https://www.terraform.io/docs/state/workspaces.html) to allow for arbitrary Deployment Environments

## Considerations

Pros:
* Allows for Arbitrary Deployment Environments (dev, qa, brown, etc.)
* Reusable Modules
* New Accounts/Regions require minimum copy/paste

Cons:
* Either
  * Modules with Plumbing Logic required
  * Hardcoded and/or Repeated patterns for connections between modules
* No current method to easily check or change [Terraform Workspaces](https://www.terraform.io/docs/state/workspaces.html) across multiple systems/modules
  
## How to Deploy

For default deployment environment and/or currently set custom environment
```
cd systems/<account>/<region>/lookup
terragrunt apply

# review proposed changes and type the following:
yes
```

for non-default deployment environments
```
cd systems/<account>/<region>/lookup
terragrunt workspace <desired deployment environment>
terragrunt apply

# review proposed changes and type the following:
yes
```

To reset to the default environment `terragrunt workspace default`

> N.B.: Remote state management has been setup, so someone else might have already deployed this infrastructure to your targeted account/region.