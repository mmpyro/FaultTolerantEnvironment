resource "azurerm_resource_group" "circutBreakerRG" {
  name     = "dev-circutbreaker-weuro"
  location = "${var.location}"
}

resource "azurerm_eventgrid_topic" "circutBreakerTopic" {
  name                = "circutBreaker-eventgrid"
  location            = "${azurerm_resource_group.circutBreakerRG.location}"
  resource_group_name = "${azurerm_resource_group.circutBreakerRG.name}"
}

resource "azurerm_redis_cache" "redis" {
  name                = "vehicle-cache"
  location            = "${azurerm_resource_group.circutBreakerRG.location}"
  resource_group_name = "${azurerm_resource_group.circutBreakerRG.name}"
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false

  redis_configuration {
    maxmemory_policy   = "allkeys-lru"
  }
}