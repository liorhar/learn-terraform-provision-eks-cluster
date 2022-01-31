
resource "aws_security_group" "eks_workers_group_default" {
  name_prefix = "eks_workers_group_default"
  vpc_id      = module.vpc.vpc_id

  # ingress {
  #   from_port = 22
  #   to_port   = 22
  #   protocol  = "tcp"

  #   cidr_blocks = [
  #     "10.0.0.0/8",
  #   ]
  # }
}

resource "aws_security_group" "twingate_connector_outbound" {
  vpc_id = module.vpc.vpc_id
  name  = "twingate_egress"

  egress {
    from_port = 30000
    to_port = 31000   
    protocol         = "-1" 
  }

  egress {
    description      = "TLS from connector"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
  }
  
}
