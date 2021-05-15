generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}

terraform {
  required_version = ">= 0.12.20"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.51.0"
    }
  }
}
EOF
}

#locals {
#  tfc_hostname     = "app.terraform.io" # For TFE, substitute the custom hostname for your TFE host
#  tfc_organization = "gruntwork-io"
#  workspace        = reverse(split("/", get_terragrunt_dir()))[0] # This will find the name of the module, such as "sqs"
#  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
#  region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))
#}

locals {
  # Read all variables defined in parent folders!
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl", "common.hcl"))
  #from_bootstrap_vars = read_terragrunt_config(find_in_parent_folders("from_bootstrap.hcl", "from_bootstrap.hcl"))

  # Extract variables for easy access
  tfc_hostname      = local.common_vars.locals.tfc_hostname
  entity            = local.common_vars.locals.entity
  unit              = local.common_vars.locals.unit
  projectappservice = local.common_vars.locals.projectappservice
  environment       = local.common_vars.locals.environment
  location          = local.common_vars.locals.location
  location_short    = local.common_vars.locals.location_short
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "remote" {
    hostname = "${local.tfc_hostname}"
    organization = "${local.entity}"
    workspaces {
      name = "${local.environment}-${local.location}"
    }
  }
}
EOF
}
