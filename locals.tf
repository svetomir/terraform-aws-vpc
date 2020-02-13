locals {
    nat_gateway_count = var.single_nat_gateway ? 1 : length(var.public_subnets)
}
