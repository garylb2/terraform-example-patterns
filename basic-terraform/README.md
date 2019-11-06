Using terraform without any shared/isolated modules

## Considerations

Pros:
* No Plumbing/boilerplate required

Cons:
* Lots of copy/paste
  * Not Maintainable
  * Not Reusable
  * Easy to fat finger / Forget to update
* Does not allow for arbitrary deployment environments without a new copy (although it could be modified to use [Terraform Workspaces](https://www.terraform.io/docs/state/workspaces.html))
  
## Caveats
I did not use variable files or workspace logic, which could mitigate some, but not all, of the Cons.  Using such techniques increases the complexity of executing the deployments, namely requiring command line options.  
  
## How to Deploy
```
cd <account>/<region>/lookup
terraform init # first time only
terraform apply

# review proposed changes and type the following:
yes
```

> N.B.: Remote state management has been setup, so someone else might have already deployed this infrastructure to your targeted account/region.