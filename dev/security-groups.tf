
  resource "aws_security_group" "eks_workers_group_default" {
  name_prefix = "eks_workers_group_default"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port = 5432
    to_port = 5432   
    protocol         = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "twingate_connector_outbound" {
  vpc_id = module.vpc.vpc_id
  name  = "twingate_egress"

  egress {
    from_port = 30000
    to_port = 31000   
    protocol         = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "TLS from connector"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "rds_dev_copy_sg" {
  
  type              = "ingress"
  security_group_id = "sg-0d6e99ce3e5e835ce"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  description = "eks dev access"
  source_security_group_id = aws_security_group.eks_workers_group_default.id
}

# output "eks_node_security_group_id" {
#     value = aws_security_group.eks_workers_group_default.id
# }