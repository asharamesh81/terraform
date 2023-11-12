provider "aws" {
    #access_key = "${var.aws_access_key}"
    #secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
    profile = "default"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
        tags = {
            Name = "${var.vpc_name}"
        }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
    tags = {
      Name = "${var.IGW_name}"
    }
}

resource "aws_subnet" "subnets_public" {
    vpc_id = "${aws_vpc.default.id}"
    count = 3
    cidr_block = "${element(var.blocks, count.index)}"
    availability_zone = "${element(var.azs, count.index)}"
        tags = {
          Name = "sola-chatboat-subnet-${count.index+1}"
        }
}

resource "aws_route_table" "sola-chat_public" {
  vpc_id = "${aws_vpc.default.id}"
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "${var.sola-chatboat-public_route_table}"
  }
}

resource "aws_route_table_association" "sola-chat_public" {
  count = "${length(var.blocks)}" #count = 3
  subnet_id = "${element(aws_subnet.subnets_public.*.id, count.index) }"
  route_table_id = "${aws_route_table.sola-chat_public.id}"
  
}

resource "aws_security_group" "allow_all" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.default.cidr_block]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}


terraform{
	backend "s3"{
		encrypt = true
		#dynamodb_table = "terraform-state-lock-dynamo"
		bucket = "terraformtfstatebackup"
		region = "us-east-1"
		key = "aws.tfstate"
	}
}

