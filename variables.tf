variable "project_id" {
  description = "stackit Project ID"
}

variable "cluster_name" {
  description = "Specifies the cluster name (lower case, alphanumeric, hyphens allowed, up to 11 chars)"
  type        = string
  default     = "k8s"

  validation {
    condition     = can(regex("^[a-z0-9-]{1,11}$", var.cluster_name))
    error_message = "The cluster name must be lower case, alphanumeric, allow hyphens, and be up to 11 characters long."
  }
}

variable "k8s_version" {
  description = "K8s Version"
  default     = "1.26"
  validation {
    condition     = can(regex("^(1.24|1.25|1.26)$", var.k8s_version))
    error_message = "Invalid version, valid versions are: \"1.24\", \"1.25\", \"1.26\"."
  }
}

variable "argus_instance_id" {
  description = "Argus Instance ID for Monitoring of K8s Cluster"
  default     = ""
}

variable "extensions" {
  description = "Extensions configuration"
  type = object({
    acl = object({
      allowed_cidrs = list(string)
      enabled       = bool
    })
    argus = object({
      enabled           = bool
      argus_instance_id = optional(string)
    })
  })
  default = {
    acl = {
      allowed_cidrs = []
      enabled       = false
    },
    argus = {
      enabled = false
    }
  }
}

variable "node_pools" {
  description = "Configuration for node_pools"
  type = list(object({
    machine_type      = string
    name              = string
    container_runtime = optional(string)
    labels            = optional(map(string))
    max_surge         = optional(number)
    max_unavailable   = optional(number)
    maximum           = optional(number)
    minimum           = optional(number)
    os_name           = optional(string)
    os_version        = optional(string)
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })))
    volume_size_gb = optional(number)
    volume_type    = optional(string)
    zones          = optional(list(string))
  }))
}


variable "hibernations" {
  description = "Hibernation configuration"
  type = list(object({
    start    = string
    end      = string
    timezone = string
  }))
  default = [{
    start    = ""
    end      = ""
    timezone = "Europe/Berlin"
  }]
}

variable "maintenance" {
  description = "Maintenance window configuration"
  type = object({
    enable_kubernetes_version_updates    = bool
    enable_machine_image_version_updates = bool
    start                                = string
    end                                  = string
  })
  default = {
    enable_kubernetes_version_updates    = true
    enable_machine_image_version_updates = true
    start                                = "0000-01-01T03:00:00Z"
    end                                  = "0000-01-01T05:00:00Z"
  }
}

variable "grafana" {
  description = "Argus grafana configuration"
  type = object({
    enable_public_access = bool
  })
  default = {
    enable_public_access = false
  }
}

variable "metrics" {
  description = "Argus metric configuration"
  type = object({
    retention_days                 = number
    retention_days_1h_downsampling = number
    retention_days_5m_downsampling = number
  })
  default = {
    retention_days = 30
    # "To avoid anomalies metricsRetentionTime5m should be bigger than metricsRetentionTime1h"
    retention_days_1h_downsampling = 3
    retention_days_5m_downsampling = 10
  }
}

variable "argus_plan" {
  description = "Name of the Argus plan to use"
  default     = "Monitoring-Starter-EU01"
}

variable "argus_instance" {
  description = "Argus instance configuration"
  type = object({
    parameters = optional(map(string))
  })
  default = {
    parameters = {}
  }
}

## Extensions
variable "acl_enabled" {
  description = "Enable / Disable ACL"
  default     = false
  validation {
    condition     = can(regex("^(true|false)$", var.acl_enabled))
    error_message = "Invalid value, valid values are: \"true\", \"false\"."
  }
}

variable "acl_allowed_cidrs" {
  description = "List of CIDRs to allow access to the cluster"
  type        = list(string)
  default     = []
}

## Hibernations
#variable "hibernations" {
#  description = "List of Hibernation configurations to auto start/stop the cluster. Crontab syntax"
#  type = list(object({
#    start    = string
#    end      = string
#    timezone = string
#  }))
#}
#
## Maintenance
variable "enable_kubernetes_version_updates" {
  description = "Enable automatic Kubernetes version updates"
  default     = true
}

variable "enable_machine_image_version_updates" {
  description = "Enable automatic OS image version updates"
  default     = true
}

variable "maintenance_start" {
  description = "Start of the maintenance window"
  default     = "02:00:00+02:00"
}

variable "maintenance_stop" {
  description = "End of the maintenance window"
  default     = "05:00:00+02:00"
}

variable "create_local_kubeconfig" {
  description = "Create local kubeconfig file"
  default     = true
}

variable "cluster_timeouts" {
  description = "Timeouts for cluster operations"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}
