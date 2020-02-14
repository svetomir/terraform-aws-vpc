output "arn" {
    value       = aws_vpc.main.arn
    description = "Amazon Resource Name (ARN) of VPC."
}

output "assign_generated_ipv6_cidr_block" {
    value       = aws_vpc.main.assign_generated_ipv6_cidr_block
    description = "Assign generated IPv6 CIDR block."
}

output "cidr_block" {
    value       = aws_vpc.main.cidr_block
    description = "The CIDR block for the association."
}

output "default_network_acl_id" {
    value       = aws_vpc.main.default_network_acl_id
    description = "Default network ACL ID."
}

output "default_route_table_id" {
    value       = aws_vpc.main.default_route_table_id
    description = "Default route table ID."
}

output "default_security_group_id" {
    value       = aws_vpc.main.default_security_group_id
    description = "Default security group ID."
}

output "dhcp_options_id" {
    value       = aws_vpc.main.dhcp_options_id
    description = "DHCP options ID."
}

output "enable_classiclink" {
    value       = aws_vpc.main.enable_classiclink
    description = "Enable classic link."
}

output "enable_classiclink_dns_support" {
    value       = aws_vpc.main.enable_classiclink_dns_support
    description = "Enable classic link DNS support"
}

output "enable_dns_hostnames" {
    value       = aws_vpc.main.enable_dns_hostnames
    description = "Whether or not the VPC has DNS hostname support."
}

output "enable_dns_support" {
    value       = aws_vpc.main.enable_dns_support
    description = "Whether or not the VPC has DNS support."
}

output "id" {
    value       = aws_vpc.main.id
    description = "VPC ID."
}

output "instance_tenancy" {
    value       = aws_vpc.main.instance_tenancy
    description = "The allowed tenancy of instances launched into the selected VPC."
}

output "ipv6_association_id" {
    value       = aws_vpc.main.ipv6_association_id
    description = "The association ID for the IPv6 CIDR block."
}

output "ipv6_cidr_block" {
    value       = aws_vpc.main.ipv6_cidr_block
    description = "The IPv6 CIDR block."
}

output "main_route_table_id" {
    value       = aws_vpc.main.main_route_table_id
    description = "The ID of the main route table associated with this VPC."
}

output "owner_id" {
    value       = aws_vpc.main.owner_id
    description = "The ID of the AWS account that owns the VPC."
}


output "vpc_dhcp_options_id" {
    value       = concat(aws_vpc_dhcp_options.main.*.id, [""])[0]
    description = "The ID of the DHCP Options Set."
}

output "vpc_dhcp_options_owner_id" {
    value       = concat(aws_vpc_dhcp_options.main.*.owner_id, [""])[0]
    description = "The ID of the AWS account that owns the DHCP options set."
}

output "internet_gateway_id" {
    value       = concat(aws_internet_gateway.main.*.id, [""])[0]
    description = "The ID of the Internet Gateway."
}

output "internet_gateway_owner_id" {
    value       = concat(aws_internet_gateway.main.*.owner_id, [""])[0]
    description = "The ID of the AWS account that owns the internet gateway."
}

output "egress_only_internet_gateway" {
    value       = concat(aws_egress_only_internet_gateway.main.*.id, [""])[0]
    description = "The ID of the egress-only Internet gateway."
}

output "eip_nat_gws" {
    value       = aws_eip.nat_gw
    description = "NAT gateway elastic IPs."
}

output "subnets_persistence" {
    value       = aws_subnet.persistence
    description = "Persistence subnets"
}

output "subnets_private" {
    value       = aws_subnet.private
    description = "Private subnets"
}

output "subnets_public" {
    value       = aws_subnet.public
    description = "Public subnets"
}

output "db_subnet_group_id" {
    value       = concat(aws_db_subnet_group.database.*.id, [""])[0]
    description = "The db subnet group name."
}

output "db_subnet_group_arn" {
    value       = concat(aws_db_subnet_group.database.*.arn, [""])[0]
    description = "The ARN of the db subnet group."
}

output "elasticache_subnet_group_description" {
    value       = concat(aws_elasticache_subnet_group.elasticache.*.description, [""])[0]
    description = "ElastiCache subnet group description"
}

output "elasticache_subnet_group_name" {
    value       = concat(aws_elasticache_subnet_group.elasticache.*.name, [""])[0]
    description = "ElastiCache subnet group name"
}

output "elasticache_subnet_group_subnet_ids" {
    value       = concat(aws_elasticache_subnet_group.elasticache.*.subnet_ids, [])
    description = "ElastiCache subnet group subnet IDs"
}

output "redshift_subnet_group_id" {
    value       = concat(aws_redshift_subnet_group.redshift.*.id, [""])[0]
    description = "The Redshift Subnet group ID."
}

output "redshift_subnet_group_arn" {
    value       = concat(aws_redshift_subnet_group.redshift.*.arn, [""])[0]
    description = "Amazon Resource Name (ARN) of the Redshift Subnet group name."
}

output "route_tables_persistence" {
    value       = aws_route_table.persistence
    description = "Persistence route tables."
}

output "route_tables_private" {
    value       = aws_route_table.private
    description = "Private route tables."
}

output "route_tables_public" {
    value       = aws_route_table.public
    description = "Public route tables."
}

output "network_acl_persistence" {
    value       = aws_network_acl.persistence
    description = "Persistence network ACL."
}

output "network_acl_private" {
    value       = aws_network_acl.private
    description = "Private network ACL."
}

output "network_acl_public" {
    value       = aws_network_acl.public
    description = "Public network ACL."
}
