locals {
  ami_id = var.custom_ami_id != null ? var.custom_ami_id : data.aws_ami.ecs_optimized[0].id

  # Comprehensive metrics list
  enabled_metrics = var.enable_monitoring ? [
    "GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity",
    "GroupInServiceInstances", "GroupPendingInstances",
    "GroupStandbyInstances", "GroupTerminatingInstances",
    "GroupTotalInstances", "GroupInServiceCapacity",
    "GroupPendingCapacity", "GroupStandbyCapacity",
    "GroupTerminatingCapacity", "GroupTotalCapacity"
  ] : []

  cp_type = var.use_spot_instances ? "spot" : "od"

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      Name    = var.ecs_cp_naming_prefix
      CP_Type = local.cp_type
    }
  )
}

# Fetch the latest ECS-optimized AMI from the AMI list
data "aws_ami" "ecs_optimized" {
  count = var.custom_ami_id == null ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Launch Template
resource "aws_launch_template" "ecs_lt" {
  count         = var.launch_template_id == null ? 1 : 0
  name_prefix   = "${var.ecs_cp_naming_prefix}-launch-template"
  image_id      = local.ami_id
  instance_type = var.instance_types[0]
  key_name      = var.instance_key

  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  dynamic "monitoring" {
    for_each = var.enable_monitoring ? [1] : []
    content {
      enabled = true
    }
  }

  # Enable metadata v2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  # Root volume configuration
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      encrypted             = var.root_volume_encrypted
      delete_on_termination = var.root_volume_deletion_on_termination
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
              EOF
  )

  dynamic "tag_specifications" {
    for_each = var.enable_default_tags ? [
      "instance",
      "volume",
      "network-interface"
    ] : []
    content {
      resource_type = tag_specifications.value
      tags          = local.common_tags
    }
  }
}

# Autoscaling Group
resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "${var.ecs_cp_naming_prefix}-asg"
  vpc_zone_identifier       = var.vpc_subnets
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period

  protect_from_scale_in = var.protect_from_scale_in
  enabled_metrics       = local.enabled_metrics
  capacity_rebalance    = var.use_spot_instances

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.use_spot_instances ? 0 : var.min_size
      on_demand_percentage_above_base_capacity = var.use_spot_instances ? 0 : 100
      spot_allocation_strategy                 = var.use_spot_instances ? var.spot_allocation_strategy : null
    }

    launch_template {
      launch_template_specification {
        launch_template_id = var.launch_template_id != null ? var.launch_template_id : aws_launch_template.ecs_lt[0].id
        version            = var.launch_template_version != null ? var.launch_template_version : aws_launch_template.ecs_lt[0].latest_version
      }

      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

# ECS Capacity Provider
resource "aws_ecs_capacity_provider" "this" {
  name = "${local.cp_type}-${var.ecs_cp_naming_prefix}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = var.cp_managed_termination_protection

    managed_scaling {
      status                    = var.managed_scaling_enabled
      maximum_scaling_step_size = var.max_scaling_step_size
      minimum_scaling_step_size = var.min_scaling_step_size
      target_capacity           = var.target_capacity
      instance_warmup_period    = var.ecs_instance_warmup_period
    }
  }

  tags = local.common_tags
}
