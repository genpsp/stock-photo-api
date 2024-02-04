resource "google_dns_managed_zone" "main" {
  name     = "main-zone"
  dns_name = var.dns_name
}

resource "google_dns_record_set" "backend" {
  name = "backend.${google_dns_managed_zone.main.dns_name}"
  type = "A"
  ttl  = var.ttl

  managed_zone = google_dns_managed_zone.main.name

  rrdatas = [var.backend_lb_ip]
}
