# Busca os domínios de disponibilidade (ADs) da sua conta
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Busca a imagem oficial do Oracle Linux Cloud Developer (Já vem com Docker e CLI)
data "oci_core_images" "cloud_developer_image" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
}

resource "oci_core_instance" "app_server" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  display_name        = "vm-prod-server"
  shape               = "VM.Standard.A1.Flex"

  # Configuração dentro do Always Free: 2 OCPUs e 12GB de RAM
  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    assign_public_ip = true
    display_name     = "vnic-primary"
    hostname_label   = "appserver"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.cloud_developer_image.images[0].id
  }

  metadata = {
    # Aqui passamos um script de inicialização (Cloud-init)
    user_data = base64encode(<<-EOF
      #!/bin/bash
      yum install -y docker-ce docker-compose-plugin
      systemctl enable --now docker
      usermod -aG docker opc
    EOF
    )
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }

  # Evita recriar a VM se a imagem mudar na Oracle
  lifecycle {
    ignore_changes = [source_details]
  }
}

output "public_ip" {
  value = oci_core_instance.app_server.public_ip
}