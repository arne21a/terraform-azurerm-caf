
resource "azurecaf_name" "windows_web_app" {
  name          = var.name
  resource_type = "azurerm_app_service" # Implement resource type windows_web_app
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}



resource "azurerm_windows_web_app" "windows_web_app" {
  name                = azurecaf_name.windows_web_app.result
  location            = local.location
  resource_group_name = local.resource_group_name
  service_plan_id     = var.service_plan_id

  https_only = lookup(var.settings, "https_only", null)

  tags = merge(local.tags, try(var.settings.tags, {}))

  #client_affinity_enabled       = lookup(var.settings, "client_affinity_enabled", null)
  site_config {

    always_on                                     = lookup(var.settings.site_config, "always_on", false)
    api_definition_url                            = lookup(var.settings.site_config, "api_definition_url", null)
    api_management_api_id                         = lookup(var.settings.site_config, "api_management_api_id", null)
    app_command_line                              = lookup(var.settings.site_config, "app_command_line ", null)
    container_registry_managed_identity_client_id = lookup(var.settings.site_config, "container_registry_managed_identity_client_id", null)
    container_registry_use_managed_identity       = lookup(var.settings.site_config, "container_registry_use_managed_identity", null)
    default_documents                             = lookup(var.settings.site_config, "default_documents", null)
    ftps_state                                    = lookup(var.settings.site_config, "ftps_state", "Disabled")
    health_check_path                             = lookup(var.settings.site_config, "health_check_path", null)
    health_check_eviction_time_in_min             = lookup(var.settings.site_config, "health_check_eviction_time_in_min", null)
    http2_enabled                                 = lookup(var.settings.site_config, "http2_enabled", null)
    load_balancing_mode                           = lookup(var.settings.site_config, "load_balancing_mode", "LeastRequests")
    local_mysql_enabled                           = lookup(var.settings.site_config, "local_mysql_enabled", false)
    managed_pipeline_mode                         = lookup(var.settings.site_config, "managed_pipeline_mode", "Integrated")
    minimum_tls_version                           = lookup(var.settings.site_config, "minimum_tls_version", null)
    remote_debugging_enabled                      = lookup(var.settings.site_config, "remote_debugging_enabled", false)
    remote_debugging_version                      = lookup(var.settings.site_config, "remote_debugging_version", null)
    scm_minimum_tls_version                       = lookup(var.settings.site_config, "scm_minimum_tls_version", null)
    scm_use_main_ip_restriction                   = lookup(var.settings.site_config, "scm_use_main_ip_restriction", null)
    use_32_bit_worker                             = lookup(var.settings.site_config, "use_32_bit_worker", null)
    vnet_route_all_enabled                        = lookup(var.settings.site_config, "vnet_route_all_enabled", false)
    websockets_enabled                            = lookup(var.settings.site_config, "websockets_enabled", false)
    worker_count                                  = lookup(var.settings.site_config, "worker_count", null)

    #cors                = lookup(var.settings.site_config, "cors", null) - todo

    #application_stack   = lookup(var.settings.site_config, "application_stack", false) - todo

    #virtual_application = lookup(var.settings.site_config, "virtual_application", null) - todo

    #handler_mapping     = lookup(var.settings.site_config, "handler_mapping", null) - todo

    auto_heal_enabled = lookup(var.settings.site_config, "auto_heal_enabled", false)
    auto_heal_setting {
      action {
        action_type = lookup(var.settings.site_config.auto_heal_setting.action, "action_type", "LogEvent")
        # custom_action = "" - todo
        minimum_process_execution_time = lookup(var.settings.site_config.auto_heal_setting.action, "minimum_process_execution_time", null)
      }
      trigger {
        private_memory_kb = lookup(var.settings.site_config.auto_heal_setting.trigger, "private_memory_kb", null)
        #requests = "" - todo
        #slow_request = "" - todo
        #status_code = "" - todo
      }
    }


    #ip_restriction               = lookup(var.settings.site_config, "ip_restriction", null) - todo
    # ip_restriction_default_action = lookup(var.settings.site_config, "ip_restriction_default_action", "Allow") - not supported in azurerm 3.75

    #scm_ip_restriction               = lookup(var.settings.site_config, "scm_ip_restriction", null) - todo
    #scm_ip_restriction_default_action = lookup(var.settings.site_config, "scm_ip_restriction_default_action", null) - not supported in azurerm 3.75
  }

}
