# terraform-example-patterns

This repo contains multiple examples of different patterns for Infrastructure as Code, focusing on Terraform & the Terragrunt wrapper.

## Terms
* [Terraform](https://www.terraform.io/intro/index.html) is an Open Source platform-agnostic scripting language for Infrastructure as Code
* [Terragrunt](https://github.com/gruntwork-io/terragrunt) is a thin wrapper around Terraform that allows pre-processing logic
* The [DRY Principle](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) stands for Don't Repeat Yourself, and calls for a reduction in duplicated script or data.

## Patterns
* [Basic Terraform](basic-terraform/README.md)
* [Module-based Terraform](module-terraform/README.md)
* [Module-based Terragrunt](module-terragrunt/README.md)
* [Environment Variable-based Terragrunt](envvar-terragrunt/README.md)
* [DRY Workspace-based Terragrunt](dry-workspace-terragrunt/README.md)
