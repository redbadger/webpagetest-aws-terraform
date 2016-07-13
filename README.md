# AWS-hosted WebPagetest instances through Terraform

[WebPagetest](https://sites.google.com/a/webpagetest.org/docs/) is an invaluable tool for performance profiling web applications. Whilst the [public interface](http://www.webpagetest.org/) is useful, you may require the ability to run your own private instance.

## Rationale

Fortunately, [AWS AMIs are available](https://github.com/WPO-Foundation/webpagetest/blob/master/docs/EC2/Server%20AMI.md) which allow you to quickly spin up your own instance. However, there is some additional setup involved to get the WebPagetest instance fully configured.

### Terraform to the rescue!

This project is made up of some uber simple [Terraform](https://www.terraform.io/) scripts that aim to make infrastructure setup as simple as possible. You can literally spin up an instance in a matter of seconds. It automatically:

* picks the correct [AMI](https://github.com/WPO-Foundation/webpagetest/blob/master/docs/EC2/Server%20AMI.md) based on your chosen region
* [creates an IAM user](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) bound with an [appropriate policy](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) for the required operations.
* adds the specified [instance configuration](https://github.com/redbadger/webpagetest-terraform-aws/blob/master/modules/ec2/userdata.template) as [user data](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html).

## Getting started
1. Install [Terraform](https://www.terraform.io/)
2. `terraform get && terraform apply \
      -var access_key_id=YOUR_ACCESS_KEY_ID \
      -var secret_access_key=YOUR_SECRET_ACCESS_KEY`
3. Watch as your setup magically configures itself.

### Allowed variables
The credentials of a current IAM user are required (who has permissions to create an EC2 instance and create an IAM user).
  * `access_key_id` - The access key ID of the above user.
  * `secret_access_key` - The secret access key of the above user.
  * `webpagetest_api_key` (defaults to `sad43432reHH434dsad`) - An API key used when authenticating against [WebPagetests REST API](https://sites.google.com/a/webpagetest.org/docs/advanced-features/webpagetest-restful-apis).
  * `region` - The [AWS region](http://docs.aws.amazon.com/general/latest/gr/rande.html) you want to create your WebPagetest instance in.

### Security Warning

Both the WebPagetest main instance and resulting test agents will be launched into your default VPC in the specified region, resulting in those machines [accepting **unrestricted inbound HTTP traffic**](https://github.com/redbadger/webpagetest-terraform-aws/issues/3). This will be getting fixed soon.
