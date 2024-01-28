resource "google_storage_bucket" "images" {
  name                     = "stock-photo-${var.env}-images"
  location                 = var.region
  public_access_prevention = "enforced"
}

output "images_bucket_name" {
  value = google_storage_bucket.images.name
}
