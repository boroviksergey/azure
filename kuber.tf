# Create a resource group vor Kubernetes
 resource "azurerm_resource_group" "rg"  {
 name     = "kuber_rg"
  location = "westus"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "kubercluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "kuberclusterdns"

  default_node_pool {
    name       = "default"
    node_count = "2"
    vm_size    = "standard_b2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

