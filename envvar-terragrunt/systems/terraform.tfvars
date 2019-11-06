terragrunt = {
  terraform {
    before_hook "interpolation_hook_1" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      execute = ["echo", "env=${get_env("TF_VAR_env", "test")}\nregion=${get_env("TF_VAR_region", "us-west-2")}\naccount_name=${get_env("TF_VAR_account_name", "awscoxautolabs16")}"]
      run_on_error = true
    }
    before_hook "verify_hook_1" {
      commands = [
        "${get_terraform_commands_that_need_vars()}"]
      execute = ["read", "verify"]
      run_on_error = false
    }

    extra_arguments "vars" {
      commands  = ["${get_terraform_commands_that_need_vars()}"]
      required_var_files = [
        "${get_parent_tfvars_dir()}/../configs/application.tfvars",
        "${get_parent_tfvars_dir()}/../configs/accounts/${get_env("TF_VAR_account_name", "awscoxautolabs16")}/account.tfvars",
      ]
      optional_var_files = [
        "${get_parent_tfvars_dir()}/../configs/regions/${get_env("TF_VAR_region", "us-west-2")}/region.tfvars",
        "${get_parent_tfvars_dir()}/../configs/accounts/${get_env("TF_VAR_account_name", "awscoxautolabs16")}/${get_env("TF_VAR_region", "us-west-2")}/region.tfvars",
      ]
      arguments = [
        "-var", "repoRoot=${get_parent_tfvars_dir()}/../..",
        "-var", "env=${get_env("TF_VAR_env", "test")}",
        "-var", "region=${get_env("TF_VAR_region", "us-west-2")}",
        "-var", "account_name=${get_env("TF_VAR_account_name", "awscoxautolabs16")}",
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
      key = "app/envvar-terragrunt/${get_env("TF_VAR_account_name", "awscoxautolabs16")}/${get_env("TF_VAR_region", "us-west-2")}/${get_env("TF_VAR_environment", "test")}/${path_relative_to_include()}/terraform.tfstate"
    }
  }
}