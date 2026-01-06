/*resource "aws_instance" "ec2-vm-worker" {
  ami = data.aws_ami.my-data-ami.id
  //ami = "ami-0bc691261a82b32bc"
  instance_type = var.instance-type-list[0]
  key_name               = var.key-pair
  subnet_id              = module.vpc.private_subnets[0]     
 // user_data              = file("${path.module}/app-install.sh") 
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  count                  = 1
  tags = {
    Name = "worker-ec2"
  }
}*/