module "resource-group" {
    source = "../../child_module/azure_resource_group"
    resource_group_name = "dev1-rg"
    location = "westus"
}

module "virtual-network" {
    depends_on = [ module.resource-group ]
    source = "../../child_module/azure_virtual_network"
    virtual_network_name = "dev1-vnet"
    address_space = ["10.0.0.0/16"]
    resource_group_name = "dev1-rg"
    location = "westus"
}

module "subnet" {
    depends_on = [ module.resource-group , module.virtual-network ]
    source = "../../child_module/azure_subnet"
    subnet_name = "dev1-subnet"
    resource_group_name = "dev1-rg"
    virtual_network_name = "dev1-vnet"
    address_prefixes = ["10.0.2.0/24"]
}

module "public-ip" {
    depends_on = [ module.resource-group ]
    source = "../../child_module/azure_public_ip"
    public_ip_name = "dev1-pip"
     resource_group_name = "dev1-rg"
    location = "westus"
}

module "vm_nsg" {
    depends_on = [ module.resource-group ]
  source              = "../../child_module/azurerm_network_security_group"
  nsg_name            = "dev1-nsg"
  resource_group_name = "dev1-rg"
  location            = "westus"
}


module "virtual-machine" {
  depends_on = [ module.resource-group, module.virtual-network, module.subnet, module.public-ip, module.vm_nsg ]
  source              = "../../child_module/azure_virtual_machine"
  nic_name            = "dev1-nic"
  resource_group_name = "dev1-rg"
  location            = "westus"
  vm_name             = "devvm1"
  public_ip_name      = "dev1-pip"
  subnet_name         = "dev1-subnet"
  virtual_network_name = "dev1-vnet"
  nsg_name            = "dev1-nsg"
  nsg_id              = module.vm_nsg.nsg_id
}

