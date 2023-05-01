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

resource "azurerm_resource_group" "rg-daya-test-terraform" {
  name = var.azure-resource
  location = var.resource-location
}


# Creating DNS
resource "azurerm_virtual_network" "vn-daya-test-terraform"{
    name  = "vn-dt-terraform"
    resource_group_name = var.azure-resource
    location = var.resource-location
    address_space = ["10.0.0.0/16"]
    tags = {
        environment = "dev"
    }
}
resource "azurerm_dns_zone" "zone-daya"{
  name = "daya.com"
  resource_group_name =  var.azure-resource
}
resource "azurerm_public_ip" "pip" {
  name                = "pip-daya-test"
  resource_group_name = var.azure-resource
  location            = var.resource-location
  allocation_method   = "Static"
  ip_version = "IPv4"
  sku = "Standard"
  sku_tier = "Regional"
  domain_name_label   = "daya-dns"
}
resource "azurerm_dns_a_record" "dns-record" {
  name                = "www"
  resource_group_name = var.azure-resource
  zone_name           = azurerm_dns_zone.zone-daya.name
  ttl                 = 1
  target_resource_id  = azurerm_public_ip.pip.id
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "vnet-sub-1"
  resource_group_name = var.azure-resource
  virtual_network_name = azurerm_virtual_network.vn-daya-test-terraform.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "subnet-2" {
  name                 = "vnet-sub-2"
  resource_group_name = var.azure-resource
  virtual_network_name = azurerm_virtual_network.vn-daya-test-terraform.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_network_interface" "network-interface" {
  name                = "vm-ni-daya-test"
  location            = var.resource-location
  resource_group_name = var.azure-resource

  ip_configuration {
    name                          = "daya-test-config1"
    subnet_id                     = azurerm_subnet.subnet-2.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Application Gateway 

resource "azurerm_application_gateway" "awf-daya-test" {
  name                = "appgatway"
  resource_group_name = var.azure-resource
  location            = var.resource-location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnet-1.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
    priority                   = 1
  }
}


resource "azurerm_virtual_machine" "vm-daya-test" {
  name                  = "vm-daya-test"
  location              = var.resource-location
  resource_group_name   = var.azure-resource
  network_interface_ids = [azurerm_network_interface.network-interface.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "daya"
    admin_password = "Daya1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}



