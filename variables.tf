variable "tags" {
    type        = map(string)
    default     = {}
    description = "Key-value mapping of default tags for all IAM users."
}
variable "vpc_name" {
    type        = string
    description = "VPC name."
}
variable "vpc_cidr_block" {
    type        = string
    description = "The CIDR block for the VPC."
}
variable "vpc_instance_tenancy" {
    type        = string
    default     = "default"
    description = "A tenancy option for instances launched into the VPC."
}
variable "vpc_enable_dns_support" {
    type        = bool
    default     = true
    description = "A boolean flag to enable/disable DNS support in the VPC."
}
variable "vpc_enable_dns_hostnames" {
    type        = string
    default     = false
    description = "A boolean flag to enable/disable DNS hostnames in the VPC."
}
variable "vpc_enable_classiclink" {
    type        = string
    default     = false
    description = "A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic. See the ClassicLink documentation for more information."
}
variable "vpc_enable_classiclink_dns_support" {
    type        = string
    default     = false
    description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
}
variable "vpc_assign_generated_ipv6_cidr_block" {
    type        = string
    default     = false
    description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
}
variable "vpc_additional_cidrs" {
    type        = list(string)
    default     = []
    description = "List of the additional IPv4 CIDR blocks to associate with the VPC."
}
# VPC DHCP OPTIONS
variable "set_dhcp_options" {
    type        = bool
    default     = false
    description = "Set custom DHCP options for VPC."
}
variable "dhcp_options_domain_name" {
    type        = string
    default     = ""
    description = "The suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file."
}
variable "dhcp_options_domain_name_servers" {
    type        = list(string)
    default     = []
    description = "List of name servers to configure in /etc/resolv.conf. If you want to use the default AWS nameservers you should set this to AmazonProvidedDNS."
}
variable "dhcp_options_ntp_servers" {
    type        = list(string)
    default     = []
    description = "List of NTP servers to configure."
}
variable "dhcp_options_netbios_name_servers" {
    type        = list(string)
    default     = []
    description = "List of NETBIOS name servers."
}
variable "dhcp_options_netbios_node_type" {
    type        = number
    default     = 2
    description = "The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network."
}
# NAT GATEWAYS
variable "single_nat_gateway" {
    type        = bool
    default     = false
    description = "Weather or not to use single NAT gateway."
}
# SUBNETS
variable "persistence_subnets" {
    type        = list(object({
        availability_zone    = string
        cidr_block           = string
        ipv6_cidr_block      = string
        tags                 = map(string)
    }))
    default     = []
    description = "Persistance subnets."
}
variable "persistence_subnets_assign_ipv6_address_on_creation" {
    type        = bool
    default     = false
    description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
}
variable "private_subnets" {
    type        = list(object({
        availability_zone    = string
        cidr_block           = string
        ipv6_cidr_block      = string
        tags                 = map(string)
    }))
    default     = []
    description = "Private subnets."
}
variable "private_subnets_assign_ipv6_address_on_creation" {
    type        = bool
    default     = false
    description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
}
variable "public_subnets" {
    type        = list(object({
        availability_zone    = string
        cidr_block           = string
        ipv6_cidr_block      = string
        tags                 = map(string)
    }))
    default     = []
    description = "Public subnets."
}
variable "public_subnets_map_public_ip_on_launch" {
    type        = bool
    default     = false
    description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
}
variable "public_subnets_assign_ipv6_address_on_creation" {
    type        = bool
    default     = false
    description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
}
# SUBNET GROUPS
variable "create_database_subnet_group" {
    type        = bool
    default     = false
    description = "Create databse subnet group."
}
variable "create_elasticache_subnet_group" {
    type        = bool
    default     = false
    description = "Create elasticache subnet group."
}
variable "create_redshift_subnet_group" {
    type        = bool
    default     = false
    description = "Create redshift subnet group."
}
# NETWORK ACLS
variable "create_persistence_network_acl" {
    type        = bool
    default     = false
    description = "Create network ACL for persistance subnets."
}
variable "persistence_inbound_acl_rules" {
    type        = list(map(string))
    default = [
        {
            rule_number = 100
            rule_action = "allow"
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_block  = "0.0.0.0/0"
        }
    ]
    description = "Persistance subnets inbound network ACL rules"
}
variable "persistence_outbound_acl_rules" {
    type        = list(map(string))
    default = [
        {
            rule_number = 100
            rule_action = "allow"
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_block  = "0.0.0.0/0"
        }
    ]
    description = "Persistance subnets outbound network ACL rules"
}
variable "create_private_network_acl" {
    type        = bool
    default     = false
    description = "Create network ACL for private subnets."
}
variable "private_inbound_acl_rules" {
    type        = list(map(string))
    default = [
        {
            rule_number = 100
            rule_action = "allow"
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_block  = "0.0.0.0/0"
        }
    ]
    description = "Persistance subnets inbound network ACL rules"
}
variable "private_outbound_acl_rules" {
    type        = list(map(string))
    default = [
        {
            rule_number = 100
            rule_action = "allow"
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_block  = "0.0.0.0/0"
        }
    ]
    description = "Persistance subnets outbound network ACL rules"
}
variable "create_public_network_acl" {
    type        = bool
    default     = false
    description = "Create network ACL for public subnets."
}
variable "public_inbound_acl_rules" {
    type        = list(map(string))
    default = [
        {
            rule_number = 100
            rule_action = "allow"
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_block  = "0.0.0.0/0"
        }
    ]
    description = "Persistance subnets inbound network ACL rules"
}
variable "public_outbound_acl_rules" {
    type        = list(map(string))
    default = [
        {
            rule_number = 100
            rule_action = "allow"
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_block  = "0.0.0.0/0"
        }
    ]
    description = "Persistance subnets outbound network ACL rules"
}
