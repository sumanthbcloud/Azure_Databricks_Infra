variable "cluster_name" {
  description = "The name of the Databricks cluster."
  type        = string
}

variable "node_type_id" {
  description = "Azure Databricks node type used for the single-node cluster."
  type        = string
}

variable "autotermination_minutes" {
  description = "Automatically terminate the cluster after this number of minutes of inactivity."
  type        = number
  default     = 30
}

variable "spark_version" {
  description = "Optional custom Databricks runtime Spark version (e.g. '15.4.x-scala2.12'). If null, the latest LTS version is automatically detected."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to attach to the cluster."
  type        = map(string)
  default     = {}
}
