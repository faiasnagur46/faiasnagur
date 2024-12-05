
provider "aws" {
  region = var.aws_region
}

# Security Group for Ansible instances
resource "aws_security_group" "ansible_sg" {
  name        = "ansible-security-group"
  description = "Allow SSH access to Ansible instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks  # Ensure this is securely defined
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-security-group"
  }
}

# Key Pair
resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible-key"
  public_key = file(var.ssh_public_key)  # Make sure this matches the path in terraform.tfvars
}


# Ansible Master Instance
resource "aws_instance" "ansible_master" {
  ami           = var.ami_id
  instance_type = var.master_instance_type
  key_name      = aws_key_pair.ansible_key.key_name

  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags = {
    Name = "Ansible-Master"
  }
}

# Ansible Slave Instances
resource "aws_instance" "ansible_slave" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.slave_instance_type
  key_name      = aws_key_pair.ansible_key.key_name

  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags = {
    Name = "Ansible-Slave-${count.index + 1}"
  }
}
