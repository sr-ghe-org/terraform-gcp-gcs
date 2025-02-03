output "gcs_bucket_names" {
  description = "List of created GCS bucket names."
  value       = [for bucket in module.gcs_pci_buckets : bucket.name]
}

output "gcs_bucket_urls" {
  description = "List of created GCS bucket URLs."
  value       = [for bucket in module.gcs_pci_buckets : "gs://${bucket.name}"]
}

output "regions" {
  description = "List of regions where the GCS buckets are created."
  value       = var.regions
}