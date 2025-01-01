# General Configuration Variables
variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_cp_naming_prefix" {
  description = "Prefix used for naming all resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_default_tags" {
  description = "Enable default tags for EC2 instances and related resources"
  type        = bool
  default     = true
}

variable "custom_ami_id" {
  description = "Custom AMI ID to use instead of the latest ECS-optimized AMI"
  type        = string
  default     = null
}

variable "instance_types" {
  description = "List of instance types to use in the mixed instances policy"
  type        = list(string)
  default     = ["t3.micro", "t3.small"]
}

# Capacity Provider Configuration
variable "use_spot_instances" {
  description = "Whether to use spot instances instead of on-demand"
  type        = bool
  default     = false
}

variable "spot_allocation_strategy" {
  description = "Spot instance allocation strategy: lowest-price, capacity-optimized, price-capacity-optimized"
  type        = string
  default     = "price-capacity-optimized"
  validation {
    condition     = contains(["lowest-price", "capacity-optimized", "price-capacity-optimized"], var.spot_allocation_strategy)
    error_message = "Spot allocation strategy must be one of: lowest-price, capacity-optimized, price-capacity-optimized"
  }
}

# Auto Scaling Group Configuration
variable "vpc_subnets" {
  description = "List of VPC subnet IDs for the Auto Scaling Group"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "protect_from_scale_in" {
  description = "Prevents Auto Scaling from terminating instances on scale-in"
  type        = bool
  default     = false
}

# Scaling Configuration
variable "max_scaling_step_size" {
  description = "Maximum number of instances to scale out at once"
  type        = number
  default     = 10
}

variable "min_scaling_step_size" {
  description = "Minimum number of instances to scale out at once"
  type        = number
  default     = 1
}

variable "target_capacity" {
  description = "Target capacity percentage for the ECS cluster"
  type        = number
  default     = 80
}

# Launch Template Configuration
variable "security_group_ids" {
  description = "List of security group IDs for EC2 instances"
  type        = list(string)
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile for ECS instances"
  type        = string
}

# Monitoring Configuration
variable "enable_monitoring" {
  description = "Enable detailed monitoring for instances and ASG metrics"
  type        = bool
  default     = true
}

# Volume Configuration
variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "Type of the root volume (gp3, gp2, io1, io2)"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.root_volume_type)
    error_message = "Root volume type must be one of: gp2, gp3, io1, io2"
  }
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "root_volume_deletion_on_termination" {
  description = "Whether to delete root volume on instance termination"
  type        = bool
  default     = true
}

variable "cp_managed_termination_protection" {
  description = "Whether to enable managed termination protection for the ECS Capacity Provider"
  type        = string
  default     = "ENABLED"
}

variable "managed_scaling_enabled" {
  description = "Whether to enable managed scaling for the ECS Capacity Provider"
  type        = string
  default     = "ENABLED"
}

variable "instance_key" {
  description = "Name of the key pair to use for SSH access"
  type        = string
  default     = ""
}

variable "launch_template_id" {
  description = "ID of the Launch Template"
  type        = string
  default     = null
}

variable "launch_template_version" {
  description = "Version of the Launch Template"
  type        = number
  default     = null
}

variable "asg_health_check_type" {
  description = "Type of health check for the Auto Scaling Group"
  type        = string
  default     = "EC2" # EC2 or ELB
}

variable "asg_health_check_grace_period" {
  description = "Time in seconds after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "ecs_instance_warmup_period" {
  description = "Time in seconds after instance comes into service before checking health"
  type        = number
  default     = 300
}
