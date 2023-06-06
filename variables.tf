variable "azure-resource" {
  type        = string
  sensitive   = true
  description = "Creating a resource"
}

variable "resource-location" {
  type        = string
  sensitive   = true
  description = "Resource location"
}

variable "PORT" {
  type        = number
  sensitive   = true
  description = "setting port"
}

variable "NAME" {
  type        = string
  sensitive   = true
  description = "Setting env variable"
}

variable "frontend_port_name" {
  type        = string
  sensitive   = true
  description = "front-end port name"
}
variable "frontend_port_name_ssl_cert" {
  type        = string
  sensitive   = true
  description = "front-end port name for SSL"
}
variable "frontend_ip_configuration" {
  type        = string
  sensitive   = true
  description = "frontend ip configuration"
}

variable "backend_address_pool_name" {
  type        = string
  sensitive   = true
  description = "backend-end pool name"
}
variable "http_setting_name" {
  type        = string
  sensitive   = true
  description = "http setting name "
}
variable "listener_name" {
  type        = string
  sensitive   = true
  description = "listener name"
}
variable "listener_name_ssl" {
  type        = string
  default     = true
  description = "SSL listener name"
}

variable "request_routing_rule_name" {
  type        = string
  sensitive   = true
  description = "routing rule name"
}

variable "os-profile-computer-name" {
  type        = string
  sensitive   = true
  description = "computerName"
}

variable "os-profile-admin-username" {
  type        = string
  sensitive   = true
  description = "admin username"
}
variable "os-profile-admin-password" {
  type        = string
  sensitive   = true
  description = "admin password"
}

variable "kv-key-permissions-full" {
  type        = list(string)
  description = "List of full key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey."
  default     = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
}
variable "kv-secret-permissions-full" {
  type        = list(string)
  description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
  default     = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
}
variable "kv-certificate-permissions-full" {
  type        = list(string)
  description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
  default     = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "SetIssuers", "Update", "Backup", "Restore"]
}
variable "kv-storage-permissions-full" {
  type        = list(string)
  description = "List of full storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
  default     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
}