include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/boldint/terraform-azurerm-stack-pociac//network?ref=AP-1"
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

# Check the above referenced code and the Bold terraform modules documentation to
# validate which variables may be passed!
generate "tfvars" {
  path              = "terragrunt.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<EOF
resource_group_name = "${local.common_vars.locals.projectappservice}"
location = "${local.common_vars.locals.location}"
EOF
}
