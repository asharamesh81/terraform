variable "aws_region" {}
variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-0fc5d935ebf8bc3bc" # ubuntu 22.04 LTS
		    us-east-2 = "ami-0e83be366243f524a" # ubuntu 22.04 LTS
		    us-west-1 = "ami-0cbd40f694b804622" # ubuntu 22.04 LTS
		    us-west-2 = "ami-0efcece6bed30fd98" # ubuntu 22.04 LTS
    }
}
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "IGW_name" {}
variable "key_name" {}
#variable "dynamodb_lock_name" {}
variable "sola-chatboat-public_route_table" {}
variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "blocks" {
  description = "Run the cidr blocks fot the subnets"
  type = list
  default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}
variable "environment" { }
variable "instance_type" {
  default = {
    dev = "t2.nano"
    test = "t2.micro"
    prod = "t2.medium"
    }
}


