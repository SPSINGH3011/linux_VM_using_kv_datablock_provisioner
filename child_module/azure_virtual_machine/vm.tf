# resource "azurerm_network_security_rule" "ssh" {
#   name                        = "allow-ssh"
#   priority                    = 1001
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "22"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = var.nsg_name
# }

# resource "azurerm_network_interface_security_group_association" "nic_nsg" {
#   network_interface_id      = azurerm_network_interface.nic.id
#   network_security_group_id = var.nsg_id
# }


# resource "azurerm_network_interface" "nic" {
#   name                = var.nic_name
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = data.azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = data.azurerm_public_ip.pip.id
#   }
# }

# resource "azurerm_linux_virtual_machine" "vm" {
#   name                = var.vm_name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   size                = "Standard_F2"
#   admin_username      = data.azurerm_key_vault_secret.username.value
#   admin_password      = data.azurerm_key_vault_secret.password.value
#   disable_password_authentication = false
  
#   network_interface_ids = [
#     azurerm_network_interface.nic.id,
    
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
# }



#   # ============================
#   # 1. Local Provisioner
#   # ============================
#   provisioner "local-exec" {
#     command = "echo VM ${self.name} creation started >> vm_status.log"
#   }

#   # ============================
#   # 2. Remote Provisioner
#   # ============================
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update -y",
#       "sudo apt-get install -y nginx",
#       "sudo systemctl enable nginx",
#       "sudo systemctl start nginx"
#     ]

#     connection {
#       type        = "ssh"
#       host        = self.public_ip_address
#       user        = data.azurerm_key_vault_secret.username.value
#       password    = data.azurerm_key_vault_secret.password.value
#     }
#   }

#   # ============================
#   # 3. Local Provisioner After Success
#   # ============================
#   provisioner "local-exec" {
#     when    = destroy
#     command = "echo VM ${self.name} destroyed successfully >> vm_status.log"
#   }


resource "azurerm_network_security_rule" "ssh" {
  name                        = "allow-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.nsg_name
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = data.azurerm_key_vault_secret.username.value
  admin_password      = data.azurerm_key_vault_secret.password.value
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # ============================
  # 1. Local Provisioner
  # ============================
  provisioner "local-exec" {
    command = "echo VM ${self.name} creation started >> vm_status.log"
  }

  # ============================
  # 2. Remote Provisioner
  # ============================
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type     = "ssh"
      host     = self.public_ip_address
      user     = data.azurerm_key_vault_secret.username.value
      password = data.azurerm_key_vault_secret.password.value
    }
  }

  # ============================
  # 3. Local Provisioner After Destroy
  # ============================
  provisioner "local-exec" {
    when    = destroy
    command = "echo VM ${self.name} destroyed successfully >> vm_status.log"
  }
}

