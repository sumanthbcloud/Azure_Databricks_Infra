terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "this" {
  cluster_name            = var.cluster_name
  spark_version           = coalesce(var.spark_version, data.databricks_spark_version.latest_lts.id)
  node_type_id            = var.node_type_id
  runtime_engine          = "PHOTON"
  data_security_mode      = "USER_ISOLATION"
  num_workers             = 0
  autotermination_minutes = var.autotermination_minutes

  spark_conf = {
    "spark.databricks.cluster.profile" = "singleNode"
    "spark.master"                     = "local[*]"
  }

  custom_tags = merge(
    var.tags,
    {
      ResourceClass = "SingleNode"
    }
  )
}
