data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "init" {
  template = "${file("init.tpl")}"
}

resource "aws_instance" "web" {
	instance_type = "${var.aws_instance_type}"
	ami           = "${data.aws_ami.ubuntu.id}" # ami-0c5199d385b432989
	key_name      = "${aws_key_pair.deployer.key_name}"
	user_data     = "${data.template_file.init.rendered}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}", "${aws_security_group.allow_web.id}"]

	tags = "${merge(
			var.common_tags,
			map(
				"Name", "Web"
			)
	)}"

  provisioner "file" {
    source      = "provisioner/chef/cookbooks"
    destination = "/home/ubuntu"

	  connection {
			user = "ubuntu"
		}
  }

  provisioner "remote-exec" {
		inline = [
       "echo 'Waiting for cloud-init to finish...' && cloud-init status --wait",
			 "sudo sh -c 'chef-client -z -o base | tee /tmp/chefrun.log'",
       "GIT_SSH_COMMAND=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no\" git clone git@gitlab.com:zdk/shipping-track-api.git",
			 "cd shipping-track-api && npm install && screen -d -m npm start",
			 "sleep 1"
		]

	  connection {
			type = "ssh"
			user = "ubuntu"
			private_key = "${file(pathexpand("~/.ssh/<domain>/aws/demo/deployer"))}"
		}
  }

  provisioner "local-exec" {
    working_dir = "./www/shipping-track-frontend"
    command = "npm install && npm run build && scp -o stricthostkeychecking=no -r ./build/. ubuntu@${self.public_ip}:/var/www/frontend"
  }

	provisioner "local-exec" {
		command = "./update_dns.sh ${self.public_ip}"
	}

}
