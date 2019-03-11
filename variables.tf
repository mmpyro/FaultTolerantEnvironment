variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
    default = "WEST EUROPE"
}

variable "function_app_storage_name" {
    default = "mmfuncappstorage"
}

variable "poisson_message_storage_name" {
  default = "mmvehiclestorage"
}

variable "db_name" {
  default = "mmvehicle"
}

variable "storage_resource_group_name" {
  default = "dev-storage-weuro"
}

variable "af_resource_group_name" {
  default = "dev-af-weuro"
}

variable "service_plan_name" {
  default = "azure-functions-dynamic-service-plan"
}

variable "circut_breaker_resource_group_name" {
  default = "dev-circutbreaker-weuro"
}

variable "event_grid_name" {
  default = "circutBreaker-eventgrid"
}

variable "cache_name" {
  default = "vehicle-cache"
}

variable "hubs_resource_group_name" {
  default = "dev-hubs-weuro"
}

variable "iot_hub_name" {
  default = "mmvehiclehub"
}

variable "event_hub_namespace_name" {
  default = "mmVehicleEventHubNamespace"
}

variable "function_extension_version" {
  default = "~2"
}