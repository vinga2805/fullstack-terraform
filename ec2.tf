resource "aws_instance" "bastion" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.pub-sub1.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  key_name = "${aws_key_pair.demo.id}"
  tags = {
    Name = "Bastion"
    Enviromnment = "stage"
  }
}
resource "aws_instance" "app1" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.pri-sub1.id}"
  vpc_security_group_ids = ["${aws_security_group.app_sg.id}"]
  key_name = "${aws_key_pair.demo.id}"
  user_data = "${file("bootstrap.sh")}"
  tags = {
   Name = "App1"
    Enviromnment = "stage"
  }
}
resource "aws_instance" "app2" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.pri-sub2.id}"
  vpc_security_group_ids = ["${aws_security_group.app_sg.id}"]
  key_name = "${aws_key_pair.demo.id}"
  user_data = "${file("bootstrap.sh")}"
  tags = {
    Name = "App2"
    Enviromnment = "stage"
  }
}