# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = var.public_subnet_1_id
  route_table_id = var.public_route_table_id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = var.public_subnet_2_id
  route_table_id = var.public_route_table_id
}

resource "aws_route_table_association" "public_assoc_3" {
  subnet_id      = var.public_subnet_3_id
  route_table_id = var.public_route_table_id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = var.private_subnet_1_id
  route_table_id = var.private_route_table_id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = var.private_subnet_2_id
  route_table_id = var.private_route_table_id
}

resource "aws_route_table_association" "private_assoc_3" {
  subnet_id      = var.private_subnet_3_id
  route_table_id = var.private_route_table_id
}
