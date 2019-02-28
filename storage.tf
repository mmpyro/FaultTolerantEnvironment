resource "azurerm_resource_group" "storageRG" {
  name     = "dev-storage-weuro"
  location = "${var.location}"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "poissonStorage" {
  name                     = "${var.poisson_message_storage_name}"
  resource_group_name      = "${azurerm_resource_group.storageRG.name}"
  location                 = "${azurerm_resource_group.storageRG.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "mmvehicle"
  location            = "${azurerm_resource_group.storageRG.location}"
  resource_group_name = "${azurerm_resource_group.storageRG.name}"
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  

  enable_automatic_failover = false
  is_virtual_network_filter_enabled = false

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

   geo_location {
    prefix            = "tfex-cosmos-db-${random_integer.ri.result}-customid"
    location          = "${azurerm_resource_group.storageRG.location}"
    failover_priority = 0
  }
}