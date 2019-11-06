Using Terragrunt with separately deployed modules, using Environment Variables to describe current AWS Account, AWS Region, & Deployment Environment

## Considerations

Pros:
* Allows for Arbitrary Deployment Environments (dev, qa, brown, etc.)
* Extra DRY without any duplication of system entry points or Terraform configuration for differing AWS Accounts, AWS Regions and/or Deployment Environments
* Reusable Modules
* New Accounts/Regions require only configuration to be created 

Cons:
* Either
  * Modules with Plumbing Logic required
  * Hardcoded and/or Repeated patterns for connections between modules
* Large chance of Human Error based on Lack of Visibility of the Current State of Environment Variables
  
## How to Deploy

For default deployment - lab16, us-west-2, test env
```
cd systems/lookup
terragrunt apply

# review proposed changes and type the following:
yes
```

for non-default
```
export TF_VAR_env=<desired deployment environment>
export TF_VAR_region=<AWS Region Name>
export TF_VAR_account_name = <AWS Account Name>

cd systems/lookup
terragrunt apply

# review proposed changes and type the following:
yes
```

> N.B.: Remote state management has been setup, so someone else might have already deployed this infrastructure to your targeted account/region.