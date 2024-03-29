terraform {
  required_version = ">= 1.7"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.12"
    }
  }
  backend "gcs" {
    bucket = "stock-photo-dev-terraform"
    prefix = "tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "service_account" {
  source          = "../../modules/service_account"
  env             = var.env
  project_id      = var.project_id
  erd_bucket_name = module.storage.erd_bucket_name
}

module "database" {
  source              = "../../modules/database"
  project_id          = var.project_id
  region              = var.region
  instance_name       = "stock-photo-database"
  database_version    = "MYSQL_8_0"
  tier                = "db-f1-micro"
  availability_type   = "ZONAL"
  backup_enabled      = true
  backup_days         = 2
  max_connections     = 25
  deletion_protection = false
}

module "cloudrun" {
  source                               = "../../modules/cloudrun"
  env                                  = var.env
  project_id                           = var.project_id
  region                               = var.region
  instance_name                        = "stock-photo-api"
  image_url                            = "asia-northeast1-docker.pkg.dev/${var.project_id}/${module.repository.stock_photo_api_repository_name}/stock-photo-api-image"
  cloudrun_sa_email                    = module.service_account.cloudrun_sa_email
  stock_photo_database_connection_name = module.database.stock_photo_database_connection_name
  cpu                                  = "1000m"
  memory                               = "514Mi"
}

module "load_barancer" {
  source               = "../../modules/load_barancer"
  project_id           = var.project_id
  region               = var.region
  stock_photo_api_url  = module.cloudrun.stock_photo_api_url
  stock_photo_api_name = module.cloudrun.stock_photo_api_name
  allow_access_ips     = ["*"]
}

module "dns" {
  source        = "../../modules/dns"
  project_id    = var.project_id
  region        = var.region
  dns_name      = "stock-photo-api-qgnvqghcya-an.a.run.app."
  ttl           = 600
  backend_lb_ip = module.load_barancer.backend_lb_ip
}

module "storage" {
  source     = "../../modules/storage"
  env        = var.env
  project_id = var.project_id
  region     = var.region
}

module "repository" {
  source     = "../../modules/repository"
  project_id = var.project_id
  region     = var.region
}

module "workload_identity" {
  source                = "../../modules/workload_identity"
  env                   = var.env
  project_id            = var.project_id
  github_api_repository = var.github_api_repository
  github_sa_name        = module.service_account.github_sa_name
  depends_on            = [module.service_account]
}

module "secret" {
  source                = "../../modules/secret"
  db_host               = module.database.stock_photo_database_connection_name
  db_name               = module.database.default_database_name
  db_user               = module.database.default_user_name
  default_user_password = module.database.default_user_password
}
