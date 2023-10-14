# Terraform STACKIT Kubernetes

Terraform module to create a K8s (SKE) Cluster with monitoring (Argus) for STACKIT cloud platform.

## Consulting

You need support with STACKIT infrastructure? We are an [official professional service partner of STACKIT](https://www.stackit.de/de/partner/partnersteckbrief-ventx/) !

Please don't hesitate to contact us at: [stackit@ventx.de](mailto:stackit@ventx.de)

---

Sie benötigen Unterstützung bei Ihrer STACKIT Infrastruktur? Wir sind [offizieller Professional Service Partner von STACKIT](https://www.stackit.de/de/partner/partnersteckbrief-ventx/) !

Kontaktieren Sie uns via: [stackit@ventx.de](mailto:stackit@ventx.de)

## Overview
This Terraform project provisions a Kubernetes cluster on STACKIT, including optional Argus monitoring and ACL controls.

## Prerequisites

* [Terraform v1.x.x](https://www.terraform.io)
* [STACKIT Account](https://www.stackit.de)

## Getting Started

Clone the repository:
`git clone https://github.com/ventx/terraform-stackit-k8s`

Navigate into the directory:
`cd terraform-stackit-k8s`

Set your Stackit Service Account Token as EnvVars:


```bash
 export STACKIT_SERVICE_ACCOUNT_EMAIL=xxx
 export STACKIT_SERVICE_ACCOUNT_TOKEN=xxx
```

Create `terraform.tfvars` to configure Node Pools (required) and other configs (optional):

```hcl
# REQUIRED: ID of your STACKIT project
project_id = "12345678-1234-1234-1234-1234567890ab"

# REQUIRED: Configure Node Pool(s)
node_pools = [
  {
    name         = "np-example"
    machine_type = "c1.2"
    minimum = "2"
    maximum = "3"
    zones   = ["eu01-1", "eu01-2", "eu01-3"]
  }
]

# Enables cluster monitoring with STACKIT Argus and configure ACL to whitelist CIDRs for cluster access
extensions = {
  acl = {
    enabled       = false
    allowed_cidrs = []
  },
  argus = {
    enabled = true
  }
}

# Automatically shutdown cluster at 18:00 and start at 08:00 to save on costs
hibernations = [{
  start    = "0 8 * * *"
  end      = "0 18 * * *"
  timezone = "Europe/Berlin"
}]
```

Initialize Terraform:
`terraform init`

Create Terraform plan and verify the configuration:
`terraform plan`

Apply the Terraform configuration:
`terraform apply`

## Maintenance & Monitoring
Scheduled maintenance (auto-update of K8s and/or machine images) is controlled by the `var.maintenance` variable block.

Optionally enable Argus monitoring via `var.monitoring` variable block.

## Hibernation
Auto start/stop timings for the cluster can be set through the `var.hibernations` variable to save on costs.

## Important Notes

### Terraform Providers
There are two STACKIT Terraform providers:

* Community: [SchwarzIT/stackit](https://registry.terraform.io/providers/SchwarzIT/stackit/latest)
* Official: [stackitcloud/stackit](https://registry.terraform.io/providers/stackitcloud/stackit/latest)

The official provider is still buggy, so we are using the **Community** provider for now.

## Contributing

Pull requests are very welcome. If you encounter any problems, please open an issue ❤️.

## License

MIT

## terraform-docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_stackit"></a> [stackit](#requirement\_stackit) | ~> 1.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_stackit"></a> [stackit](#provider\_stackit) | ~> 1.27 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [stackit_argus_instance.default](https://registry.terraform.io/providers/SchwarzIT/stackit/latest/docs/resources/argus_instance) | resource |
| [stackit_kubernetes_cluster.default](https://registry.terraform.io/providers/SchwarzIT/stackit/latest/docs/resources/kubernetes_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl_allowed_cidrs"></a> [acl\_allowed\_cidrs](#input\_acl\_allowed\_cidrs) | List of CIDRs to allow access to the cluster | `list(string)` | `[]` | no |
| <a name="input_acl_enabled"></a> [acl\_enabled](#input\_acl\_enabled) | Enable / Disable ACL | `bool` | `false` | no |
| <a name="input_argus_instance"></a> [argus\_instance](#input\_argus\_instance) | Argus instance configuration | <pre>object({<br>    parameters = optional(map(string))<br>  })</pre> | <pre>{<br>  "parameters": {}<br>}</pre> | no |
| <a name="input_argus_instance_id"></a> [argus\_instance\_id](#input\_argus\_instance\_id) | Argus Instance ID for Monitoring of K8s Cluster | `string` | `""` | no |
| <a name="input_argus_plan"></a> [argus\_plan](#input\_argus\_plan) | Name of the Argus plan to use | `string` | `"Monitoring-Starter-EU01"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the cluster name (lower case, alphanumeric, hyphens allowed, up to 11 chars) | `string` | `"k8s"` | no |
| <a name="input_cluster_timeouts"></a> [cluster\_timeouts](#input\_cluster\_timeouts) | Timeouts for cluster operations | <pre>object({<br>    create = optional(string)<br>    update = optional(string)<br>    delete = optional(string)<br>  })</pre> | <pre>{<br>  "create": "60m",<br>  "delete": "60m",<br>  "update": "60m"<br>}</pre> | no |
| <a name="input_create_local_kubeconfig"></a> [create\_local\_kubeconfig](#input\_create\_local\_kubeconfig) | Create local kubeconfig file | `bool` | `true` | no |
| <a name="input_enable_kubernetes_version_updates"></a> [enable\_kubernetes\_version\_updates](#input\_enable\_kubernetes\_version\_updates) | Enable automatic Kubernetes version updates | `bool` | `true` | no |
| <a name="input_enable_machine_image_version_updates"></a> [enable\_machine\_image\_version\_updates](#input\_enable\_machine\_image\_version\_updates) | Enable automatic OS image version updates | `bool` | `true` | no |
| <a name="input_extensions"></a> [extensions](#input\_extensions) | Extensions configuration | <pre>object({<br>    acl = object({<br>      allowed_cidrs = list(string)<br>      enabled       = bool<br>    })<br>    argus = object({<br>      enabled           = bool<br>      argus_instance_id = optional(string)<br>    })<br>  })</pre> | <pre>{<br>  "acl": {<br>    "allowed_cidrs": [],<br>    "enabled": false<br>  },<br>  "argus": {<br>    "enabled": false<br>  }<br>}</pre> | no |
| <a name="input_grafana"></a> [grafana](#input\_grafana) | Argus grafana configuration | <pre>object({<br>    enable_public_access = bool<br>  })</pre> | <pre>{<br>  "enable_public_access": false<br>}</pre> | no |
| <a name="input_hibernations"></a> [hibernations](#input\_hibernations) | Hibernation configuration | <pre>list(object({<br>    start    = string<br>    end      = string<br>    timezone = string<br>  }))</pre> | <pre>[<br>  {<br>    "end": "",<br>    "start": "",<br>    "timezone": "Europe/Berlin"<br>  }<br>]</pre> | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | K8s Version | `string` | `"1.26"` | no |
| <a name="input_maintenance"></a> [maintenance](#input\_maintenance) | Maintenance window configuration | <pre>object({<br>    enable_kubernetes_version_updates    = bool<br>    enable_machine_image_version_updates = bool<br>    start                                = string<br>    end                                  = string<br>  })</pre> | <pre>{<br>  "enable_kubernetes_version_updates": true,<br>  "enable_machine_image_version_updates": true,<br>  "end": "0000-01-01T05:00:00Z",<br>  "start": "0000-01-01T03:00:00Z"<br>}</pre> | no |
| <a name="input_maintenance_start"></a> [maintenance\_start](#input\_maintenance\_start) | Start of the maintenance window | `string` | `"02:00:00+02:00"` | no |
| <a name="input_maintenance_stop"></a> [maintenance\_stop](#input\_maintenance\_stop) | End of the maintenance window | `string` | `"05:00:00+02:00"` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Argus metric configuration | <pre>object({<br>    retention_days                 = number<br>    retention_days_1h_downsampling = number<br>    retention_days_5m_downsampling = number<br>  })</pre> | <pre>{<br>  "retention_days": 30,<br>  "retention_days_1h_downsampling": 3,<br>  "retention_days_5m_downsampling": 10<br>}</pre> | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Configuration for node\_pools | <pre>list(object({<br>    machine_type      = string<br>    name              = string<br>    container_runtime = optional(string)<br>    labels            = optional(map(string))<br>    max_surge         = optional(number)<br>    max_unavailable   = optional(number)<br>    maximum           = optional(number)<br>    minimum           = optional(number)<br>    os_name           = optional(string)<br>    os_version        = optional(string)<br>    taints = optional(list(object({<br>      key    = string<br>      value  = string<br>      effect = string<br>    })))<br>    volume_size_gb = optional(number)<br>    volume_type    = optional(string)<br>    zones          = optional(list(string))<br>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | stackit Project ID | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argus_alerting_url"></a> [argus\_alerting\_url](#output\_argus\_alerting\_url) | n/a |
| <a name="output_argus_dashboard_url"></a> [argus\_dashboard\_url](#output\_argus\_dashboard\_url) | n/a |
| <a name="output_argus_grafana_initial_admin_password"></a> [argus\_grafana\_initial\_admin\_password](#output\_argus\_grafana\_initial\_admin\_password) | n/a |
| <a name="output_argus_grafana_initial_admin_user"></a> [argus\_grafana\_initial\_admin\_user](#output\_argus\_grafana\_initial\_admin\_user) | n/a |
| <a name="output_argus_grafana_url"></a> [argus\_grafana\_url](#output\_argus\_grafana\_url) | n/a |
| <a name="output_argus_instance_id"></a> [argus\_instance\_id](#output\_argus\_instance\_id) | n/a |
| <a name="output_argus_jaeger_traces_url"></a> [argus\_jaeger\_traces\_url](#output\_argus\_jaeger\_traces\_url) | n/a |
| <a name="output_argus_jaeger_ui_url"></a> [argus\_jaeger\_ui\_url](#output\_argus\_jaeger\_ui\_url) | n/a |
| <a name="output_argus_logs_push_url"></a> [argus\_logs\_push\_url](#output\_argus\_logs\_push\_url) | n/a |
| <a name="output_argus_logs_url"></a> [argus\_logs\_url](#output\_argus\_logs\_url) | n/a |
| <a name="output_argus_metrics_push_url"></a> [argus\_metrics\_push\_url](#output\_argus\_metrics\_push\_url) | n/a |
| <a name="output_argus_metrics_url"></a> [argus\_metrics\_url](#output\_argus\_metrics\_url) | n/a |
| <a name="output_argus_otlp_traces_url"></a> [argus\_otlp\_traces\_url](#output\_argus\_otlp\_traces\_url) | n/a |
| <a name="output_argus_targets_url"></a> [argus\_targets\_url](#output\_argus\_targets\_url) | n/a |
| <a name="output_argus_zipkin_spans_url"></a> [argus\_zipkin\_spans\_url](#output\_argus\_zipkin\_spans\_url) | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
