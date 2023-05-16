data "template_file" "userdata" {
  template = file("${path.module}/scripts/dbt.data")
  }
/*
data "template_cloudinit_config" "config" {
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata.template}"
     }
}
*/
resource "aws_instance" "bastion" {
   instance_type 		= "t2.micro"
   ami 		 		    = "${var.ami_id}"
   subnet_id 			= "${aws_subnet.workload_public[0].id}"
   key_name 			= "${var.bastion_host_key}"
   iam_instance_profile = "${aws_iam_instance_profile.bastion_profile.id}"
   //user_data      = "${data.template_file.userdata.template}"
   user_data_base64     = "${base64encode(data.template_file.userdata.template)}"
   //user_data      = "${data.template_cloudinit_config.config.rendered}"
   associate_public_ip_address 	= true
   disable_api_termination   	= true
   monitoring			= true
   vpc_security_group_ids 	= ["${aws_security_group.dbt_cloud.id}","${aws_default_security_group.default_public_vpc.id}"]

root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.org}-${var.project}-bastion-root-volume"
    }
  }

tags = {
    Name = "${var.org}-${var.project}-bastion"
  }
}

resource "aws_eip" "bastion_host_eip" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
      Name = "${var.org}-${var.project}-bastion-eip"
    }
}