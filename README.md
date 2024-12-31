# Terraform module for ecs capacity provider
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ecs_asg](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/autoscaling_group) | resource |
| [aws_ecs_capacity_provider.this](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/ecs_capacity_provider) | resource |
| [aws_launch_template.ecs_lt](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/launch_template) | resource |
| [aws_ami.ecs_optimized](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_health_check_grace_period"></a> [asg\_health\_check\_grace\_period](#input\_asg\_health\_check\_grace\_period) | Time in seconds after instance comes into service before checking health | `number` | `300` | no |
| <a name="input_asg_health_check_type"></a> [asg\_health\_check\_type](#input\_asg\_health\_check\_type) | Type of health check for the Auto Scaling Group | `string` | `"EC2"` | no |
| <a name="input_cp_managed_termination_protection"></a> [cp\_managed\_termination\_protection](#input\_cp\_managed\_termination\_protection) | Whether to enable managed termination protection for the ECS Capacity Provider | `string` | `"ENABLED"` | no |
| <a name="input_custom_ami_id"></a> [custom\_ami\_id](#input\_custom\_ami\_id) | Custom AMI ID to use instead of the latest ECS-optimized AMI | `string` | `null` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired number of instances in the Auto Scaling Group | `number` | `1` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | ECS cluster name | `string` | n/a | yes |
| <a name="input_ecs_cp_naming_prefix"></a> [ecs\_cp\_naming\_prefix](#input\_ecs\_cp\_naming\_prefix) | Prefix used for naming all resources | `string` | n/a | yes |
| <a name="input_ecs_instance_warmup_period"></a> [ecs\_instance\_warmup\_period](#input\_ecs\_instance\_warmup\_period) | Time in seconds after instance comes into service before checking health | `number` | `300` | no |
| <a name="input_enable_default_tags"></a> [enable\_default\_tags](#input\_enable\_default\_tags) | Enable default tags for EC2 instances and related resources | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable detailed monitoring for instances and ASG metrics | `bool` | `true` | no |
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | Name of the IAM instance profile for ECS instances | `string` | n/a | yes |
| <a name="input_instance_key"></a> [instance\_key](#input\_instance\_key) | Name of the key pair to use for SSH access | `string` | `""` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | List of instance types to use in the mixed instances policy | `list(string)` | <pre>[<br>  "t3.micro",<br>  "t3.small"<br>]</pre> | no |
| <a name="input_launch_template_id"></a> [launch\_template\_id](#input\_launch\_template\_id) | ID of the Launch Template | `string` | `null` | no |
| <a name="input_launch_template_version"></a> [launch\_template\_version](#input\_launch\_template\_version) | Version of the Launch Template | `number` | `null` | no |
| <a name="input_managed_scaling_enabled"></a> [managed\_scaling\_enabled](#input\_managed\_scaling\_enabled) | Whether to enable managed scaling for the ECS Capacity Provider | `string` | `"ENABLED"` | no |
| <a name="input_max_scaling_step_size"></a> [max\_scaling\_step\_size](#input\_max\_scaling\_step\_size) | Maximum number of instances to scale out at once | `number` | `10` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of instances in the Auto Scaling Group | `number` | `1` | no |
| <a name="input_min_scaling_step_size"></a> [min\_scaling\_step\_size](#input\_min\_scaling\_step\_size) | Minimum number of instances to scale out at once | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of instances in the Auto Scaling Group | `number` | `1` | no |
| <a name="input_protect_from_scale_in"></a> [protect\_from\_scale\_in](#input\_protect\_from\_scale\_in) | Prevents Auto Scaling from terminating instances on scale-in | `bool` | `false` | no |
| <a name="input_root_volume_deletion_on_termination"></a> [root\_volume\_deletion\_on\_termination](#input\_root\_volume\_deletion\_on\_termination) | Whether to delete root volume on instance termination | `bool` | `true` | no |
| <a name="input_root_volume_encrypted"></a> [root\_volume\_encrypted](#input\_root\_volume\_encrypted) | Whether to encrypt the root volume | `bool` | `true` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Size of the root volume in GB | `number` | `30` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Type of the root volume (gp3, gp2, io1, io2) | `string` | `"gp3"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for EC2 instances | `list(string)` | n/a | yes |
| <a name="input_spot_allocation_strategy"></a> [spot\_allocation\_strategy](#input\_spot\_allocation\_strategy) | Spot instance allocation strategy: lowest-price, capacity-optimized, price-capacity-optimized | `string` | `"price-capacity-optimized"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_target_capacity"></a> [target\_capacity](#input\_target\_capacity) | Target capacity percentage for the ECS cluster | `number` | `80` | no |
| <a name="input_use_spot_instances"></a> [use\_spot\_instances](#input\_use\_spot\_instances) | Whether to use spot instances instead of on-demand | `bool` | `false` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | List of VPC subnet IDs for the Auto Scaling Group | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | AMI ID being used |
| <a name="output_autoscaling_group_name"></a> [autoscaling\_group\_name](#output\_autoscaling\_group\_name) | Name of the created Auto Scaling Group |
| <a name="output_capacity_provider_id"></a> [capacity\_provider\_id](#output\_capacity\_provider\_id) | ID of the created capacity provider |
| <a name="output_capacity_provider_name"></a> [capacity\_provider\_name](#output\_capacity\_provider\_name) | Name of the created capacity provider |
| <a name="output_launch_template_id"></a> [launch\_template\_id](#output\_launch\_template\_id) | ID of the created Launch Template |
| <a name="output_launch_template_latest_version"></a> [launch\_template\_latest\_version](#output\_launch\_template\_latest\_version) | Latest version of the created Launch Template |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
