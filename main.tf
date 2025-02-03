
module "non_pci_gcs_buckets" {
  count              = var.bucket_type == "non-pci" ? 1 : 0
  source             = "./modules/gcs-buckets-non-pci"
  project_id         = var.project_id
  project_number     = var.project_number
  bucket_name_prefix = var.bucket_name_prefix
  regions            = var.regions
  versioning         = var.versioning
  labels             = var.labels
  storage_class      = var.storage_class
  autoclass          = var.autoclass
  environment        = var.environment
  retention_policy = {
    is_locked        = false // ??
    retention_period = 365 * 7
  }
  lifecycle_rules = [
    {
      action    = { type = "Delete" }
      condition = { age = 365 * 7 }
    }
  ]
  force_destroy            = var.force_destroy
  public_access_prevention = "enforced"
  # soft_delete_policy = {
  #   retention_duration_seconds = 0
  # }
  soft_delete_policy         = var.soft_delete_policy
  kms_key_names              = var.kms_key_names
  internal_encryption_config = var.internal_encryption_config
}


module "pci_gcs_buckets" {
  count              = var.bucket_type == "pci" ? 1 : 0
  source             = "./modules/gcs-buckets-pci"
  project_id         = var.project_id
  project_number     = var.project_number
  bucket_name_prefix = var.bucket_name_prefix
  regions            = var.regions
  versioning         = var.versioning
  labels             = var.labels
  storage_class      = var.storage_class
  autoclass          = var.autoclass
  environment        = var.environment
  retention_policy = {
    is_locked        = false // ??
    retention_period = 365 * 7
  }
  lifecycle_rules = [
    {
      action    = { type = "Delete" }
      condition = { age = 365 * 7 }
    }
  ]
  force_destroy            = var.force_destroy
  public_access_prevention = "enforced"
  # soft_delete_policy = {
  #   retention_duration_seconds = 0
  # }
  soft_delete_policy         = var.soft_delete_policy
  kms_key_names              = var.kms_key_names
  internal_encryption_config = var.internal_encryption_config
}
