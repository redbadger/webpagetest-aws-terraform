resource "aws_s3_bucket" "wpt" {
  bucket = "webpagetest-state"
  acl = "private"
}
