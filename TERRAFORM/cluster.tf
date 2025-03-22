resource "digitalocean_kubernetes_cluster" "cluster" {
  name   = "meu-cluster"
  region = "lon1"
  version = "1.32.2-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    node_count = 2
  }
  
  maintenance_policy {
    start_time = "04:00"
    day = "monday"
  }
}