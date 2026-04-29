variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" { default = "us-ashburn-1" } # Ou a região que você escolheu no cadastro

variable "compartment_id" {
  description = "OCID do compartimento onde os recursos serão criados"
}

variable "db_password" {
  description = "Senha do administrador do banco de dados"
  sensitive   = true
}