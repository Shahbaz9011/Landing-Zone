Rg_prod_New = {
  Rg_prod_New = {

    name       = "Rg_prod_New"
    location   = "centralindia"
    managed_by = "Anshul"
  }
}

Vnet_prod = {

  Vnet_prod_1 = {
    name                = "Vnet_prod_1"
    resource_group_name = "Rg_prod_New"
    location            = "Centralindia"
    address_space       = ["10.0.0.0/16"]
  }

  Vnet_prod_2 = {
    name                = "Vnet_prod_2"
    resource_group_name = "Rg_prod_New"
    location            = "Centralindia"
    address_space       = ["192.168.0.0/16"]
  }
}


subnet_prod = {

  Subnet_1 = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "Rg_prod_New"
    virtual_network_name = "Vnet_prod_1"
    address_prefixes     = ["10.0.0.0/26"]
  }


  Subnet_2 = {
    name                 = "Subnet_prod_1"
    resource_group_name  = "Rg_prod_New"
    virtual_network_name = "Vnet_prod_1"
    address_prefixes     = ["10.0.2.0/24"]
  }

  Subnet_3 = {
    name                 = "Subnet_prod_2"
    resource_group_name  = "Rg_prod_New"
    virtual_network_name = "Vnet_prod_2"
    address_prefixes     = ["192.168.1.0/24"]
  }
    Subnet_4 = {
    name                 = "Subnet_prod_4"
    resource_group_name  = "Rg_prod_New"
    virtual_network_name = "Vnet_prod_1"
    address_prefixes     = ["10.0.10.0/24"]
  }
}

Vnet_prod_1_to_Vnet_prod_2 = {

  Vnet_prod_1_to_Vnet_prod_2 = {
    name                 = "Vnet_prod_1_to_Vnet_prod_2"
    resource_group_name  = "Rg_prod_New"
    virtual_network_name = "Vnet_prod_1"
  }
}

Vnet_prod_2_to_Vnet_prod_1 = {

  Vnet_prod_2_to_Vnet_prod_1 = {
    name                 = "Vnet_prod_2_to_Vnet_prod_1"
    resource_group_name  = "Rg_prod_New"
    virtual_network_name = "Vnet_prod_2"
  }
}

Nic_prod = {

    Nic1 = {

        name = "Subnet_2"
        resource_group_name = "Rg_prod_New"
        location = "centralindia"
        subnet_id = "Subnet_2"
        private_ip_address = "10.0.2.10"
    }


    
    Nic2 = {

        name = "Subnet_3"
        resource_group_name = "Rg_prod_New"
        location = "centralindia"
        subnet_id = "Subnet_3"   
        private_ip_address = "192.168.1.10"
    }
        Nic3 = {

        name = "Subnet_4"
        resource_group_name = "Rg_prod_New"
        location = "centralindia"
        subnet_id = "Subnet_4"   
        private_ip_address = "10.0.10.10"
    }
}

Vm_prod = {

    Vm1= {

    name                = "vm-prod-01"
    resource_group_name = "Rg_prod_New"
    location            = "centralindia"
    size                = "Standard_D2s_v3"
    nic_key             = "Nic1"
    admin_username      = "azureuser"
    admin_password      = "Huawei@123"
    }

    vm2 = {
    name                = "vm-prod-02"
    resource_group_name = "Rg_prod_New"
    location            = "centralindia"
    size                = "Standard_D2s_v3"
    nic_key             = "Nic2"
    admin_username      = "azureuser"
    admin_password      = "Nokia@123"
  }

      vm3 = {
    name                = "vm-prod-03"
    resource_group_name = "Rg_prod_New"
    location            = "centralindia"
    size                = "Standard_D2s_v3"
    nic_key             = "Nic3"
    admin_username      = "azureuser"
    admin_password      = "Zte@123"
  }
}