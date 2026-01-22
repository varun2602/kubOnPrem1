locals {
ec2_kubernetes_config_worker_node = {
    "ami" = var.ec2_worker_nodes_ami, 
    "instance_type" = var.ec2_worker_node_instance_type
  }
  ec2_kubernetes_config_master_node = {
    "ami" = var.ec2_master_node_ami 
    "instance_type" = var.ec2_master_node_instance_type
  }
  ec2_kubernetes_nodes = {
    "worker_node_1" = local.ec2_kubernetes_config_worker_node,
    "worker_node_2" = local.ec2_kubernetes_config_worker_node,
    "worker_node_3" = local.ec2_kubernetes_config_worker_node,
    "master_node" = local.ec2_kubernetes_config_master_node,
  }
}