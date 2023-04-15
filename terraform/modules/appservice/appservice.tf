# resource "azurerm_app_service_plan" "test" {
#   name                = "${var.application_type}-plan"
#   location            = "${var.location}"
#   resource_group_name = "${var.resource_group}"

#   sku {
#     tier = "Free"
#     size = "F1"
#   }
# }

# resource "azurerm_app_service" "test" {
#   name                = "${var.application_type}-testapp"
#   location            = "${var.location}"
#   resource_group_name = "${var.resource_group}"
#   app_service_plan_id = azurerm_app_service_plan.test.id

#   app_settings = {
#     "WEBSITE_RUN_FROM_PACKAGE" = 0
#   }
# }

resource "azurerm_service_plan" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  service_plan_id     = azurerm_service_plan.test.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = 0
  }
  site_config {
    always_on = false
  }
}