terragrunt = {
  terraform {
    ## the // tells terragrunt to copy contents of previous path into temp dirs
    source = "../../../../modules/persistence"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}