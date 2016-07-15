variable "api_key" {}
variable "access_key_id" {}
variable "access_key_secret" {}
variable "region" {}
variable "user_data" {}

variable "amis" {
  default = {
    us-east-1 = "ami-fcfd6194"
    us-west-1 = "ami-e44853a1"
    us-west-2 = "ami-d7bde6e7"
    sa-east-1 = "ami-0fce7112"
    eu-west-1 = "ami-9978f6ee"
    eu-central-1 = "ami-22cefd3f"
    ap-southeast-1 = "ami-88bd97da"
    ap-southeast-2 = "ami-eb3542d1"
    ap-northeast-1 = "ami-66233967"
  }
}

resource "template_file" "userdata" {
  template = "${file("${path.module}/userdata.template")}"
  vars {
    access_key = "${var.access_key_id}"
    secret_key = "${var.access_key_secret}"
    api_key = "${var.api_key}"
    user_data = "${var.user_data}"
  }
}

resource "aws_instance" "web" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address=true
  tags {
    Name = "WebPagetest_host"
  }
  user_data = "${template_file.userdata.rendered}"
}
