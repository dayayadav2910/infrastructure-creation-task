variable "azure-resource" {
  type        = string
  sensitive   = true
  description = "Creating a resource"
}

variable "resource-location" {
  type        = string
  default     = "West Europe"
  description = "Resource location"
}

variable "PORT" {
  type        = number
  default     = 5000
  description = "setting port"
}

variable "NAME" {
  type        = string
  default     = "DAYA"
  description = "Setting env variable"
}

variable "frontend_port_name" {
  type        = string
  sensitive   = true
  description = "front-end port name"
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



