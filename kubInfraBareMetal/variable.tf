variable "ec2_worker_nodes_ami" {
  type = string
  # default = "ami-068c0051b15cdb816"
}

variable "ec2_master_node_ami" {
  type = string
  # default = "ami-068c0051b15cdb816"
}

variable "ec2_module_for_kubernetes_module_name" {
  type = string
  default = "dummy_value"
}

variable "ec2_worker_node_instance_type" {
  type = string
  default = "t3.micro"
}

variable "ec2_master_node_instance_type" {
  type = string
  default = "t3.micro"
}