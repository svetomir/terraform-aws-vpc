# Terraform AWS VPC

**terraform-aws-vpc** is Terraform module for creating:
 * VPC
 * (optionally) 1-3 tiers of subnets (persistence, private, public) accross multiple AZs with routing
 * (optionally) subnet groups:
    * database
    * elasticache
    * redshift
 * (optionally) Private Route53 zone
 * (optionally) Internet Gateway
 * (optionally) NAT Gateway(s)
 * (optionally) setting DHCP options
 * (optionally) network ACL(s)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.20 |
| aws provider | >= 2.47 |

## Inputs

| Name | Description | Required |
|------|-------------|----------|
| name | VPC name. | true
| cidr_block | The CIDR block for the VPC. | true
| additional_cidrs | List of the additional IPv4 CIDR blocks to associate with the VPC. Defaults to **[]**. | false
| assign_generated_ipv6_cidr_block | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Defaults to **false**. | false
| enable_classiclink | A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic. See the ClassicLink documentation for more information. Defaults to **false**. | false
| enable_classiclink_dns_support | A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic. Defaults to **false**. | false
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC. Defaults to **false**. | false
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC. Defaults to **true**. | false
| instance_tenancy | A tenancy option for instances launched into the VPC. Defaults to **default**. | false
| tags | Key-value mapping of default tags for all IAM users. Defaults to **{}**. | false
| private_dns_zone | Private DNS zone name. Defaults to **""**. | false
| set_dhcp_options | Set custom DHCP options for VPC. Defaults to **false**. | false
| dhcp_options_domain_name | The suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file. Defaults to **""**. | false
| dhcp_options_domain_name_servers | List of name servers to configure in /etc/resolv.conf. If you want to use the default AWS nameservers you should set this to AmazonProvidedDNS. Defaults to **[]**. | false
| dhcp_options_ntp_servers | List of NTP servers to configure. Defaults to **[]**. | false
| dhcp_options_netbios_name_servers | List of NETBIOS name servers. Defaults to **[]**. | false
| dhcp_options_netbios_node_type | The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network. Defaults to **2**. | false
| single_nat_gateway | Weather or not to use single NAT gateway. Defaults to **false**. | false
| persistence_subnets | Persistance subnets. List of objects with following parameters: availability_zone, cidr_block, ipv6_cidr_block and tags. Defaults to **[]**. | false
| persistence_subnets_assign_ipv6_address_on_creation | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. Defaults to **false**. | false
| private_subnets | Private subnets. List of objects with following parameters: availability_zone, cidr_block, ipv6_cidr_block and tags. Defaults to **[]**. | false
| private_subnets_assign_ipv6_address_on_creation | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. Defaults to **false**. | false
| public_subnets | Public subnets. List of objects with following parameters: availability_zone, cidr_block, ipv6_cidr_block and tags. Defaults to **[]**. | false
| public_subnets_map_public_ip_on_launch | Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Defaults to **false**. | false
| public_subnets_assign_ipv6_address_on_creation | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. Defaults to **false**. | false
| create_database_subnet_group | Create databse subnet group. Defaults to **false**. | false
| create_elasticache_subnet_group | Create elasticache subnet group. Defaults to **false**. | false
| create_redshift_subnet_group | Create redshift subnet group. Defaults to **false**. | false
| create_persistence_network_acl | Create network ACL for persistance subnets. Defaults to **false**. | false
| persistence_inbound_acl_rules | Persistance subnets inbound network ACL rules. See [variables.tf](https://github.com/svetomir/terraform-aws-vpc/blob/master/variables.tf) for defaults. | false
| persistence_outbound_acl_rules | Persistance subnets outbound network ACL rules. See [variables.tf](https://github.com/svetomir/terraform-aws-vpc/blob/master/variables.tf) for defaults. | false
| create_private_network_acl | Create network ACL for private subnets. Defaults to **false**. | false
| private_inbound_acl_rules | Persistance subnets inbound network ACL rules. See [variables.tf](https://github.com/svetomir/terraform-aws-vpc/blob/master/variables.tf) for defaults. | false
| private_outbound_acl_rules | Persistance subnets outbound network ACL rules. See [variables.tf](https://github.com/svetomir/terraform-aws-vpc/blob/master/variables.tf) for defaults. | false
| create_public_network_acl | Create network ACL for public subnets. Defaults to **false**. | false
| public_inbound_acl_rules | Persistance subnets inbound network ACL rules. See [variables.tf](https://github.com/svetomir/terraform-aws-vpc/blob/master/variables.tf) for defaults. | false
| public_outbound_acl_rules | Persistance subnets outbound network ACL rules. See [variables.tf](https://github.com/svetomir/terraform-aws-vpc/blob/master/variables.tf) for defaults. | false

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of VPC. |
| assign_generated_ipv6_cidr_block | Assign generated IPv6 CIDR block. |
| cidr_block | The CIDR block for the association. |
| default_network_acl_id | Default network ACL ID. |
| default_route_table_id | Default route table ID. |
| default_security_group_id | Default security group ID. |
| dhcp_options_id | DHCP options ID. |
| enable_classiclink | Enable classic link. |
| enable_classiclink_dns_support | Enable classic link DNS support. |
| enable_dns_hostnames | Whether or not the VPC has DNS hostname support. |
| enable_dns_support | Whether or not the VPC has DNS support. |
| id | VPC ID. |
| instance_tenancy | The allowed tenancy of instances launched into the selected VPC. |
| ipv6_association_id | The association ID for the IPv6 CIDR block. |
| ipv6_cidr_block | The IPv6 CIDR block. |
| main_route_table_id | The ID of the main route table associated with this VPC. |
| owner_id | The ID of the AWS account that owns the VPC. |
| route53_zone_private | Private Route53 zone associated with the VPC. |
| vpc_dhcp_options_id | The ID of the DHCP Options Set. |
| vpc_dhcp_options_owner_id | The ID of the AWS account that owns the DHCP options set. |
| internet_gateway_id | The ID of the Internet Gateway. |
| internet_gateway_owner_id | The ID of the AWS account that owns the internet gateway. |
| egress_only_internet_gateway | The ID of the egress-only Internet gateway. |
| eip_nat_gateways | NAT gateway elastic IPs. |
| nat_gateways | NAT gateways. |
| subnets_persistence | Persistence subnets. |
| subnets_private | Private subnets. |
| subnets_public | Public subnets. |
| db_subnet_group_id | The db subnet group name. |
| db_subnet_group_arn | The ARN of the db subnet group. |
| elasticache_subnet_group_description | ElastiCache subnet group description. |
| elasticache_subnet_group_name | ElastiCache subnet group name. |
| elasticache_subnet_group_subnet_ids | ElastiCache subnet group subnet IDs. |
| redshift_subnet_group_id | The Redshift Subnet group ID. |
| redshift_subnet_group_arn | Amazon Resource Name (ARN) of the Redshift Subnet group name. |
| route_tables_persistence | Persistence route tables. |
| route_tables_private | Private route tables. |
| route_tables_public | Public route tables. |
| network_acl_persistence | Persistence network ACL. |
| network_acl_private | Private network ACL. |
| network_acl_public | Public network ACL. |
