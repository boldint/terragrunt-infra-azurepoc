include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/boldint/terraform-azurerm-stack-pociac//network?ref=AP-1"
}

locals {
  common_vars       = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  unit              = local.common_vars.locals.unit
  projectappservice = local.common_vars.locals.projectappservice
}

#remote_state {
#  backend = local.common_vars.remote_state.backend
#  config = merge(
#    local.common_vars.remote_state.config,
#    {
#      workspaces = [{
#        name = "${local.unit}-${local.projectappservice}-${replace(path_relative_to_include(),'/','-')}"
#      }]
#    }
#  )
#}

# Check the above referenced code and the Bold terraform modules documentation to
# validate which variables may be passed!
inputs = {
  location            = "${split("/", path_relative_to_include())[1]}"
  resource_group_name = "${local.common_vars.locals.projectappservice}"
}
