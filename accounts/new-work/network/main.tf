module "network_creation" {
  source                      = "../../../modules/eks-network/creation"
  aws_vpc_cidr_block          = "10.0.0.0/16"
  public_subnet_1_cidr_block  = "10.0.1.0/24"
  public_subnet_2_cidr_block  = "10.0.2.0/24"
  public_subnet_3_cidr_block  = "10.0.3.0/24"
  private_subnet_1_cidr_block = "10.0.4.0/24"
  private_subnet_2_cidr_block = "10.0.5.0/24"
  private_subnet_3_cidr_block = "10.0.6.0/24"
  availability_zones          = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_rt_cidr_block        = "0.0.0.0/0"
  private_rt_cidr_block       = "0.0.0.0/0"
}

module "network_configuration" {
  source                 = "../../../modules/eks-network/config"
  public_subnet_1_id     = module.network_creation.public_subnet_1_id
  public_subnet_2_id     = module.network_creation.public_subnet_2_id
  public_subnet_3_id     = module.network_creation.public_subnet_3_id
  private_subnet_1_id    = module.network_creation.private_subnet_1_id
  private_subnet_2_id    = module.network_creation.private_subnet_2_id
  private_subnet_3_id    = module.network_creation.private_subnet_3_id
  public_route_table_id  = module.network_creation.public_route_table_id
  private_route_table_id = module.network_creation.private_route_table_id
}
