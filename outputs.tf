output "capacity_provider_name" {
  description = "Name of the created capacity provider"
  value       = aws_ecs_capacity_provider.this.name
}

output "capacity_provider_id" {
  description = "ID of the created capacity provider"
  value       = aws_ecs_capacity_provider.this.id
}

output "autoscaling_group_name" {
  description = "Name of the created Auto Scaling Group"
  value       = aws_autoscaling_group.ecs_asg.name
}

output "launch_template_id" {
  description = "ID of the created Launch Template"
  value       = aws_launch_template.ecs_lt[0].id
}

output "launch_template_latest_version" {
  description = "Latest version of the created Launch Template"
  value       = aws_launch_template.ecs_lt[0].latest_version
}

output "ami_id" {
  description = "AMI ID being used"
  value       = local.ami_id
}
