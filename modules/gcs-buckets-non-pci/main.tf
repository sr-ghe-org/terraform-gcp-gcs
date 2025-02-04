

# Module to create GCS buckets in multiple regions within the same project

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  for_each      = { for k, v in var.kms_key_names : k => v if length(var.kms_key_names) > 0 }
  crypto_key_id = each.value
  members       = ["serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"]
  role          = "roles/cloudkms.cryptoKeyDecrypter"
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  for_each      = { for k, v in var.kms_key_names : k => v if length(var.kms_key_names) > 0 }
  crypto_key_id = each.value
  members       = ["serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"]
  role          = "roles/cloudkms.cryptoKeyEncrypter"
}

module "gcs_non_pci_buckets" {
  for_each                 = toset(var.regions)
  source                   = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version                  = "9.0"
  project_id               = var.project_id
  name                     = "${var.bucket_name_prefix}-non-pci-${each.key}" # Bucket names are globally unique
  location                 = each.value
  bucket_policy_only       = true           # uniform_bucket_level_access is set to true
  versioning               = var.versioning # By default set to true
  labels                   = merge(var.labels, { bucket_type = "non-pci", region = each.key })
  storage_class            = var.storage_class # By default storage Class of the new bucket set to "STANDARD"
  autoclass                = var.autoclass     # By default, autoclass is set to false
  lifecycle_rules          = var.lifecycle_rules
  retention_policy         = var.retention_policy
  force_destroy            = var.force_destroy
  public_access_prevention = "enforced"             # Prevent public access is "enforced" by default
  soft_delete_policy       = var.soft_delete_policy # Set to O (By default : 604800(7 days))
  encryption = {
    default_kms_key_name = length(var.kms_key_names) > 0 ? var.kms_key_names[each.key] : null
  }
  internal_encryption_config = var.internal_encryption_config
  iam_members                = var.iam_members
  depends_on                 = [google_kms_crypto_key_iam_binding.decrypters, google_kms_crypto_key_iam_binding.encrypters]
}

# resource "google_storage_bucket_iam_binding" "bucket_iam_prod" {
#   for_each = {
#     for region in var.regions :
#     "${var.bucket_name_prefix}-non-pci-${region}" => region
#     if var.environment == "prod"
#   }
#   bucket     = each.key
#   role       = "roles/storage.objectViewer"
#   members    = [] # Replace with a dummy user in your organization
#   depends_on = [module.gcs_non_pci_buckets]
# }

# Enable audit logging for the project
resource "google_project_iam_audit_config" "project_audit_config" {
  project = var.project_id
  service = "storage.googleapis.com"

  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
}


































