output "argus_alerting_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.alerting_url : null
}

output "argus_dashboard_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.dashboard_url : null
}

output "argus_grafana_initial_admin_user" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.grafana_initial_admin_user : null
}

output "argus_grafana_initial_admin_password" {
  # sensitive = true
  value = var.extensions.argus.enabled ? nonsensitive(stackit_argus_instance.default.0.grafana_initial_admin_password) : null
}

output "argus_grafana_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.grafana_url : null
}

output "argus_instance_id" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.id : null
}

output "argus_jaeger_traces_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.jaeger_traces_url : null
}

output "argus_jaeger_ui_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.jaeger_ui_url : null
}

output "argus_logs_push_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.logs_push_url : null
}

output "argus_logs_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.logs_url : null
}

output "argus_metrics_push_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.metrics_push_url : null
}

output "argus_metrics_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.metrics_url : null
}

output "argus_otlp_traces_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.otlp_traces_url : null
}

output "argus_targets_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.targets_url : null
}

output "argus_zipkin_spans_url" {
  value = var.extensions.argus.enabled ? stackit_argus_instance.default.0.zipkin_spans_url : null
}

output "cluster_id" {
  value = stackit_kubernetes_cluster.default.id
}

output "cluster_version" {
  value = stackit_kubernetes_cluster.default.kubernetes_version
}

output "kube_config" {
  sensitive = true
  value     = stackit_kubernetes_cluster.default.kube_config
}

#output "project_id" {
#  value = stackit_kubernetes_project.default.project_id
#}
