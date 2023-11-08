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

resource "aws_subnet" "subnet1_public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet1_cidr}"
    availability_zone = "us-east-1a"
        tags = {
          Name = "${var.public_subnet1_name}"
        }
}

resource "aws_subnet" "subnet2_public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet2_cidr}"
    availability_zone = "us-east-1b"
        tags = {
          Name = "${var.public_subnet2_name}"
        }
}

resource "aws_subnet" "subnet3_public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet3_cidr}"
    availability_zone = "us-east-1c"
        tags = {
          Name = "${var.public_subnet3_name}"
        }
}

resource "aws_security_group" "allow_tls" {
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
    Name = "allow_tls"
  }
}

terraform{
	backend "s3"{
		encrypt = true
		dynamodb_table = "terraform-state-lock-dynamo"
		bucket = "terraformtfstatebackup"
		region = "us-east-1"
		key = "test.tfstate"
	}
}

