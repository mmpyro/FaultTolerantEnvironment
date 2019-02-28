resource "azurerm_resource_group" "hubsRG" {
  name     = "dev-hubs-weuro"
  location = "${var.location}"
}

resource "azurerm_eventhub_namespace" "hubNamespace" {
  name                = "mmVehicleEventHubNamespace"
  location            = "${azurerm_resource_group.hubsRG.location}"
  resource_group_name = "${azurerm_resource_group.hubsRG.name}"
  sku                 = "Standard"
  capacity            = 1
  kafka_enabled       = false
}

resource "azurerm_eventhub" "eventHub" {
  name                = "vehicles"
  namespace_name      = "${azurerm_eventhub_namespace.hubNamespace.name}"
  resource_group_name = "${azurerm_resource_group.hubsRG.name}"
  partition_count     = 8
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "consumerGroupWithoutErrorHandling" {
  name                = "without-error-hndling"
  namespace_name      = "${azurerm_eventhub_namespace.hubNamespace.name}"
  eventhub_name       = "${azurerm_eventhub.eventHub.name}"
  resource_group_name = "${azurerm_resource_group.hubsRG.name}"
}

resource "azurerm_eventhub_consumer_group" "consumerGroupPolly" {
  name                = "polly"
  namespace_name      = "${azurerm_eventhub_namespace.hubNamespace.name}"
  eventhub_name       = "${azurerm_eventhub.eventHub.name}"
  resource_group_name = "${azurerm_resource_group.hubsRG.name}"
}

resource "azurerm_eventhub_consumer_group" "consumerGroupFunctionTwin" {
  name                = "twin"
  namespace_name      = "${azurerm_eventhub_namespace.hubNamespace.name}"
  eventhub_name       = "${azurerm_eventhub.eventHub.name}"
  resource_group_name = "${azurerm_resource_group.hubsRG.name}"
}

resource "azurerm_eventhub_authorization_rule" "eventHubAuthorizationRule" {
  name                = "iothub"
  namespace_name      = "${azurerm_eventhub_namespace.hubNamespace.name}"
  eventhub_name       = "${azurerm_eventhub.eventHub.name}"
  resource_group_name = "${azurerm_resource_group.hubsRG.name}"
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "eventHubSnapshotManagerSendPolicy" {
  name                = "snapshot-manager"
  namespace_name      = "${azurerm_eventhub_namespace.hubNamespace.name}"
  eventhub_name       = "${azurerm_eventhub.eventHub.name}"
  resource_group_name = "${azurerm_resource_group.hubsRG.name}"
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_iothub" "iotHub" {
  name                = "mmvehiclehub"
  resource_group_name = "${azurerm_resource_group.hubsRG.name}"
  location            = "${azurerm_resource_group.hubsRG.location}"

  endpoint {
    type                       = "AzureIotHub.EventHub"
    connection_string          = "${azurerm_eventhub_authorization_rule.eventHubAuthorizationRule.primary_connection_string}"
    name                       = "vehicles"
  }

  route {
    name           = "embeded"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["events"]
    enabled        = true
  }

  route {
    name           = "vehicles"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["vehicles"]
    enabled        = true
  }

  sku {
    name     = "F1"
    tier     = "Free"
    capacity = "1"
  }
}