# 1. Criar a VCN (Virtual Cloud Network)
resource "oci_core_vcn" "main_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "vcn-cloud-solutions"
  dns_label      = "cloudsol"
}

# 2. Criar o Internet Gateway (Para acesso externo)
resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  display_name   = "internet-gateway"
  vcn_id         = oci_core_vcn.main_vcn.id
}

# 3. Tabela de Roteamento (Direcionar tráfego para a Internet)
resource "oci_core_default_route_table" "default_route" {
  manage_default_resource_id = oci_core_vcn.main_vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

# 4. Subnet Pública (Onde os Load Balancers ou instâncias ficarão)
resource "oci_core_subnet" "public_subnet" {
  cidr_block     = "10.0.1.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "public-subnet"
  dns_label      = "public"
}

# 5. Definir a Lista de Segurança (Firewall)
resource "oci_core_security_list" "app_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "sl-cloud-solutions"

  # Regra de Saída (Egress): Permitir tudo para a Internet
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Regra de Entrada (Ingress): Permitir SSH (Porta 22) para sua gestão
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0" # Em produção, coloque seu IP real aqui
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Regra de Entrada: Porta do serviço Java (8080)
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 8080
      max = 8080
    }
  }

  # Regra de Entrada: Porta do banco SQL (1522 - Porta padrão do Autonomous)
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16" # Apenas tráfego INTERNO da VCN acessa o banco
    tcp_options {
      min = 1522
      max = 1522
    }
  }
}

# 6. Vincular a Security List à sua Subnet existente
# Nota: Você precisará atualizar o recurso oci_core_subnet no vcn.tf