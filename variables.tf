variable "name" {}
variable "instance_type" {}

variable "asg_instances" {}
variable "asg_minimum_instances" {
  default = "1"
}

variable "subnets" {}
variable "azs" {}

variable "key_name" {}
variable "iam_instance_profile" {}
variable "security_group" {}
variable "sns_topic" {}

variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "filesystem_name" {}

/*
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
*/
variable "amis" {
  type = "map"
  default = {
    "us-west-2" = "ami-022b9262"
    "eu-west-1" = "ami-a7f2acc1"
  }
}
