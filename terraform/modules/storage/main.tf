resource "google_storage_bucket" "images" {
  name     = "stock-photo-images"
  location = var.region
}

resource "google_storage_bucket" "erd" {
  name     = "stock-photo-erd"
  location = var.region

  website {
    main_page_suffix = "index.html"
  }
}

resource "google_storage_bucket_iam_binding" "images_public" {
  bucket = google_storage_bucket.images.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket_iam_binding" "erd_public" {
  bucket = google_storage_bucket.erd.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

output "images_bucket_name" {
  value = google_storage_bucket.images.name
}

output "erd_bucket_name" {
  value = google_storage_bucket.erd.name
}
