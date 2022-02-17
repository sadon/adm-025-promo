resource "aws_instance" "web-worker" {
  instance_type = "t2.nano"
  ami = "ami-043097594a7df80ec"
  key_name = aws_key_pair.tf-training.0.key_name
  user_data = templatefile("${path.module}/web-server-wp.sh.tpl",
          merge(local.wp_config, {db_host = aws_instance.mysql-server.private_ip})
  )

  tags = {
    Name: "adm-025 VM WEB SERVER"
    exercise: "wordpress"
    role: "web-worker"
  }
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.web-server.id
  ]
}

resource "aws_instance" "mysql-server" {
  instance_type = "t2.nano"
  ami = "ami-043097594a7df80ec"
  key_name = aws_key_pair.tf-training.1.key_name
  user_data = templatefile("${path.module}/mysql-cloud-init.sh.tpl", local.wp_config)
  tags = {
    Name: "adm-025 VM DB"
    exercise: "wordpress"
    role: "db"
  }
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.mysql-server.id
  ]
}

