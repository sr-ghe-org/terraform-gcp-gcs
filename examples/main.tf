# -------------------------------------------------------------------------------------------------------
# Example 1 : Non-PCI GCS Bucket with internal encryption (CMEK handled by module) and lifecycle rules
# -------------------------------------------------------------------------------------------------------

module "non-pci-gcs-lifecycle" {
  source             = "../terraform-gcp-gcs-gitvcs"
  bucket_name_prefix = "gcs-non-pci-lifecycle"
  project_id         = "pr-hvpc-1056d88565a4"
  regions            = ["northamerica-northeast1", "northamerica-northeast2"]
  storage_class      = "NEARLINE"
  project_number     = "828184145025"
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  labels = {
    "env" = "prod"
  }
  bucket_type = "non-pci"
  kms_key_names = {
    "northamerica-northeast1" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
    "northamerica-northeast2" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast2/keyRings/pci-ring-tor/cryptoKeys/pci-key-tor"
  }
  iam_members = [
    {
      role   = "roles/storage.objectUser"
      member = "serviceAccount:b-32-988@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    },
    {
      role   = "roles/storage.objectCreator"
      member = "serviceAccount:a-833-223@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    }
  ]
  retention_policy = {
    is_locked        = false
    retention_period = 220752000
  }
  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age              = 365 * 7
        send_age_if_zero = true
        with_state       = "LIVE"
      }
    }
  ]
}

# ---------------------------------------------------------------------------------
# Example 2 : Non-PCI GCS Bucket with encryption key passed by the customer
# ---------------------------------------------------------------------------------

module "non-pci-gcs-cmek" {
  source             = "../terraform-gcp-gcs"
  bucket_name_prefix = "gcs-non-pci-321-cmek"
  project_id         = "pr-hvpc-1056d88565a4"
  project_number     = "828184145025"
  regions            = ["northamerica-northeast1", "northamerica-northeast2"]
  versioning         = true
  bucket_type        = "non-pci"
  kms_key_names = {
    "northamerica-northeast1" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
    "northamerica-northeast2" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast2/keyRings/pci-ring-tor/cryptoKeys/pci-key-tor"
  }
  iam_members = [
    {
      role   = "roles/storage.objectUser"
      member = "serviceAccount:b-32-988@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    }
  ]
}

# ---------------------------------------------------------------------------------------
# Example 3 : PCI GCS Bucket with internal encryption (CMEK handled by module)
# ---------------------------------------------------------------------------------------

module "pci-gcs" {
  source             = "../terraform-gcp-gcs"
  bucket_name_prefix = "gcs-pci-321"
  project_id         = "pr-hvpc-1056d88565a4"
  regions            = ["northamerica-northeast1", "northamerica-northeast2"]
  bucket_type        = "pci"
  internal_encryption_config = {
    create_encryption_key = true
    prevent_destroy       = false
  }
  iam_members = [
    {
      role   = "roles/storage.objectUser"
      member = "serviceAccount:b-32-988@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    }
  ]
}

# ---------------------------------------------------------------------------------
# Example 4 : PCI GCS Bucket with encryption key passed by the customer
# ---------------------------------------------------------------------------------

module "pci-gcs-cmek" {
  source             = "../terraform-gcp-gcs"
  bucket_name_prefix = "gcs-pci-321-cmek"
  project_id         = "pr-hvpc-1056d88565a4"
  project_number     = "828184145025"
  regions            = ["northamerica-northeast1", "northamerica-northeast2"]
  versioning         = true
  bucket_type        = "pci"
  kms_key_names = {
    "northamerica-northeast1" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
    "northamerica-northeast2" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast2/keyRings/pci-ring-tor/cryptoKeys/pci-key-tor"
  }
  iam_members = [
    {
      role   = "roles/storage.objectUser"
      member = "serviceAccount:b-32-988@pr-hvpc-1056d88565a4.iam.gserviceaccount.com"
    }
  ]
}