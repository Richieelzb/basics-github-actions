/*resource "aws_launch_template" "web" {
  name_prefix   = "web-template-"
  image_id      = "ami-0b22c8a08f90a1ef7" # Replace with a valid AMI ID
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.codedeploy_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.public-sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello from Auto Scaling Group" > /var/www/html/index.html
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
  )
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 2
  vpc_zone_identifier  = module.vpc.public_subnets[*]
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}*/