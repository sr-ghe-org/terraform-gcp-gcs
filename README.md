
# Google Cloud Storage (GCS)

This Terraform module creates Google Cloud Storage (GCS) buckets, categorized as PCI compliant and Non-PCI compliant, leveraging the [`terraform-google-modules/cloud-storage/google`](https://github.com/terraform-google-modules/terraform-google-cloud-storage/tree/main/modules/simple_bucket) module.

## Table of Contents

- [Overview][1]
- [Example Input][2]
- [Requirements][3]
- [Inputs][4]
- [Outputs][5]
- [Modules][6]
- [Resources][7]

## Overview

This module simplifies the creation and management of GCS buckets, distinguishing between PCI and Non-PCI compliant buckets.  It utilizes submodules for managing each type of bucket, allowing for specific configurations.  It aims to promote security best practices, including CMEK encryption, data retention policies, and restricted access in production (though the access restriction logic needs to be implemented in the submodules).


## Example Input

```terraform
  #
  #  REQUIRED VARIABLES
  #
  # TODO: update "bucket_name_prefix" value
  bucket_name_prefix  = null
  # TODO: update "bucket_type" value
  bucket_type  = null
  # TODO: update "environment" value
  environment  = null
  # TODO: update "project_id" value
  project_id  = null
  #
  #  OPTIONAL VARIABLES
  #
  autoclass  = false
  force_destroy  = false
  internal_encryption_config  = {}
  kms_key_names  = {}
  labels  = null
  lifecycle_rules  = []
  project_number  = null
  regions  = [
  "northamerica-northeast1",
  "northamerica-northeast2"
]
  retention_policy  = null
  soft_delete_policy  = {}
  storage_class  = null
  versioning  = true
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.43.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoclass"></a> [autoclass](#input\_autoclass) | While set to true, autoclass is enabled for this bucket. | `bool` | `false` | no |
| <a name="input_bucket_name_prefix"></a> [bucket\_name\_prefix](#input\_bucket\_name\_prefix) | Prefix for the GCS bucket names | `string` | n/a | yes |
| <a name="input_bucket_type"></a> [bucket\_type](#input\_bucket\_type) | PCI bucket or Non-PCI bucket | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for the GCS bucket | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects. | `bool` | `false` | no |
| <a name="input_internal_encryption_config"></a> [internal\_encryption\_config](#input\_internal\_encryption\_config) | Configuration for the creation of an internal Google Cloud Key Management Service (KMS) Key for use as Customer-managed encryption key (CMEK) for the GCS Bucket<br>  instead of creating one in advance and providing the key in the variable `encryption.default_kms_key_name`.<br>  create\_encryption\_key: If `true` a Google Cloud Key Management Service (KMS) KeyRing and a Key will be created<br>  prevent\_destroy: Set the prevent\_destroy lifecycle attribute on keys.<br>  key\_destroy\_scheduled\_duration: Set the period of time that versions of keys spend in the `DESTROY_SCHEDULED` state before transitioning to `DESTROYED`.<br>  key\_rotation\_period: Generate a new key every time this period passes. | <pre>object({<br>    create_encryption_key          = optional(bool, false)<br>    prevent_destroy                = optional(bool, false)<br>    key_destroy_scheduled_duration = optional(string, null)<br>    key_rotation_period            = optional(string, "7776000s")<br>  })</pre> | `{}` | no |
| <a name="input_kms_key_names"></a> [kms\_key\_names](#input\_kms\_key\_names) | Map of region names to CMEK key names. The CMEK keys must already exist in the corresponding regions. | `map(string)` | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of key/value label pairs to assign to the bucket. | `map(string)` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | The bucket's Lifecycle Rules configuration. | <pre>list(object({<br>    # Object with keys:<br>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br>    action = any<br><br>    # Object with keys:<br>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br>    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br>    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.<br>    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition<br>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br>    condition = any<br>  }))</pre> | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where GCS bucket will be created | `string` | n/a | yes |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | The GCP project number where GCS Service account exists | `string` | `null` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions for Non-PCI buckets | `list(string)` | <pre>[<br>  "northamerica-northeast1",<br>  "northamerica-northeast2"<br>]</pre> | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. | <pre>object({<br>    is_locked        = bool<br>    retention_period = number<br>  })</pre> | `null` | no |
| <a name="input_soft_delete_policy"></a> [soft\_delete\_policy](#input\_soft\_delete\_policy) | Soft delete policies to apply. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#nested_soft_delete_policy | <pre>object({<br>    retention_duration_seconds = optional(number)<br>  })</pre> | `{}` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | The Storage Class of the new bucket. | `string` | `null` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | While set to true, versioning is fully enabled for this bucket. | `bool` | `true` | no |

## Outputs

No outputs.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_non_pci_gcs_buckets"></a> [non\_pci\_gcs\_buckets](#module\_non\_pci\_gcs\_buckets) | ./modules/gcs-buckets-non-pci | n/a |
| <a name="module_pci_gcs_buckets"></a> [pci\_gcs\_buckets](#module\_pci\_gcs\_buckets) | ./modules/gcs-buckets-pci | n/a |

## Resources

No resources.

[1]: #overview
[2]: #example-input
[3]: #requirements
[4]: #inputs
[5]: #outputs
[6]: #modules
[7]: #resources
