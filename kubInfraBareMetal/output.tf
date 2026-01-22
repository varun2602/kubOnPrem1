output "aws_default_vpc_subnets" {
  value = data.aws_subnets.default_vpc_subnets.ids
}

output "ec2_public_ip" {
  value = {
    for key, instance in module.ec2-instance:
       key => instance.public_ip
  }
}

# output "default_vpc_properties" {
#   value = aws_default_vpc.my_default_vpc
# }