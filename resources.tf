
data "template_file" "efs" {
    template = "${file("${path.module}/resources/efs/kickstart.sh")}"

    vars {
      filesystem_name = "${var.filesystem_name}"
    }
}


data "template_file" "docker_kickstart" {
    template = "${file("${path.module}/resources/docker/kickstart.sh")}"
}


data "template_file" "kickstart" {
    template = "${file("${path.module}/resources/general/kickstart.sh")}"
}

data "template_file" "kickstart_init" {
    template = "${file("${path.module}/resources/general/kickstart_init.sh")}"
}


data "template_file" "cmd_prompt" {
    template = "${file("${path.module}/resources/general/cmd-prompt.sh")}"
}


data "template_file" "logrotate" {
    template = "${file("${path.module}/resources/general/logrotate.conf")}"
}


data "template_file" "bashrc" {
    template = "${file("${path.module}/resources/general/bashrc.sh")}"
}
