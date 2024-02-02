resource "google_cloud_run_service" "stock_photo_api" {
  name     = var.instance_name
  location = var.region
  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
    }
  }

  template {
    spec {
      service_account_name = var.cloudrun_service_account_email

      containers {
        image = var.image_url

        volume_mounts {
          name       = "credentials"
          mount_path = "/app/credentials"
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
          name = "DB_DSN"
          value_from {
            secret_key_ref {
              name = ""
              key  = "latest"
            }
          }
        }
      }

      # volumes {
      #   name = "credentials"
      #   secret {
      #     secret_name = data.google_secret_manager_secret.gcp_credentials.secret_id
      #   }
      # }
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
      metadata[0].annotations,
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
