resource "azurerm_resource_group" "Rg_prod_New" {

  for_each   = var.Rg_prod_New
  name       = each.value.name
  location   = each.value.location
  managed_by = each.value.managed_by


}

resource "azurerm_virtual_network" "Vnet_prod" {

  for_each            = var.Vnet_prod
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space

  depends_on = [azurerm_resource_group.Rg_prod_New]
}

resource "azurerm_subnet" "Subnet_prod" {

  for_each = var.subnet_prod

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes

  depends_on = [azurerm_virtual_network.Vnet_prod]

}

resource "azurerm_virtual_network_peering" "Vnet_prod_1_to_Vnet_prod_2" {

  for_each = var.Vnet_prod_1_to_Vnet_prod_2

  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.Vnet_prod["Vnet_prod_2"].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}


resource "azurerm_virtual_network_peering" "Vnet_prod_2_to_Vnet_prod_1" {

  for_each = var.Vnet_prod_2_to_Vnet_prod_1

  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.Vnet_prod["Vnet_prod_1"].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_network_security_group" "Prod" {

  name                = "NSG_prod"
  location            = "centralindia"
  resource_group_name = "Rg_prod_New"

  security_rule {

    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
  }

}

resource "azurerm_subnet_network_security_group_association" "Subnet_2" {

  subnet_id                 = azurerm_subnet.Subnet_prod["Subnet_2"].id
  network_security_group_id = azurerm_network_security_group.Prod.id

}

resource "azurerm_subnet_network_security_group_association" "Subnet_3" {

  subnet_id                 = azurerm_subnet.Subnet_prod["Subnet_3"].id
  network_security_group_id = azurerm_network_security_group.Prod.id

}

resource "azurerm_network_interface" "Nic_prod" {

    for_each = var.Nic_prod

    name = each.value.name
    location =each.value.location
    resource_group_name = each.value.resource_group_name

ip_configuration {

name = "internal"
subnet_id = azurerm_subnet.Subnet_prod[each.value.subnet_id].id
private_ip_address_allocation = "Static" 
private_ip_address            = each.value.private_ip_address   

  
}
}

resource "azurerm_linux_virtual_machine" "Vm_prod" {

    for_each = var.Vm_prod

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  disable_password_authentication = false

   network_interface_ids = [
    azurerm_network_interface.Nic_prod[each.value.nic_key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  depends_on = [ azurerm_subnet.Subnet_prod ]
}

  
resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion"
  location            = "centralindia"
  resource_group_name = "Rg_prod_New"

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_bastion_host" "prod" {

  name                = "bastion-prod"
  location            = "centralindia"
  resource_group_name = "Rg_prod_New"

  sku = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.Subnet_prod["Subnet_1"].id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}


resource "azurerm_virtual_machine_extension" "nginx" {

  for_each = azurerm_linux_virtual_machine.Vm_prod

  name                 = "install-nginx"
  virtual_machine_id   = each.value.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = "sudo apt-get update && sudo apt-get install -y nginx && sudo systemctl enable nginx && sudo systemctl start nginx"
  })
depends_on = [ azurerm_linux_virtual_machine.Vm_prod ]
}
