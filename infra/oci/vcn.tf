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