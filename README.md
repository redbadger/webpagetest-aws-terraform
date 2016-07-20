# AWS-hosted WebPagetest instances through Terraform

[WebPagetest](https://sites.google.com/a/webpagetest.org/docs/) is an invaluable tool for performance profiling web applications. Whilst the [public interface](http://www.webpagetest.org/) is useful, you may require the ability to run your own private instance.

## Rationale

Fortunately, [AWS AMIs are available](https://github.com/WPO-Foundation/webpagetest/blob/master/docs/EC2/Server%20AMI.md) which allow you to quickly spin up your own instance. However, there is some additional setup involved to get the WebPagetest instance fully configured.

### Terraform to the rescue!

This project is made up of some uber simple [Terraform](https://www.terraform.io/) scripts that aim to make infrastructure setup as simple as possible. You can literally spin up an instance in a matter of seconds. It automatically:

* picks the correct [AMI](https://github.com/WPO-Foundation/webpagetest/blob/master/docs/EC2/Server%20AMI.md) based on your chosen region
* [creates an IAM user](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) bound with an [appropriate policy](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) for the required operations.
* adds the specified [instance configuration](https://github.com/redbadger/webpagetest-terraform-aws/blob/master/modules/ec2/userdata.template) as [user data](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html).
The `ec2_key`, `ec2_secret` and `api_key` values are automatically included, allowing the instance to autonomously start and stop test agents, as well as providing a secured REST endpoint.
* Imports an existing SSH key pair and binds it against the created EC2 instance.

If you want to see the setup in more detail, run `terraform get && terraform plan`.

## Usage

The credentials of a current IAM user are required (who has permissions to create an EC2 instance and create an IAM user).

The following variables are understood:
  * `access_key_id` - The access key ID of the above user.
  * `secret_access_key` - The secret access key of the above user.
  * `webpagetest_api_key` *default*: `sad43432reHH434dsad` - An API key used when authenticating against [WebPagetests REST API](https://sites.google.com/a/webpagetest.org/docs/advanced-features/webpagetest-restful-apis).
  * `region` *default*: `eu-west-1` - The [AWS region](http://docs.aws.amazon.com/general/latest/gr/rande.html) you want to create your WebPagetest instance in.
  * `user_data` - The instance settings as per [`settings.ini`](https://github.com/WPO-Foundation/webpagetest/blob/master/www/settings/settings.ini.sample).
  * `public_key_path` - The path to the public key

### Basic Usage

The following steps will install a fully functioning WebPagetest instance (with an auto-assigned Public IP), so you'll be up and running in seconds.

1. Create a [variable file](https://www.terraform.io/docs/configuration/variables.html#variable-files), and add the necessary key value pairs. An example file might look like:
```
access_key_id="43534123123431312"
secret_access_key="w34324231lk21321"
public_key_path="~/.ssh/webpagetest_rsa"
user_data=<<EOF
headless=1
EOF
```
2. Run `./run.sh apply PATH_TO_VAR_FILE`

#### Warning

Both the WebPagetest instance and resulting test agents will be launched into your default VPC in the specified region, resulting in those machines being permitted [**unrestricted inbound and outbound traffic**](https://github.com/redbadger/webpagetest-terraform-aws/issues/3).

It is **your** responsibility to lock-down traffic based on your individual requirements. Furthermore, it is not recommended to manually configure an associated network ACL through the AWS console, as this will lead to a disparity in [Terraform state](https://www.terraform.io/docs/state/).

### Advanced Usage

This project utilises the concept of [Terraform modules](https://www.terraform.io/docs/modules/usage.html), which makes it really easy to compose your own infrastructure out of internal and external modules. For example, you can pull in the WebPagetest `aws_instance` module directly from this repo:

```
...

module "my_webpagetest_ec2" {
  source = "github.com/redbadger/webpagetest-terraform-aws//ec2"
  api_key = "whatever"
  region = "us-east-1"
}

....
```
