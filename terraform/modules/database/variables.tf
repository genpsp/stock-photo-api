variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "database_version" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "tier" {
  type = string
}

variable "backup_enabled" {
  type = bool
}

variable "backup_days" {
  type = number
}

variable "logical_decoding" {
  type = string
}

variable "max_connections" {
  type = number
}