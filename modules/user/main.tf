resource "aws_iam_user" "wpt" {
  name = "webpagetest-test"
}

resource "aws_iam_access_key" "wpt" {
  user = "${aws_iam_user.wpt.name}"
}

resource "aws_iam_user_policy" "wpt_ro" {
  name = "EC2FullAccess"
  user = "${aws_iam_user.wpt.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

output "id" { value = "${aws_iam_access_key.wpt.id}" }
output "secret" { value = "${aws_iam_access_key.wpt.secret}" }
