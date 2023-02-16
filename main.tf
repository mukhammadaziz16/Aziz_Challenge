resource "aws_instance" "gr-instance" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2-sec-group.id]
  subnet_id              = aws_subnet.gr-subnet-1.id
  user_data_base64       = "IyEvYmluL2Jhc2gKc3VkbyB5dW0gaW5zdGFsbCBodHRwZCAteQpzdWRvIHN5c3RlbWN0bCBzdGFydCBodHRwZApzdWRvIHN5c3RlbWN0bCBlbmFibGUgaHR0cGQKc3VkbyB0b3VjaCAvdmFyL3d3dy9odG1sL2luZGV4Lmh0bWwKc3VkbyBjaG1vZCA3NzcgL3Zhci93d3cvaHRtbC9pbmRleC5odG1sCnN1ZG8gZWNobyAmbHQ7aHRtbCZndDsKJmx0O2hlYWQmZ3Q7CiZsdDt0aXRsZSZndDtIZWxsbyBXb3JsZCZsdDsvdGl0bGUmZ3Q7CiZsdDsvaGVhZCZndDsKJmx0O2JvZHkmZ3Q7CiZsdDtoMSZndDtIZWxsbyBXb3JsZCEmbHQ7L2gxJmd0OwombHQ7L2JvZHkmZ3Q7CiZsdDsvaHRtbCZndDsgL3Zhci93d3cvaHRtbC9pbmRleC5odG1sCg=="
  key_name               = "gr_key_pair"
  tags = {
    Name = "gr-instance"
  }
}

resource "aws_key_pair" "gr_key_pair" {
  key_name   = "gr_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "gr-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "gr-vpc"
  }

}

resource "aws_internet_gateway" "gr-gw" {
  vpc_id = aws_vpc.gr-vpc.id
  tags = {
    Name = "gr-internet-gateway"
  }
}

resource "aws_subnet" "gr-subnet-1" {
  vpc_id            = aws_vpc.gr-vpc.id
  cidr_block        = "10.0.0.0/16"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.gr-vpc.id

  tags = {
    Name = "GR route table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.gr-subnet-1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_eip" "eip-gr" {
  instance = aws_instance.gr-instance.id
  vpc      = true
}

resource "aws_ebs_volume" "gr-ebc" {
  availability_zone = "us-east-1a"
  size              = 1
}

resource "aws_volume_attachment" "gr-ebs" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.gr-ebc.id
  instance_id = aws_instance.gr-instance.id
}