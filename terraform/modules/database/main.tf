resource "google_sql_database_instance" "stock_photo_database" {
  database_version    = var.database_version
  name                = var.instance_name
  region              = var.region
  root_password       = random_password.default_user_password.result
  deletion_protection = var.deletion_protection

  settings {
    activation_policy     = "ALWAYS"
    availability_type     = var.availability_type
    pricing_plan          = "PER_USE"
    tier                  = var.tier
    disk_autoresize       = true
    disk_autoresize_limit = 20
    disk_size             = 10
    disk_type             = "PD_SSD"

    ip_configuration {
      ipv4_enabled = true
    }

    database_flags {
      name  = "default_authentication_plugin"
      value = "mysql_native_password"
    }

    database_flags {
      name  = "max_connections"
      value = var.max_connections
    }

    database_flags {
      name  = "wait_timeout"
      value = 60
    }

    location_preference {
      zone = "asia-northeast1-a"
    }

    insights_config {
      query_insights_enabled = true
    }

    backup_configuration {
      backup_retention_settings {
        retained_backups = var.backup_days
        retention_unit   = "COUNT"
      }
      enabled                        = var.backup_enabled
      location                       = "asia"
      start_time                     = "00:00"
      binary_log_enabled             = true
      transaction_log_retention_days = var.backup_days
    }
  }
}

resource "google_sql_database" "default_database" {
  name     = "default"
  instance = google_sql_database_instance.stock_photo_database.name
}

resource "random_password" "default_user_password" {
  length  = 64
  special = false
}

resource "google_sql_user" "default_user" {
  name     = "default"
  password = random_password.default_user_password.result
  instance = google_sql_database_instance.stock_photo_database.id
}

output "default_database_name" {
  value = google_sql_database.default_database.name
}
output "default_user_password" {
  value = random_password.default_user_password.result
}
output "default_user_name" {
  value = google_sql_user.default_user.name
}
output "stock_photo_database_connection_name" {
  value = google_sql_database_instance.stock_photo_database.connection_name
}
