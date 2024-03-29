resource "google_cloud_run_service" "stock_photo_api" {
  name                       = var.instance_name
  location                   = var.region
  autogenerate_revision_name = true

  metadata {
    annotations = {
      # "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    spec {
      service_account_name = var.cloudrun_sa_email

      containers {
        image = var.image_url

        ports {
          container_port = 8000
        }

        resources {
          limits = {
            "cpu" : var.cpu
            "memory" : var.memory
          }
        }

        env {
          name  = "ENV"
          value = var.env
        }
        env {
          name = "DB_HOST"
          value_from {
            secret_key_ref {
              name = "DB_HOST"
              key  = "latest"
            }
          }
        }
        env {
          name = "DB_NAME"
          value_from {
            secret_key_ref {
              name = "DB_NAME"
              key  = "latest"
            }
          }
        }
        env {
          name = "DB_USER"
          value_from {
            secret_key_ref {
              name = "DB_USER"
              key  = "latest"
            }
          }
        }
        env {
          name = "DB_PASSWORD"
          value_from {
            secret_key_ref {
              name = "DB_PASSWORD"
              key  = "latest"
            }
          }
        }
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = var.stock_photo_database_connection_name
      }
      labels = {
        "run.googleapis.com/startupProbeType" = "Default"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
      template[0].metadata[0].labels["client.knative.dev/nonce"]
    ]
  }
}

resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloud_run_service.stock_photo_api.location
  service  = google_cloud_run_service.stock_photo_api.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

output "stock_photo_api_name" {
  value = google_cloud_run_service.stock_photo_api.name
}
output "stock_photo_api_url" {
  value = google_cloud_run_service.stock_photo_api.status[0].url
}
