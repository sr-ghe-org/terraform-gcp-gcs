output "gcs_bucket_names" {
  description = "List of created GCS bucket names."
  value       = var.bucket_type == "non-pci" ? module.non_pci_gcs_buckets[0].gcs_bucket_names : (var.bucket_type == "pci" ? module.pci_gcs_buckets[0].gcs_bucket_names : [])
}

output "gcs_bucket_urls" {
  description = "List of created GCS bucket URLs."
  value       = var.bucket_type == "non-pci" ? module.non_pci_gcs_buckets[0].gcs_bucket_urls : (var.bucket_type == "pci" ? module.pci_gcs_buckets[0].gcs_bucket_urls : [])
}

output "regions" {
  description = "List of regions where the GCS buckets are created."
  value       = var.bucket_type == "non-pci" ? module.non_pci_gcs_buckets[0].regions : (var.bucket_type == "pci" ? module.pci_gcs_buckets[0].regions : [])
}