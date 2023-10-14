locals {
  processed_extensions = {
    acl = {
      allowed_cidrs = var.extensions.acl.allowed_cidrs
      enabled       = var.extensions.acl.enabled
    },
    argus = {
      enabled           = var.extensions.argus.enabled
      argus_instance_id = (var.extensions.argus.argus_instance_id == null) || (var.extensions.argus.argus_instance_id == "") ? stackit_argus_instance.default.0.id : var.extensions.argus.argus_instance_id
    }
  }

  processed_grafana = {
    enable_public_access = var.grafana.enable_public_access
  }

  processed_maintenance = {
    enable_kubernetes_version_updates    = var.maintenance.enable_kubernetes_version_updates
    enable_machine_image_version_updates = var.maintenance.enable_machine_image_version_updates
    start                                = var.maintenance.start
    end                                  = var.maintenance.end
  }

  processed_metrics = {
    retention_days                 = var.metrics.retention_days
    retention_days_1h_downsampling = var.metrics.retention_days_1h_downsampling
    retention_days_5m_downsampling = var.metrics.retention_days_5m_downsampling
  }

  timeouts = var.cluster_timeouts
}

#resource "stackit_kubernetes_project" "default" {
#  project_id = var.project_id
#}

# Assuming `extensions`, `maintenance`, and `node_pools` are supported attributes, corrected them below.
resource "stackit_kubernetes_cluster" "default" {
  project_id = var.project_id
  #project_id = stackit_kubernetes_project.default.project_id
  name = var.cluster_name

  kubernetes_version = var.k8s_version
  extensions         = local.processed_extensions
  hibernations       = var.hibernations
  maintenance        = local.processed_maintenance
  node_pools         = var.node_pools

}

resource "stackit_argus_instance" "default" {
  count = var.extensions.argus.enabled ? 1 : 0

  project_id = var.project_id
  name       = lower(var.cluster_name)
  plan       = var.argus_plan

  metrics = local.processed_metrics
  grafana = local.processed_grafana
}


resource "local_sensitive_file" "kubeconfig" {
  count = var.create_local_kubeconfig ? 1 : 0

  content  = stackit_kubernetes_cluster.default.kube_config
  filename = "${path.module}/kubeconfig"
}

