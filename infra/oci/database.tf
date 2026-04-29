# Definição do Banco de Dados Autônomo (Always Free)
resource "oci_database_autonomous_database" "main_db" {
  compartment_id           = var.compartment_id
  db_name                  = "clouddb" # Apenas letras e números
  display_name             = "CloudSolutionsDB"
  db_workload              = "OLTP" # Processamento de transações
  db_version               = "19c"

  # Configurações Always Free
  is_free_tier             = true
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1

  # Autenticação (Defina uma senha forte no seu .tfvars)
  admin_password           = var.db_password

  # Acesso via rede (Usando a subnet que criamos no vcn.tf)
  is_mtls_connection_required = false
  whitelisted_ips             = ["0.0.0.0/0"] # Em prod, restringiríamos ao IP da App
}

# Output para você saber como conectar depois
output "db_connection_url" {
  value = oci_database_autonomous_database.main_db.connection_urls[0]
}