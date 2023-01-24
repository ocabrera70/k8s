locals {
  cluster_name             = "eks-acg-${random_string.suffix.result}"
  node_group_ondemand_name = "node-group-ondemand-acg-${random_string.suffix.result}"
  node_group_spot_name     = "node-group-spot-acg-${random_string.suffix.result}"
  azs                      = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}