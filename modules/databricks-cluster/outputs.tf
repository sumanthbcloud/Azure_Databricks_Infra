output "cluster_id" {
  description = "The ID of the Databricks cluster."
  value       = databricks_cluster.this.id
}

output "cluster_name" {
  description = "The name of the Databricks cluster."
  value       = databricks_cluster.this.cluster_name
}

output "cluster_url" {
  description = "The URL of the Databricks cluster."
  value       = databricks_cluster.this.url
}
