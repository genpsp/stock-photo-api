resource "google_secret_manager_secret" "db_name" {
  secret_id = "DB_NAME"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "db_user" {
  secret_id = "DB_USER"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "DB_PASSWORD"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_name_version" {
  secret      = google_secret_manager_secret.db_name.id
  secret_data = var.db_name
}
resource "google_secret_manager_secret_version" "db_user_version" {
  secret      = google_secret_manager_secret.db_user.id
  secret_data = var.db_user
}
resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.default_user_password
}
