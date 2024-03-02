resource "google_storage_bucket" "images" {
  name     = "stock-photo-images"
  location = var.region
}

resource "google_storage_bucket" "erd" {
  name     = "stock-photo-erd"
  location = var.region
}

resource "google_storage_bucket_iam_binding" "images_public" {
  bucket = google_storage_bucket.images.name
  role   = "roles/storage.legacyObjectReader"
  members = [
    "allUsers",
  ]
}

output "images_bucket_name" {
  value = google_storage_bucket.images.name
}
