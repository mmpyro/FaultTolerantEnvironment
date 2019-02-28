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