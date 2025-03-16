variable "aws_vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr_block" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_2_cidr_block" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "public_subnet_3_cidr_block" {
  description = "CIDR block for the third public subnet"
  type        = string
}

variable "private_subnet_1_cidr_block" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_2_cidr_block" {
  description = "CIDR block for the second private subnet"
  type        = string
}

variable "private_subnet_3_cidr_block" {
  description = "CIDR block for the third private subnet"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_rt_cidr_block" {
  description = "CIDR block for the public route table"
  type        = string
}

variable "private_rt_cidr_block" {
  description = "CIDR block for the private route table"
  type        = string
}
