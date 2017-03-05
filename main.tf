
resource "aws_ecs_cluster" "ecs" {
  name = "${var.name}"
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.yml")}"

  vars {
    name = "${var.name}"
    efs = "${base64encode(data.template_file.efs.rendered)}"
    docker_kickstart = "${base64encode(data.template_file.docker_kickstart.rendered)}"
    kickstart = "${base64encode(data.template_file.kickstart.rendered)}"
    kickstart_init = "${base64encode(data.template_file.kickstart_init.rendered)}"
    cmd_prompt = "${base64encode(data.template_file.cmd_prompt.rendered)}"
    logrotate = "${base64encode(data.template_file.logrotate.rendered)}"
    bashrc = "${base64encode(data.template_file.bashrc.rendered)}"
  }
}

module "ecs_autoscaling_group" {
  source = "github.com/simonluijk/tf_aws_asg"

  ami_id = "${lookup(var.amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.key_name}"
  security_group = "${var.security_group}"
  user_data = "${data.template_file.userdata.rendered}"

  asg_name = "${var.name} ECS Cluster"
  asg_number_of_instances = "${var.asg_instances}"
  asg_minimum_number_of_instances = "${var.asg_minimum_instances}"

  azs = "${var.azs}"
  subnet_azs = "${var.subnets}"

  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"
}


module "ecs_alarms" {
  source = "github.com/simonluijk/tf_asg_alarms"

  asg_name = "${var.name} ECS Cluster"
  actions = ["${var.sns_topic}"]
}
