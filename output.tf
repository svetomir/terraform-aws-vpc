output "aws_vpc" {
    value = aws_vpc.main
}

output "aws_vpc_ipv4_cidr_block_association" {
    value = aws_vpc_ipv4_cidr_block_association.main
}

output "aws_vpc_dhcp_options" {
    value = aws_vpc_dhcp_options.main
}

output "aws_vpc_dhcp_options_association" {
    value = aws_vpc_dhcp_options_association.main
}

output "aws_internet_gateway" {
    value = aws_internet_gateway.main
}

output "aws_subnet_persistence" {
    value = aws_subnet.persistence
}

output "aws_subnet_private" {
    value = aws_subnet.private
}

output "aws_subnet_public" {
    value = aws_subnet.public
}

output "aws_eip" {
    value = aws_eip.nat_gw
}

output "aws_nat_gateway" {
    value = aws_nat_gateway.main
}
