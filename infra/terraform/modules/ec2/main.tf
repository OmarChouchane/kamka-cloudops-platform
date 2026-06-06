resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name

  user_data = file("${path.module}/userdata.sh")

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }

  # Prevent instance replacement when only user_data changes post-deploy
  lifecycle {
    ignore_changes = [user_data]
  }

  tags = {
    Name = "${var.project_name}-ec2"
  }
}

resource "aws_eip" "app" {
  instance = aws_instance.app.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}
