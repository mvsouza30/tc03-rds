resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.rds-vpc.id
}