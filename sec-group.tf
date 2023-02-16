resource "aws_security_group" "ec2-sec-group" {
  name        = "ec2-sec-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.gr-vpc.id


  ingress {
    description = "GR World"
    from_port   = 22
    to_port     = 22
    protocol    = "-1"
  }
  ingress {
    description = "GR World"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "GR World"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    name          = "ec2-sec-group"
    instance_name = "gr-instance"
  }
}