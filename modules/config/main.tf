variable "key_path" {}

output "public_key" { value = "${file("${var.key_path}")}" }
