resource "random_string" "suffix" {
  length = 10
  special = false
  upper = false
}

resource "random_password" "db_pass" {
  length = 10
  special = false
}


locals {
  wp_config = {
    db_name = var.db_name
    db_user = var.db_user
    db_pass = random_password.db_pass.result
  }
}
