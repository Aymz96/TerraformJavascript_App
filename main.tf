provider "aws" {
  region = "eu-west-1"
}

# Create a VPC
# Resources are the references that exist inside AWS

# resource "aws_vpc" "app_vpc" {
#   cidr_block  = "10.0.0.0/16"
#   tags = {
#       name    = "Aymz_eng54_app_vpc"
#   }
# }

# Use the DevOps VPC ID
# Create a new subnet
# Move our instance into the new subnet
resource "aws_subnet" "app_subnet" {
    vpc_id                      = var.vpc_id
    cidr_block                  = "172.31.88.0/24"
    availability_zone           = "eu-west-1a"
    tags = {
      Name                      = "${var.name}-subnet"
    }
}

# Create a new route table
resource "aws_route_table" "public" {
    vpc_id                      = var.vpc_id
    route {
      cidr_block                = "0.0.0.0/0"
      gateway_id                = data.aws_internet_gateway.default-gw.id
    }
      tags = {
        Name = "${var.name}-public-route_table"
      }
}
# creating the route table association
resource "aws_route_table_association" "assoc" {
    subnet_id                   = aws_subnet.app_subnet.id
    route_table_id              = aws_route_table.public.id

}

# Attaching the IG to vpc
data "aws_internet_gateway" "default-gw" {
  filter {
    # vpc-id (from the hasicorp docs, it references AWS-API that has this filter attachments)
    name                        = "attachment.vpc-id"
    values                      = [var.vpc_id]
  }
}

# We dont need a new INTERNET GATEWAY
# We can query our exsisting vpc/infrastructure with the 'data' handler function

# Creating a security group, linking it with VPC and attaching it to our instance
resource "aws_security_group" "app_security" {
  name        = "Aymz_security_Group_App"
  description = "Security Group port 80 traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "inbound rules"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound rules"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound rules"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["77.100.100.125/32"]
  }

  ingress {
    description = "inbound rules"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Default outbound rules for SG is it lets everything out automaticly
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "${var.name}-security_group"
  }
}

# Launching an Instance
resource "aws_instance" "app_instance" {
    ami                         = var.ami_id
    instance_type               = "t2.micro"
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.app_subnet.id
    vpc_security_group_ids      = [aws_security_group.app_security.id]
    tags = {
        Name                    = var.name
    }
    key_name                    = "Aymz_vpc"
    
    user_data = data.template_file.app_init.rendered

    connection {
      user = "ubuntu"
      type = "ssh"
      host = self.public_ip
      private_key = "${file("~/.ssh/Aymz_vpc.pem")}"
    }

  #   provisioner "remote-exec" {
  #     inline = [
  #      "cd /home/ubuntu/app",
  #      "sudo npm start &",
  #      # (&) Sends processes to the background
  #      # "PID=$!",
  #      # "sleep 2s",
  #      # "kill -INT $PID"
  #    ]
    data "template_file" "app_init" {
      template = "${file("./templates/script.sh.tpl")}"
    }
  # }
}
