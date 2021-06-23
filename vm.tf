# Create virtual network
resource "azurerm_virtual_network" "net1" {
    name                = "Linuxnet"
    address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

# Create subnet
resource "azurerm_subnet" "subnet1" {
    name                 = "linuxsubnet"
  resource_group_name = azurerm_resource_group.rg1.name
    virtual_network_name = azurerm_virtual_network.net1.name
    address_prefixes       = ["10.1.2.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "publicip1" {
    name                         = "LinuxPublicIP"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
    allocation_method            = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg1" {
    name                = "LinuxNSGroup"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create network interface
resource "azurerm_network_interface" "nic1" {
    name                      = "LinuxNIC"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

    ip_configuration {
        name                          = "LinuxNicConfig"
        subnet_id                     = azurerm_subnet.subnet1.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicip1.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.nic1.id
    network_security_group_id = azurerm_network_security_group.nsg1.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
  resource_group_name = azurerm_resource_group.rg1.name
    }

    byte_length = 8
}

# Create (and display) an SSH key
resource "tls_private_key" "vmlu01_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" {
    value = tls_private_key.vmlu01_ssh.private_key_pem
    sensitive = true
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vml1" {
    name                  = "VMLU01"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
    network_interface_ids = [azurerm_network_interface.nic1.id]
    size                  = "Standard_B1ls"

    os_disk {
        name              = "LinuxOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "VMLU01"
    admin_username = "azureuser"
    disable_password_authentication = false 
    admin_password = "Pass0011admin"

 #   admin_ssh_key {
 #       username       = "azureuser"
 #       public_key     = file("~/.ssh/id_rsa.pub")
 #   }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.linuxstorageaccount.primary_blob_endpoint
    }
}
