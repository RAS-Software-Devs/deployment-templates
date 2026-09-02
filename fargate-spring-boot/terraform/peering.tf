variable "rds_vpc_id" {
  description = "VPC ID where the shared RDS instance lives"
  type        = string
  default     = "vpc-05691479aa0417b46"
}

variable "rds_vpc_cidr" {
  description = "CIDR block of the RDS VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "rds_security_group_id" {
  description = "Security group attached to the RDS instance, to allow inbound access from the Fargate VPC"
  type        = string
  default     = "sg-0148cf083e45359fb"
}

data "aws_vpc" "rds" {
  id = var.rds_vpc_id
}

data "aws_route_tables" "rds" {
  vpc_id = var.rds_vpc_id
}

resource "aws_vpc_peering_connection" "fargate_to_rds" {
  vpc_id      = aws_vpc.main.id
  peer_vpc_id = var.rds_vpc_id
  auto_accept = true
  tags        = { Name = "${var.task_family}-fargate-to-rds" }
}

# Routes from every route table in the RDS VPC back to the Fargate VPC
resource "aws_route" "rds_to_fargate" {
  for_each                  = toset(data.aws_route_tables.rds.ids)
  route_table_id            = each.value
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.fargate_to_rds.id
}

# Allow the Fargate VPC's CIDR to reach Postgres on the RDS security group
resource "aws_security_group_rule" "rds_from_fargate" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = var.rds_security_group_id
  description       = "Postgres access from the Fargate VPC (${var.task_family})"
}
