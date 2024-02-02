module "backend_lb_http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "10.1.0"

  project = var.project_id
  name    = "backend-lb"

  create_address                  = false
  address                         = google_compute_global_address.backend_lb_ip.address
  managed_ssl_certificate_domains = [replace(var.stock_photo_api_url, "https://", "")]
  ssl                             = true
  https_redirect                  = true

  create_url_map = false
  url_map        = google_compute_url_map.default.id

  backends = {
    default = {
      groups = [
        {
          group = google_compute_region_network_endpoint_group.backend_neg.id
        }
      ]

      enable_cdn = false

      health_check = {
        request_path = "/healthz"
        port         = 3000
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }

      description            = "backend load balancer"
      custom_request_headers = null
      security_policy        = google_compute_security_policy.policy.name
      compression_mode       = null
      port_name              = null
      protocol               = null
    }
  }
}

resource "google_compute_global_address" "backend_lb_ip" {
  name = "backend-lb-ip"
}

resource "google_compute_region_network_endpoint_group" "backend_neg" {
  name                  = "backend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "asia-northeast1"

  cloud_run {
    service = var.stock_photo_api_name
  }
}

resource "google_compute_url_map" "default" {
  name            = "backend-lb-url-map"
  default_service = module.backend_lb_http.backend_services.default.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher"
  }

  path_matcher {
    name            = "path-matcher"
    default_service = module.backend_lb_http.backend_services.default.id

    path_rule {
      paths   = ["/console/*"]
      service = module.backend_lb_http.backend_services.console.id
    }

    path_rule {
      paths   = ["/api/*"]
      service = module.backend_lb_http.backend_services.api.id
    }
  }
}

resource "google_compute_security_policy" "policy" {
  name = "backend-lb-policy"

  rule {
    action   = "deny(502)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default all deny rule"
  }

  rule {
    action   = "allow"
    priority = "100"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.allow_access_ips
      }
    }
    description = "allow access from buysell internal"
  }
}

resource "google_iap_web_backend_service_iam_binding" "console_iap_iam_binding" {
  web_backend_service = module.backend_lb_http.backend_services.console.name
  role                = "roles/iap.httpsResourceAccessor"
  members = [
    "domain:buysell-technologies.com",
  ]
}

data "google_secret_manager_secret_version" "oauth_client_secret" {
  provider = google-beta
  project  = var.project_id
  secret   = "iap-oauth2-client-secret"
}
