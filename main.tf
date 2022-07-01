# Configure the Alicloud Provider
provider "alicloud" {
  # access_key="LTAI5tA9X6iQSYae9HtWKWsb"
  # secret_key="g2Z2AxdSgRVty0pWKvidXCM869CsRK"
  # region    = "cn-shanghai"
}

# variable "vpc_cidr_block" {
#   description = "vpc_cidr_block"
#   default = "172.16.0.0/16"
#   type = string
# }


variable "cidr_block" {
  description = "cidr block for vpc and subnet"
  type = list(object({
    cidr_block = string
    name = string
  }))
}


# Create vpc
variable "env" {
  description = "deploy env"
}

resource "alicloud_vpc" "dev-vpc" {
  vpc_name   = var.cidr_block[0].name
  cidr_block = var.cidr_block[0].cidr_block
  tags = {
      Name: var.env
  }
}

variable "zone_id" {}

# Create Vswitch
resource "alicloud_vswitch" "dev-vsw-1" {
  vpc_id     = alicloud_vpc.dev-vpc.id
  cidr_block = var.cidr_block[1].cidr_block
  zone_id    = var.zone_id
  vswitch_name = var.cidr_block[1].name
  tags = {
      Name: var.cidr_block[1].name
  }
}

# data "alicloud_vpcs" "existing_vpcs" {
#   cidr_block = "172.16.0.0/16"
#   status     = "Available"
#   name_regex = "^dev"
# }

# Get first_vpc_id 
# output "first_vpc_id" {
#    value = "${data.alicloud_vpcs.existing_vpcs.vpcs.0.id}"
# }

# output "dev_vpc_id" {
#   value = "${alicloud_vpc.dev-vpc.id}"
# }

# output "subnet-1-id" {
#   value = "${alicloud_vswitch.dev-vsw-1.id}"
# }

# variable "subnet_cidr_block" {
#   description = "subnet cidr block"
  
# }

# # Create Vswitch2  use data source create vsw-2
# resource "alicloud_vswitch" "dev-vsw-2" {
#   vpc_id     = data.alicloud_vpcs.existing_vpcs.vpcs.0.id
#   cidr_block = var.subnet_cidr_block
#   zone_id    = "cn-shanghai-f"
#   vswitch_name = "subnet-dev-2"
#   tags = {
#      Name: "subnet-dev-2"
#   }
# }

