terragrunt = {
  terraform {
    extra_arguments "vars" {
      commands  = ["${get_terraform_commands_that_need_vars()}"]
      required_var_files = [
        "${get_parent_tfvars_dir()}/application.tfvars",
        "${get_tfvars_dir()}/../../account.tfvars",
      ]
      optional_var_files = [
        "${get_tfvars_dir()}/../region.tfvars",
      ]
      arguments = [
        "-var", "repoRoot=${get_parent_tfvars_dir()}/../..",
      ]
    }
  }


  remote_state {
    backend = "s3"
    config {
      dynamodb_table = "terragrunt_locks"
      encrypt = true
      region = "us-east-1"
      bucket = "terraform-${get_aws_account_id()}-us-east-1"
      key = "app/module-terragrunt/${path_relative_to_include()}/terraform.tfstate"
    }
  }
}