# Auto scaling policy resource 

resource "aws_autoscaling_group" "test-asg" {
  name_prefix = "${local.name}-asg"  
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = module.vpc.private_subnets
  target_group_arns = module.alb.target_group_arns
  launch_template {
    
    id = aws_launch_template.my-lc.id 
    version = aws_launch_template.my-lc.latest_version
  
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      # instance_warmup = 300 # Default behavior is to use the Auto Scaling Groups health check grace period value
      min_healthy_percentage = 50            
    }
    triggers = [ "desired_capacity" ] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }


  tag {
    key                 = "Terraform"
    value               = "True"
    propagate_at_launch = true
  }

   tag {
    key                 = "ENV"
    value               = "test"
    propagate_at_launch = true
  }
   tag {
    key                 = "Team"
    value               = "devops"
    propagate_at_launch = true
  }

}