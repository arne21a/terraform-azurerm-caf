data "azurerm_billing_enrollment_account_scope" "sub" {
  for_each = try(var.settings.enrollment_account_name, null) != null ? {"ea": "true"} : {}
  billing_account_name    = var.settings.billing_account_name
  enrollment_account_name = var.settings.enrollment_account_name
}

data "azurerm_billing_mca_account_scope" "sub" {
  for_each = try(var.settings.invoice_section_name, null) != null ? {"mca": "true"} : {}
  billing_account_name = var.settings.billing_account_name
  billing_profile_name = var.settings.billing_profile_name // eg. "PE2Q-NOIT-BG7-TGB" 
  invoice_section_name = var.settings.invoice_section_name // eg. "MTT4-OBS7-PJA-TGB" 
}

/* data "external" "role_definition" {
  program = [
    "bash", "-c",
    "az rest --method GET --url ${var.cloud.resourceManager}${local.billing_scope_id}/billingRoleDefinitions?api-version=2019-10-01-preview --query \"value[?properties.roleName=='${var.billing_role_definition_name}'].{id:id}[0]\" -o json"
  ]

  #
  # az rest --method GET \
  #   --url https://management.azure.com${data.azurerm_billing_enrollment_account_scope.sub.id}/billingRoleDefinitions?api-version=2019-10-01-preview \
  #   --query "value[?properties.roleName=='${var.billing_role_definition_name}'].{id:id}[0]" -o json

} */

locals {
  billing_scope_id = (try(var.settings.enrollment_account_name, null) != null ? 
    data.azurerm_billing_enrollment_account_scope.sub["ea"].id :
    data.azurerm_billing_mca_account_scope.sub["mca"].id)
}
/* 
module "role_assignment_azuread_users" {
  source   = "./role_assignment"
  for_each = try(var.settings.principals.azuread_users, {})

  billing_scope_id   = local.billing_scope_id
  tenant_id          = try(var.principals.azuread_users[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.key].tenant_id, var.client_config.tenant_id)
  principal_id       = var.principals.azuread_users[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.key].rbac_id
  role_definition_id = data.external.role_definition.result.id
  settings           = each.value
  cloud              = var.cloud
}


module "role_assignment_msi" {
  source     = "./role_assignment"
  for_each   = try(var.settings.principals.managed_identities, {})
  depends_on = [module.role_assignment_azuread_users]

  aad_user_impersonate = try(var.keyvaults[try(each.value.lz_key, var.client_config.landingzone_key)][var.settings.aad_user_impersonate.keyvault.key], null)
  billing_scope_id     = local.billing_scope_id
  tenant_id            = try(var.principals.managed_identities[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.key].tenant_id, var.client_config.tenant_id)
  principal_id         = var.principals.managed_identities[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.key].principal_id
  role_definition_id   = data.external.role_definition.result.id
  settings             = each.value
  cloud                = var.cloud
}


module "role_assignment_azuread_service_principals" {
  source     = "./role_assignment"
  for_each   = try(var.settings.principals.azuread_service_principals, {})
  depends_on = [module.role_assignment_azuread_users, module.role_assignment_msi]

  aad_user_impersonate = try(var.keyvaults[try(each.value.lz_key, var.client_config.landingzone_key)][var.settings.aad_user_impersonate.keyvault.key], null)
  billing_scope_id     = local.billing_scope_id
  tenant_id            = try(var.principals.azuread_service_principals[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.key].tenant_id, var.client_config.tenant_id)
  principal_id         = var.principals.azuread_service_principals[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.key].object_id
  role_definition_id   = data.external.role_definition.result.id
  settings             = each.value
  cloud                = var.cloud
}
 */

resource "azurerm_role_assignment" "mca_role_assignment_azuread_apps" {
  for_each   = try(var.settings.principals.azuread_apps, {})

  scope                = local.billing_scope_id
  role_definition_name = "Contributor"
  principal_id         = var.principals.azuread_apps[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.key].azuread_service_principal.id
}

//Todo: Change variable structure. Replace logged_in_subscription and "key" = "caf_launchpad_level0"
/* subscription_billing_role_assignments = {
  logged_in_subscription = {
    billing_role_definition_name = "string"
    billing_account_name = "foo"
    billing_profile_name = "bar"
    invoice_section_name = "baz"
    principals = {
      azuread_apps = {
        caf_launchpad_level0 = {
          "key" = "caf_launchpad_level0"
        }
      }
      
    }
  }
} */