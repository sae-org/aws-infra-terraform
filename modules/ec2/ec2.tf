# creating an aws instance with its type, ubuntu ami, newly generated key-pair attached, security groups attached, user data script that runs on boot up that will install docker nginx & create dockerfile. also defining root volume for instance to be 10 gig and of type gp3 and also attach ec2 role instance profile 


# resource "aws_instance" "webserver" {
#   count = var.number
#   instance_type               = var.ins_type
#   ami                         = var.ami
#   key_name                    = aws_key_pair.newkey.key_name
#   vpc_security_group_ids      = [module.sg_ec2.sg_id]
#   iam_instance_profile        = var.iam_ins_profile
#   associate_public_ip_address = var.pub_ip
#   subnet_id                   = var.subnet_id

#   dynamic "root_block_device" {
#     for_each = var.root_block_device
#     content {
#       volume_size = root_block_device.value.volume_size
#       volume_type = root_block_device.value.volume_type
#       encrypted   = root_block_device.value.encrypted
#     }
#   }

#   user_data                   = var.user_data
#   user_data_replace_on_change = var.user_data_replace

#   tags = {
#     Name      = var.ec2_name
#   }
# }


resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.ec2_name}-lt"
  image_id      = var.ami
  instance_type = var.ins_type
  key_name      = aws_key_pair.newkey.key_name

  iam_instance_profile {
    name = var.iam_ins_profile
  }

  # Option A (simple): rely on subnet's MapPublicIpOnLaunch for public IPs
  # vpc_security_group_ids = [module.sg_ec2.sg_id]

  # If you MUST force a public IP regardless of subnet setting, use Option B instead of the line above:
  network_interfaces {
    associate_public_ip_address = var.pub_ip
    security_groups             = [module.sg_ec2.sg_id]
  }

  # Root volume (adjust device_name if your AMI uses a different one)
  dynamic "block_device_mappings" {
    for_each = var.root_block_device
    content {
      device_name = "/dev/xvda"
      ebs {
        volume_size = block_device_mappings.value.volume_size
        volume_type = block_device_mappings.value.volume_type
        encrypted   = block_device_mappings.value.encrypted
      }
    }
  }

  # Launch Templates expect base64 user_data
  user_data = var.user_data != "" ? base64encode(var.user_data) : null

  # Make $Latest the default so ASG picks up changes
  update_default_version = true
}
