resource "oci_mysql_mysql_db_system" "laravel_mysql" {
  compartment_id = var.compartment_ocid
  shape_name     = "MySQL.VM.Standard.E3.1.8GB"
  subnet_id      = oci_core_subnet.oke_k8s_endpoint_subnet.id

  admin_username = var.mysql_admin_username
  admin_password = var.mysql_admin_password

  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  data_storage_size_in_gb = 50

  display_name = "laravel-mysql-db"
  description  = "MySQL Database for Laravel Application"

  hostname_label = "laravel-mysql"

  is_highly_available = false

  configuration_id = data.oci_mysql_mysql_configurations.mysql_config.configurations[0].id

  freeform_tags = {
    "Environment" = "Production"
    "Application" = "Laravel"
  }
}

data "oci_mysql_mysql_configurations" "mysql_config" {
  compartment_id = var.compartment_ocid
  shape_name     = "MySQL.VM.Standard.E3.1.8GB"
}

output "mysql_db_endpoint" {
  value = oci_mysql_mysql_db_system.laravel_mysql.endpoints[0].ip_address
  description = "MySQL Database endpoint IP address"
}
