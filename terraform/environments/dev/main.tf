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
  source     = "../../modules/service_account"
  env        = var.env
  project_id = var.project_id
}

module "database" {
  source           = "../../modules/database"
  project_id       = var.project_id
  region           = var.region
  instance_name    = "stock-photo-database"
  database_version = "MYSQL_8_0"
  tier             = "db-f1-micro"
  availability_type = "ZONAL"
  backup_enabled   = true
  backup_days      = 2
  max_connections  = 25
  deletion_protection = false
}

module "storage" {
  source                      = "../../modules/storage"
  env                         = var.env
  project_id                  = var.project_id
  region                      = var.region
  github_service_account_name = module.service_account.github_service_account_name
}

module "repository" {
  source     = "../../modules/repository"
  project_id = var.project_id
  region     = var.region
}

module "workload_identity" {
  source                      = "../../modules/workload_identity"
  env                         = var.env
  project_id                  = var.project_id
  github_repository           = "https://github.com/genpsp/stock-photo-web"
  github_service_account_name = module.service_account.github_service_account_name

  depends_on = [module.service_account]
}

module "secret" {
  source                = "../../modules/secret"
  default_user_password = module.database.default_user_password
}
