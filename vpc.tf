resource "aws_vpc" "vpc" {
  cidr_block           = "10.100.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "gateway" {
  depends_on = ["aws_vpc.vpc"]
  vpc_id     = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "route_table" {
  depends_on = ["aws_vpc.vpc"]
  vpc_id     = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_main_route_table_association" "association" {
  depends_on     = ["aws_vpc.vpc", "aws_route_table.route_table"]
  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}
