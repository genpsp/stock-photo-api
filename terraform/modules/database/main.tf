resource "google_sql_database_instance" "stock_photo_database" {
  provider         = google
  database_version = var.database_version
  name             = var.instance_name
  region           = var.region

  settings {
    activation_policy     = "ALWAYS"
    availability_type     = "REGIONAL"
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
      name  = "cloudsql.logical_decoding"
      value = var.logical_decoding
    }

    database_flags {
      name  = "max_connections"
      value = var.max_connections
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
      point_in_time_recovery_enabled = true
      start_time                     = "00:00"
      transaction_log_retention_days = var.backup_days
    }
  }
}

resource "random_password" "default_user_password" {
  length  = 64
  special = false
}

resource "google_sql_user" "default_user" {
  name     = "postgres"
  password = random_password.default_user_password.result
  instance = google_sql_database_instance.stock_photo_database.id
}

output "default_user_password" {
  value = random_password.default_user_password.result
}
