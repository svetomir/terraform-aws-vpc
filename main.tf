resource "aws_vpc" "main" {
    cidr_block                       = var.cidr_block
    instance_tenancy                 = var.instance_tenancy
    enable_dns_support               = var.enable_dns_support
    enable_dns_hostnames             = var.enable_dns_hostnames
    enable_classiclink               = var.enable_classiclink
    enable_classiclink_dns_support   = var.enable_classiclink_dns_support
    assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
    
    tags = merge(
        var.tags,
        {"Name" = var.name}
    )

    lifecycle {
        ignore_changes = [tags]
    }
}

resource "aws_vpc_ipv4_cidr_block_association" "main" {
    count = length(var.additional_cidrs) > 0 ? length(var.additional_cidrs) : 0

    vpc_id     = aws_vpc.main.id
    cidr_block = var.additional_cidrs[count.index]
}

# VPC PRIVATE DNS ZONE

resource "aws_route53_zone" "private" {
    count = var.private_dns_zone != "" ? 1 : 0

    name = var.private_dns_zone
    
    vpc {
        vpc_id = aws_vpc.main.id
    }

    tags = merge(
        var.tags,
        {"Name" = var.private_dns_zone}
    )
}

# VPC DHCP OPTIONS

resource "aws_vpc_dhcp_options" "main" {
    count = var.set_dhcp_options ? 1 : 0

    domain_name          = var.dhcp_options_domain_name
    domain_name_servers  = var.dhcp_options_domain_name_servers
    ntp_servers          = var.dhcp_options_ntp_servers
    netbios_name_servers = var.dhcp_options_netbios_name_servers
    netbios_node_type    = var.dhcp_options_netbios_node_type
    
    tags = merge(
        var.tags,
        {"Name" = var.name}
    )
}

resource "aws_vpc_dhcp_options_association" "main" {
    count = var.set_dhcp_options ? 1 : 0
    
    vpc_id          = aws_vpc.main.id
    dhcp_options_id = aws_vpc_dhcp_options.main[0].id
}

# INTERNET GATEWAY

resource "aws_internet_gateway" "main" {
    count = length(var.public_subnets) > 0 ? 1 : 0

    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.tags,
        {"Name" = var.name}
    )
}

resource "aws_egress_only_internet_gateway" "main" {
    count = var.assign_generated_ipv6_cidr_block && length(var.public_subnets) > 0 ? 1 : 0
    
    vpc_id = aws_vpc.main.id
}

# NAT GATEWAYS

resource "aws_eip" "nat_gw" {
    count = local.nat_gateway_count
    
    vpc = true

    tags = merge(
        var.tags,
        {"Name" = var.single_nat_gateway ? format("%s", var.name) : format("%s-%s", var.name, count.index)}
    )
}

resource "aws_nat_gateway" "main" {
    count = local.nat_gateway_count

    allocation_id = aws_eip.nat_gw[count.index].id
    subnet_id     = aws_subnet.public[count.index].id

    tags = merge(
        var.tags,
        {"Name" = var.single_nat_gateway ? format("%s", var.name) : format("%s-%s", var.name, count.index)}
    )

    depends_on = [aws_internet_gateway.main]
}

# SUBNETS

resource "aws_subnet" "persistence" {
    count = length(var.persistence_subnets) > 0 ? length(var.persistence_subnets) : 0

    availability_zone               = var.persistence_subnets[count.index].availability_zone
    cidr_block                      = var.persistence_subnets[count.index].cidr_block
    ipv6_cidr_block                 = var.persistence_subnets[count.index].ipv6_cidr_block
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = var.persistence_subnets_assign_ipv6_address_on_creation
    vpc_id                          = aws_vpc.main.id
    
    tags = merge(
        var.tags,
        {
            Name = format("%s-persistence-%s", var.name, count.index)
            Tier = "persistence"
        },
        var.persistence_subnets[count.index].tags
    )

    lifecycle {
        ignore_changes = [tags]
    }

    depends_on = [aws_vpc.main]
}

resource "aws_subnet" "private" {
    count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

    availability_zone               = var.private_subnets[count.index].availability_zone
    cidr_block                      = var.private_subnets[count.index].cidr_block
    ipv6_cidr_block                 = var.private_subnets[count.index].ipv6_cidr_block
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = var.private_subnets_assign_ipv6_address_on_creation
    vpc_id                          = aws_vpc.main.id
    
    tags = merge(
        var.tags,
        {
            Name = format("%s-private-%s", var.name, count.index)
            Tier = "private"
        },
        var.private_subnets[count.index].tags
    )

    lifecycle {
        ignore_changes = [tags]
    }

    depends_on = [aws_vpc.main]
}

resource "aws_subnet" "public" {
    count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

    availability_zone               = var.public_subnets[count.index].availability_zone
    cidr_block                      = var.public_subnets[count.index].cidr_block
    ipv6_cidr_block                 = var.public_subnets[count.index].ipv6_cidr_block
    map_public_ip_on_launch         = var.public_subnets_map_public_ip_on_launch
    assign_ipv6_address_on_creation = var.public_subnets_assign_ipv6_address_on_creation
    vpc_id                          = aws_vpc.main.id
    
    tags = merge(
        var.tags,
        {
            Name = format("%s-public-%s", var.name, count.index)
            Tier = "public"
        },
        var.public_subnets[count.index].tags
    )

    lifecycle {
        ignore_changes = [tags]
    }

    depends_on = [aws_vpc.main]
}

# SUBNET GROUPS

resource "aws_db_subnet_group" "database" {
    count = length(var.persistence_subnets) > 0 && var.create_database_subnet_group ? 1 : 0
    
    name        = lower(var.name)
    description = format("Database subnet group for VPC %s.", var.name)
    subnet_ids  = aws_subnet.persistence.*.id
    
    tags = merge(
        var.tags,
        {
            "Name" = format("%s", var.name)
        }
    )
}

resource "aws_elasticache_subnet_group" "elasticache" {
    count = length(var.persistence_subnets) > 0 && var.create_elasticache_subnet_group ? 1 : 0
    
    name        = lower(var.name)
    description = format("ElastiCache subnet group for VPC %s.", var.name)
    subnet_ids  = aws_subnet.persistence.*.id
}

resource "aws_redshift_subnet_group" "redshift" {
    count = length(var.persistence_subnets) > 0 && var.create_redshift_subnet_group ? 1 : 0
    
    name        = lower(var.name)
    description = format("Redshift subnet group for VPC %s.", var.name)
    subnet_ids  = aws_subnet.persistence.*.id
    
    tags = merge(
        var.tags,
        {
            "Name" = format("%s", var.name)
        }
    )
}

# ROUTING

resource "aws_route_table" "persistence" {
    count = length(var.persistence_subnets) > 0 ? local.nat_gateway_count : 0
    
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.tags,
        {
            Name = var.single_nat_gateway ? format("%s-persistence", var.name) : format("%s-persistence-%s", var.name, count.index)
        }
    )
}

resource "aws_route_table_association" "persistence" {
    count = length(var.persistence_subnets) > 0 ? length(var.persistence_subnets) : 0
    
    subnet_id = element(aws_subnet.persistence.*.id, count.index)
    route_table_id = element(aws_route_table.persistence.*.id, var.single_nat_gateway ? 0 : count.index)
}

resource "aws_route" "persistence_nat_gateway" {
    count = length(var.persistence_subnets) > 0 ? local.nat_gateway_count : 0
    
    route_table_id         = element(aws_route_table.persistence.*.id, count.index)
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table" "private" {
    count = length(var.private_subnets) > 0 ? local.nat_gateway_count : 0
    
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.tags,
        {
            Name = var.single_nat_gateway ? format("%s-private", var.name) : format("%s-private-%s", var.name, count.index)
        }
    )
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
    
    subnet_id = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, var.single_nat_gateway ? 0 : count.index)
}

resource "aws_route" "private_nat_gateway" {
    count = length(var.private_subnets) > 0 ? local.nat_gateway_count : 0
    
    route_table_id         = element(aws_route_table.private.*.id, count.index)
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route" "private_ipv6_egress" {
    count = var.assign_generated_ipv6_cidr_block ? length(var.private_subnets) : 0
    
    route_table_id              = element(aws_route_table.private.*.id, count.index)
    destination_ipv6_cidr_block = "::/0"
    egress_only_gateway_id      = element(aws_egress_only_internet_gateway.main.*.id, 0)
}

resource "aws_route_table" "public" {
    count = length(var.public_subnets) > 0 ? 1 : 0
    
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.tags,
        {
            Name = format("%s-public", var.name)
        }
    )
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
    
    subnet_id      = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "public_internet_gateway" {
    count = length(var.public_subnets) > 0 ? 1 : 0

    route_table_id         = aws_route_table.public[0].id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.main[0].id
}

resource "aws_route" "public_internet_gateway_ipv6" {
    count = var.assign_generated_ipv6_cidr_block && length(var.public_subnets) > 0 ? 1 : 0
    
    route_table_id              = aws_route_table.public[0].id
    destination_ipv6_cidr_block = "::/0"
    gateway_id                  = aws_internet_gateway.main[0].id
}

# NETWORK ACLS

resource "aws_network_acl" "persistence" {
    count = length(var.persistence_subnets) > 0 && var.create_persistence_network_acl ? 1 : 0
    
    vpc_id     = aws_vpc.main.id
    subnet_ids = aws_subnet.persistence.*.id
    
    tags = merge(
        var.tags,
        {
            Name = format("%s-persistence", var.name)
        }
    )
}

resource "aws_network_acl_rule" "persistence_inbound" {
    count = length(var.persistence_subnets) > 0 && var.create_persistence_network_acl ? length(var.persistence_inbound_acl_rules) : 0
    
    network_acl_id = aws_network_acl.persistence[0].id
    
    egress          = false
    rule_number     = var.persistence_inbound_acl_rules[count.index]["rule_number"]
    rule_action     = var.persistence_inbound_acl_rules[count.index]["rule_action"]
    from_port       = lookup(var.persistence_inbound_acl_rules[count.index], "from_port", null)
    to_port         = lookup(var.persistence_inbound_acl_rules[count.index], "to_port", null)
    icmp_code       = lookup(var.persistence_inbound_acl_rules[count.index], "icmp_code", null)
    icmp_type       = lookup(var.persistence_inbound_acl_rules[count.index], "icmp_type", null)
    protocol        = var.persistence_inbound_acl_rules[count.index]["protocol"]
    cidr_block      = lookup(var.persistence_inbound_acl_rules[count.index], "cidr_block", null)
    ipv6_cidr_block = lookup(var.persistence_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "persistence_outbound" {
    count = length(var.persistence_subnets) > 0 && var.create_persistence_network_acl ? length(var.persistence_outbound_acl_rules) : 0
    
    network_acl_id = aws_network_acl.persistence[0].id
    
    egress          = true
    rule_number     = var.persistence_outbound_acl_rules[count.index]["rule_number"]
    rule_action     = var.persistence_outbound_acl_rules[count.index]["rule_action"]
    from_port       = lookup(var.persistence_outbound_acl_rules[count.index], "from_port", null)
    to_port         = lookup(var.persistence_outbound_acl_rules[count.index], "to_port", null)
    icmp_code       = lookup(var.persistence_outbound_acl_rules[count.index], "icmp_code", null)
    icmp_type       = lookup(var.persistence_outbound_acl_rules[count.index], "icmp_type", null)
    protocol        = var.persistence_outbound_acl_rules[count.index]["protocol"]
    cidr_block      = lookup(var.persistence_outbound_acl_rules[count.index], "cidr_block", null)
    ipv6_cidr_block = lookup(var.persistence_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl" "private" {
    count = length(var.private_subnets) > 0 && var.create_private_network_acl ? 1 : 0
    
    vpc_id     = aws_vpc.main.id
    subnet_ids = aws_subnet.private.*.id
    
    tags = merge(
        var.tags,
        {
            Name = format("%s-private", var.name)
        }
    )
}

resource "aws_network_acl_rule" "private_inbound" {
    count = length(var.private_subnets) > 0 && var.create_private_network_acl ? length(var.private_inbound_acl_rules) : 0
    
    network_acl_id = aws_network_acl.private[0].id
    
    egress          = false
    rule_number     = var.private_inbound_acl_rules[count.index]["rule_number"]
    rule_action     = var.private_inbound_acl_rules[count.index]["rule_action"]
    from_port       = lookup(var.private_inbound_acl_rules[count.index], "from_port", null)
    to_port         = lookup(var.private_inbound_acl_rules[count.index], "to_port", null)
    icmp_code       = lookup(var.private_inbound_acl_rules[count.index], "icmp_code", null)
    icmp_type       = lookup(var.private_inbound_acl_rules[count.index], "icmp_type", null)
    protocol        = var.private_inbound_acl_rules[count.index]["protocol"]
    cidr_block      = lookup(var.private_inbound_acl_rules[count.index], "cidr_block", null)
    ipv6_cidr_block = lookup(var.private_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "private_outbound" {
    count = length(var.private_subnets) > 0 && var.create_private_network_acl ? length(var.private_outbound_acl_rules) : 0
    
    network_acl_id = aws_network_acl.private[0].id
    
    egress          = true
    rule_number     = var.private_outbound_acl_rules[count.index]["rule_number"]
    rule_action     = var.private_outbound_acl_rules[count.index]["rule_action"]
    from_port       = lookup(var.private_outbound_acl_rules[count.index], "from_port", null)
    to_port         = lookup(var.private_outbound_acl_rules[count.index], "to_port", null)
    icmp_code       = lookup(var.private_outbound_acl_rules[count.index], "icmp_code", null)
    icmp_type       = lookup(var.private_outbound_acl_rules[count.index], "icmp_type", null)
    protocol        = var.private_outbound_acl_rules[count.index]["protocol"]
    cidr_block      = lookup(var.private_outbound_acl_rules[count.index], "cidr_block", null)
    ipv6_cidr_block = lookup(var.private_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl" "public" {
    count = length(var.public_subnets) > 0 && var.create_public_network_acl ? 1 : 0
    
    vpc_id     = aws_vpc.main.id
    subnet_ids = aws_subnet.public.*.id
    
    tags = merge(
        var.tags,
        {
            Name = format("%s-public", var.name)
        }
    )
}

resource "aws_network_acl_rule" "public_inbound" {
    count = length(var.public_subnets) > 0 && var.create_public_network_acl ? length(var.public_inbound_acl_rules) : 0
    
    network_acl_id = aws_network_acl.public[0].id
    
    egress          = false
    rule_number     = var.public_inbound_acl_rules[count.index]["rule_number"]
    rule_action     = var.public_inbound_acl_rules[count.index]["rule_action"]
    from_port       = lookup(var.public_inbound_acl_rules[count.index], "from_port", null)
    to_port         = lookup(var.public_inbound_acl_rules[count.index], "to_port", null)
    icmp_code       = lookup(var.public_inbound_acl_rules[count.index], "icmp_code", null)
    icmp_type       = lookup(var.public_inbound_acl_rules[count.index], "icmp_type", null)
    protocol        = var.public_inbound_acl_rules[count.index]["protocol"]
    cidr_block      = lookup(var.public_inbound_acl_rules[count.index], "cidr_block", null)
    ipv6_cidr_block = lookup(var.public_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "public_outbound" {
    count = length(var.public_subnets) > 0 && var.create_public_network_acl ? length(var.public_outbound_acl_rules) : 0
    
    network_acl_id = aws_network_acl.public[0].id
    
    egress          = true
    rule_number     = var.public_outbound_acl_rules[count.index]["rule_number"]
    rule_action     = var.public_outbound_acl_rules[count.index]["rule_action"]
    from_port       = lookup(var.public_outbound_acl_rules[count.index], "from_port", null)
    to_port         = lookup(var.public_outbound_acl_rules[count.index], "to_port", null)
    icmp_code       = lookup(var.public_outbound_acl_rules[count.index], "icmp_code", null)
    icmp_type       = lookup(var.public_outbound_acl_rules[count.index], "icmp_type", null)
    protocol        = var.public_outbound_acl_rules[count.index]["protocol"]
    cidr_block      = lookup(var.public_outbound_acl_rules[count.index], "cidr_block", null)
    ipv6_cidr_block = lookup(var.public_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}
