resource "aws_subnet" "subnet_rds_1" {
  depends_on        = ["aws_vpc.vpc"]
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "10.100.10.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "subnet_rds_2" {
  depends_on        = ["aws_vpc.vpc"]
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "10.100.11.0/24"
  availability_zone = "ap-northeast-1c"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  depends_on = ["aws_subnet.subnet_rds_1", "aws_subnet.subnet_rds_2"]
  subnet_ids = ["${aws_subnet.subnet_rds_1.id}", "${aws_subnet.subnet_rds_2.id}"]
}

resource "aws_security_group" "sg_db" {
  depends_on = ["aws_vpc.vpc"]
  name       = "sg_db"
  vpc_id     = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 3306
    to_port   = 3306
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

resource "aws_db_instance" "sample" {
  depends_on           = ["aws_db_subnet_group.db_subnet_group"]
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "sample"
  username             = "root"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = true
  skip_final_snapshot  = true

  db_subnet_group_name   = "${aws_db_subnet_group.db_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.sg_db.id}"]
}
