Using Terragrunt with separately deployed modules

## Considerations

Pros:
* Reusable Modules
* No Plumbing logic between Modules required
* New Accounts/Regions require minimum copy/paste 

Cons:
* Hardcoded and/or Repeated patterns for connections between modules
* Does not allow for arbitrary deployment environments without a new copy (although it could be modified to use [Terraform Workspaces](https://www.terraform.io/docs/state/workspaces.html))
  
## How to Deploy
```
cd systems/<account>/<region>/persistence
terragrunt apply

# review proposed changes and type the following:
yes

cd ../api
terragrunt apply

# review proposed changes and type the following:
yes
```

Alternatively, can deploy all related systems/modules without verifying output
```
cd systems/<account>/<region>
terragrunt apply-all

#accept the consequences
```

> N.B.: Remote state management has been setup, so someone else might have already deployed this infrastructure to your targeted account/region.