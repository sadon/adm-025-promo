
resource "aws_security_group" "ssh" {
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-server" {
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "current" {
  default = true
}

resource "aws_security_group" "mysql-server" {
  ingress {
    description = "Ingress for web-server"
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    cidr_blocks = [data.aws_vpc.current.cidr_block]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "tls_private_key" "tf-training" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf-training" {
  count = 2
  key_name   = "tf-training-key-wp-${random_string.suffix.result}-${count.index}"
  public_key = tls_private_key.tf-training.public_key_openssh
}
