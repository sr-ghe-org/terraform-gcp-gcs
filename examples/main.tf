module "non-pci-gcs" {
  source             = "../terraform-gcp-gcs"
  bucket_name_prefix = "gcs-non-pci-321"
  project_id         = "pr-hvpc-1056d88565a4"
  regions            = ["northamerica-northeast1", "northamerica-northeast2"]
  environment        = "prod"
  versioning         = true
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  bucket_type = "non-pci"
  internal_encryption_config = {
    create_encryption_key = true
    prevent_destroy       = false
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
}

module "non-pci-gcs_cmek" {
  source             = "../terraform-gcp-gcs"
  bucket_name_prefix = "gcs-non-pci-321-cmek"
  project_id         = "pr-hvpc-1056d88565a4"
  project_number     = "828184145025"
  regions            = ["northamerica-northeast1", "northamerica-northeast2"]
  environment        = "non-prod"
  versioning         = true
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  bucket_type = "non-pci"
  kms_key_names = {
    "northamerica-northeast1" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
    "northamerica-northeast2" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast2/keyRings/pci-ring-tor/cryptoKeys/pci-key-tor"
  }
}

module "pci-gcs" {
  source             = "../terraform-gcp-gcs"
  bucket_name_prefix = "gcs-pci-321"
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

module "pci-gcs-cmek" {
  source             = "../terraform-gcp-gcs"
  bucket_name_prefix = "gcs-pci-321-cmek"
  project_id         = "pr-hvpc-1056d88565a4"
  project_number     = "828184145025"
  regions            = ["northamerica-northeast1", "northamerica-northeast2"]
  environment        = "prod"
  versioning         = true
  soft_delete_policy = {
    retention_duration_seconds = 900000
  }
  bucket_type = "pci"
  kms_key_names = {
    "northamerica-northeast1" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
    "northamerica-northeast2" = "projects/pr-hvpc-1056d88565a4/locations/northamerica-northeast2/keyRings/pci-ring-tor/cryptoKeys/pci-key-tor"
  }
}


module "pci-gcs-test-depends_on" {
  source             = "../terraform-gcp-gcs"
  bucket_name_prefix = "gcs-pci-321567"
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

