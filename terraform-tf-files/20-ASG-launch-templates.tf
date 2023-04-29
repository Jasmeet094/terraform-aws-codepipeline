# Launch Template resource 

resource "aws_launch_template" "my-lc" {
  name_prefix = "${local.name}-lt"  
  image_id = data.aws_ami.amzn-ami.id
  instance_type = var.instance-type
  key_name = var.key
  user_data = filebase64("${path.module}/24-app1-user-data.sh")
  vpc_security_group_ids = [module.private_sg.security_group_id]
  ebs_optimized = true
  update_default_version = true 
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 8
      delete_on_termination = true
      volume_type = "gp2" # default  is gp2 
    }
  }

  tags = {
      Terraform = "true"
      Team   =  "devops"
      Env   = "test"
    }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.name}-instance"
    }
  }
  
}