# Governança e Segurança Cloud

## Padrões de Redes
- **Segregação:** Subnets públicas para Load Balancers e subnets privadas para Bancos de Dados.
- **Firewall:** Implementação de Security Lists (OCI) e NSGs (Azure) seguindo o princípio de menor privilégio.

## Gestão de Segredos
- Uso de `variables.tf` com flag `sensitive = true`.
- Arquivos `.tfvars`, `.terraform/`, `terraform.tfstate`, `.terraform.lock.hcl` e chaves `.pem` devidamente incluídos no `.gitignore`.

## DBA
- Banco de Dados Autônomo com backups automáticos ativados.
- Acesso ao banco restrito ao CIDR interno da VCN.