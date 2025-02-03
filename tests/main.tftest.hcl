
mock_provider "google" {}

# -----------------------------------------------------
# CMEK : Encryption key passed by the customer
# -----------------------------------------------------
run "gcs_with_cmek" {
  command = plan
  variables {
    bucket_name_prefix = "gcs-pci-321-cmek"
    project_id         = "pr-svpc"
    project_number     = "00000000000"
    regions            = ["northamerica-northeast1", "northamerica-northeast2"]
    environment        = "prod"
    versioning         = true
    soft_delete_policy = {
      retention_duration_seconds = 900000
    }
    bucket_type = "pci"
    kms_key_names = {
      "northamerica-northeast1" = "projects/pr-svpc/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
      "northamerica-northeast2" = "projects/pr-svpc/locations/northamerica-northeast2/keyRings/pci-ring-tor/cryptoKeys/pci-key-tor"
    }
  }
}


# --------------------------------------------------------------
# CMEK : Internal Encryption key passed by the created by module
# --------------------------------------------------------------
run "gcs_with_internal_encryption" {
  command = plan
  variables {
    bucket_name_prefix = "gcs-pci-321-cmek"
    project_id         = "pr-hvpc-1056d88565a4"
    regions            = ["northamerica-northeast1", "northamerica-northeast2"]
    environment        = "prod"
    versioning         = true
    soft_delete_policy = {
      retention_duration_seconds = 900000
    }
    bucket_type = "pci"
    internal_encryption_config = {
      create_encryption_key = true
      prevent_destroy       = false
    }
  }
}

