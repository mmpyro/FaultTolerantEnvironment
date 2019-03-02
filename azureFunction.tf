resource "azurerm_resource_group" "functionRG" {
  name     = "dev-af-weuro"
  location = "${var.location}"
}

resource "azurerm_storage_account" "functionStorage" {
  name                     = "${var.function_app_storage_name}"
  resource_group_name      = "${azurerm_resource_group.functionRG.name}"
  location                 = "${azurerm_resource_group.functionRG.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "servicePlan" {
  name                = "azure-functions-dynamic-service-plan"
  location            = "${azurerm_resource_group.functionRG.location}"
  resource_group_name = "${azurerm_resource_group.functionRG.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "without-error-handling-function-app" {
  name                      = "snapshot-manager-without-error-handling"
  location                  = "${azurerm_resource_group.functionRG.location}"
  resource_group_name       = "${azurerm_resource_group.functionRG.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.servicePlan.id}"
  storage_connection_string = "${azurerm_storage_account.functionStorage.primary_connection_string}"
}

resource "azurerm_function_app" "polly-function-app" {
  name                      = "snapshot-manager-polly"
  location                  = "${azurerm_resource_group.functionRG.location}"
  resource_group_name       = "${azurerm_resource_group.functionRG.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.servicePlan.id}"
  storage_connection_string = "${azurerm_storage_account.functionStorage.primary_connection_string}"
}


resource "azurerm_function_app" "function-twin" {
  name                      = "snapshot-manager-function-twin"
  location                  = "${azurerm_resource_group.functionRG.location}"
  resource_group_name       = "${azurerm_resource_group.functionRG.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.servicePlan.id}"
  storage_connection_string = "${azurerm_storage_account.functionStorage.primary_connection_string}"
}

resource "azurerm_function_app" "circut-breaker-function-app" {
  name                      = "snapshot-manager-circut-breaker"
  location                  = "${azurerm_resource_group.functionRG.location}"
  resource_group_name       = "${azurerm_resource_group.functionRG.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.servicePlan.id}"
  storage_connection_string = "${azurerm_storage_account.functionStorage.primary_connection_string}"
}