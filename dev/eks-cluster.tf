module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "dev-cluster"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = "arn:aws:kms:eu-central-1:311884680213:key/050a3b60-a3b6-4f20-8ad1-9949e31d1666"
    resources        = ["secrets"]
  }]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 50
    instance_types         = ["t3.small", "t3.large"]
    vpc_security_group_ids = [aws_security_group.eks_workers_group_default.id, aws_security_group.twingate_connector_outbound.id]
  }

  eks_managed_node_groups = {
    small = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      labels = {
        Environment = "dev"
        GithubRepo  = "terraform"
        GithubOrg   = "staircaseai"
      }
      # taints = {
      #   dedicated = {
      #     key    = "dedicated"
      #     value  = "gpuGroup"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
      # tags = {
      #   ExtraTag = "example"
      # }
    }
  }


}