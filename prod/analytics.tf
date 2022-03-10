resource "random_password" "master_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "credentials"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = <<EOF
{
  "username": "${aws_db_instance.default.username}",
  "password": "${random_password.master_password.result}",
  "engine": "postgresql",
  "host": "${aws_db_instance.default.endpoint}",
  "port": ${aws_db_instance.default.port},
  "dbInstanceIdentifier": "${aws_db_instance.default.identifier}"
}
EOF
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  max_allocated_storage  = 100
  engine                 = "postgres"
  engine_version         = "13"
  instance_class         = "db.t3.micro"
  db_name                = "analytics"
  username               = "analytics"
  password               = random_password.master_password.result
  identifier             = "analytics"
  parameter_group_name   = "default.postgres13"
  skip_final_snapshot    = true
  apply_immediately      = true
  db_subnet_group_name   = "public-subnet-group"
  vpc_security_group_ids = [aws_security_group.rds_analytics_sg.id]
  publicly_accessible    = true
  storage_encrypted      = true
  multi_az               = false
}

resource "aws_security_group" "rds_analytics_sg" {
  vpc_id = var.vpc_id
  name   = "rds_analytics"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.prod_eks_sg]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["52.25.130.38/32"]
  }
}

resource "aws_route53_record" "analyics-db" {
  zone_id = var.prod_zone_id
  name    = "analytics-db.prod.staircase.ai"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.default.address}"]
}
