resource "aws_subnet" "subnet_ec2" {
  depends_on = ["aws_vpc.vpc"]
  cidr_block = "10.100.1.0/24"
  vpc_id     = "${aws_vpc.vpc.id}"
}

resource "aws_security_group" "ssh" {
  depends_on = ["aws_vpc.vpc"]
  name       = "sg_ssh"
  vpc_id     = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http" {
  depends_on = ["aws_vpc.vpc"]
  name       = "sg_http"
  vpc_id     = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazonlinux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "sample" {
  ami                         = "${data.aws_ami.amazonlinux2.id}"
  instance_type               = "t2.micro"
  key_name                    = "ec2user"
  subnet_id                   = "${aws_subnet.subnet_ec2.id}"
  vpc_security_group_ids      = ["${aws_security_group.ssh.id}", "${aws_security_group.http.id}"]
  associate_public_ip_address = true

  tags = {
    role = "wordpress"
  }
}
