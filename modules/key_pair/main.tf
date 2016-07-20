variable "public_key" {}

resource "aws_key_pair" "key_pair" {
  key_name = "webpagetest"
  public_key = "${var.public_key}"
}
