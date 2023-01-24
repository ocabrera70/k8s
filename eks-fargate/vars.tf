#region General Variables
variable "region" {
  type    = string
  default = "us-east-2"
}

variable "azs" {
  type    = list(string)
  default = []
}

#endregion


#EKS Node Group Capacity Type

variable "eks_version" {
  type    = string
  default = "1.23"
}

#endregion



