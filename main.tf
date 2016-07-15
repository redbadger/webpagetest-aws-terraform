variable "access_key_id" {}
variable "secret_access_key" {}
variable "webpagetest_api_key" { default = "sad43432reHH434dsad" }
variable "region" { default = "eu-west-1" }
variable "user_data" {}

provider "aws" {
  region = "${var.region}"
  secret_key = "${var.secret_access_key}"
  access_key = "${var.access_key_id}"
}

module "webpagetest_ec2" {
  source="./modules/ec2"
  access_key_id="${module.webpagetest_user.id}"
  access_key_secret="${module.webpagetest_user.secret}"
  api_key="${var.webpagetest_api_key}"
  region="${var.region}"
  user_data="${var.user_data}"
}

module "webpagetest_user" {
  source="./modules/user"
}
