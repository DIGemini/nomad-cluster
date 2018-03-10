# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# ARM_SUBSCRIPTION_ID
# ARM_TENANT_ID
# ARM_CLIENT_ID
# ARM_CLIENT_SECRET
	
# ARM_RESOURCE_GROUP
# ARM_STORAGE_ACCOUNT

# TF_VAR_azure_resource_group
variable "azure_resource_group" {
  description = "The Azure resource group."
  default     = "hashicorp"
}

# TF_VAR_azure_storage_account
variable "azure_storage_account" {
  description = "The Azure storage account."
  default     = "hashicorpstorage"
}

variable "environment" {
  description = "The deployment environment"
  default     = "test"
}

# ---------------------------------------------------------------------------------------------------------------------
# LOGIN PARAMETERS
# Administrator user name and password
# ---------------------------------------------------------------------------------------------------------------------

variable "master_admin_username" {
  description = "The adminstrator username for master."
  default     = "ubuntu"
}
variable "master_admin_password" {
  description = "The adminstrator password for master."
  default     = "ubuntu"
}
variable "slave_admin_username" {
  description = "The adminstrator username for slave."
  default     = "ubuntu"
}
variable "slave_admin_password" {
  description = "The adminstrator password for slave."
  default     = "ubuntu"
}
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "azure_region" {
  description = "The Azure region to deploy into (e.g. australiaeast)."
  default     = "australiaeast"
}

variable "vm_size" {
   description = "What kind of instance type to use for the nomad clients"
   default     = "Standard_B1s"
}

variable "server_count" {
   description = "Number of server instances in consul-nomad cluster"
   default     = "3"
}

variable "client_count" {
   description = "Number of client instances in consul-nomad cluster"
   default     = "2"
}