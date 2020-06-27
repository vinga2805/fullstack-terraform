resource "aws_security_group" "elb_sg" {
  name        = "ALLOW HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    description = "HTTP from ANYWHERE"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Demo-elb-sg"
  }
}
resource "aws_security_group" "bastion_sg" {
  name        = "ALLOW SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    description = "SSH from MYIP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.192.204.94/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Demo-bastion-sg"
  }
}
resource "aws_security_group" "app_sg" {
  name        = "ALLOW SSH and HTTP"
  description = "Allow SSH HTTP inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    description = "SSH from MYIP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.bastion_sg.id}"]
  }
  ingress {
    description = "HTTP from LOADBALANCER"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb_sg.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Demo-app-sg"
  }
}