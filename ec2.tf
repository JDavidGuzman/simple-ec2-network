data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_security_group" "ec2_sg" {

  description = "Allow access to EC2"
  name        = "${local.prefix}-ec2"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.user_ip]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 9100
    to_port     = 9100
    cidr_blocks = [var.user_ip]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_key_pair" "ec2" {

  key_name   = "${local.prefix}-ec2"
  public_key = file(var.key_file)
}

resource "aws_instance" "ec2" {
  count = var.num_instances

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2.key_name
  subnet_id     = aws_subnet.ec2_subnet.id

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  provisioner "remote-exec" {
    inline = ["echo 'SSH is ready'"]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.key_file_private)
      host        = self.public_ip
    }
  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-ec2" })
  )
}