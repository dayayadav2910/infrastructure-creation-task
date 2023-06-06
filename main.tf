terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg-daya-test-terraform" {
  name     = var.azure-resource
  location = var.resource-location
}



# Virtual network
resource "azurerm_virtual_network" "vnet-daya" {
  name                = "vnet-daya-test"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource-location
  resource_group_name = var.azure-resource
}

# Data Sources
data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "kv-daya-test-4" {
  name                = "kv-daya-test-4"
  resource_group_name = var.azure-resource
}
# Key-vault Certificate
data "azurerm_key_vault_certificate" "key-vault-certificate" {
  name         = "kv-daya-test"
  key_vault_id = data.azurerm_key_vault.kv-daya-test-4.id
}


# Key-Vault-access-policy
resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id = data.azurerm_key_vault.kv-daya-test-4.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.user_assigned.principal_id

  key_permissions         = var.kv-key-permissions-full
  secret_permissions      = var.kv-secret-permissions-full
  storage_permissions     = var.kv-storage-permissions-full
  certificate_permissions = var.kv-certificate-permissions-full
}

# Public IP  
resource "azurerm_public_ip" "pip_ip" {
  name                = "awf_public_ip"
  location            = var.resource-location
  resource_group_name = var.azure-resource
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Subnet
resource "azurerm_subnet" "sub-net" {
  name                 = "subnet-daya-test"
  resource_group_name  = var.azure-resource
  virtual_network_name = azurerm_virtual_network.vnet-daya.name
  address_prefixes     = ["10.0.3.0/24"]
}


# User Assigned Identity
resource "azurerm_user_assigned_identity" "user_assigned" {
  name                = "daya-test-user"
  resource_group_name = var.azure-resource
  location            = var.resource-location
}

# Application Gateway 
resource "azurerm_application_gateway" "app_gateway" {
  name                = "myAppGateway"
  resource_group_name = var.azure-resource
  location            = var.resource-location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned.id
    ]
  }


  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.sub-net.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration
    public_ip_address_id = azurerm_public_ip.pip_ip.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = data.azurerm_key_vault_certificate.key-vault-certificate.name
  }
  ssl_certificate {
    name                = data.azurerm_key_vault_certificate.key-vault-certificate.name
    key_vault_secret_id = data.azurerm_key_vault_certificate.key-vault-certificate.versionless_secret_id
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    priority                   = 2
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
  }

  depends_on = [
    azurerm_key_vault_access_policy.kv_access_policy
  ]

}
