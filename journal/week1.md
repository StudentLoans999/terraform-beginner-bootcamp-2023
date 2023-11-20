# Terraform Beginner Bootcamp 2023 - Week 1

## Table of Contents

- [Week 1 Livestream](#week-1-livestream)
  - [Week 1 Livestream Agenda](#week-1-livestream-agenda)
- [Root Module Structure](#root-module-structure)
- [Terraform Cloud and Input Variables](#terraform-cloud-and-input-variables)
  - [Terraform Cloud Variables](#terraform-cloud-variables)
  - [Loading Terraform Input Variables](#loading-terraform-input-variables)
  - [`var` flag](#var-flag)
  - [`var-file` flag](#var-file-flag)
  - [`terraform.tfvars`](#terraformtfvars)
  - [`auto.tfvars`](#autotfvars)
- [Dealing with configuration drift](#dealing-with-configuration-drift)
  - [This session's workflow in my Medium blog post]()
  - [What happens if we lose our state file?](#what-happens-if-we-lose-our-state-file)
  - [Fix missing resources with Terraform import](#fix-missing-resources-with-terraform-import)
  - [Fix manual configuration](#fix-manual-configuration)
- [1.4.0 AWS terrahome Module](#aws-terrahome-module)
  - [Passing input variables](#passing-input-variables)
  - [Module sources](#module-sources)
- [1.5.0 Content Delivery Network](#content-delivery-network)
  - [Data Sources](#data-sources)
  - [Terraform locals](#terraform-locals)
  - [Working with JSON](#working-with-json)
- [1 6 0 Content Delivery Network](#1-6-0-content-delivery-network)
  - [Data Sources](#data-sources)
  - [Terraform Locals](#terraform-locals)
  - [Working with JSON](#working-with-json)
- [1.7.0 Invalidate Cache Local Exec](#1-7-0-invalidate-cache-local-exec)
  - [Provisioners](#provisioners)
  - [Local-exec](#local-exec)
  - [Remote-exec](#remote-exec)

## Week 1 Livestream

The commands used throughout this week's stream:

```
# install http-server globally.
npm install http-server -g

# start the http-server.
http-server 

# Upload a single file
aws s3 cp public/index.html s3://YOUR_BUCKET_NAME/index.html

# Upload a folder with multiple files
aws s3 sync public s3://YOUR_BUCKET_NAME

# Check CloudFront list of OACs 
aws cloudfront list-origin-access-controls
aws cloudfront list-origin-access-controls --output table

aws cloudfront list-cloud-front-origin-access-identities


# Bucket policy

{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::nomadiachi-in-terratown-bucket/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::AWS_ACCOUNT_ID:distribution/DISTRIBUTION_ID"
                }
            }
        }
    ]
 }
```

### Week 1 Livestream Agenda

- ✅ 1. Create an S3 bucket to store my static website (and enable the S3 bucket for static website hosting)
- ✅ 2. Create a simple html file to serve as the static website
- ✅ 3. Create a CloudFront distribution and use it to host my html file as a static website

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
|-- variables.tf             # stores the structure of input variables
|-- main.tf                  # everything else
|-- providers.tf             # defined required providers and their configuration
|-- outputs.tf               # stores our outputs
|-- terraform.tfvars         # the data of variables we want to load into our terraform project
|-- README.md                # required for root modules
```

Manually generate the files using the following commands:
```
code outputs.tf
code providers.tf
code terraform.tfvars
code variables.tf
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform Cloud and Input Variables

### Terraform Cloud Variables 

In terraform we can set two kind of variables:

- Environment Variables - those you would set in your bash terminal eg. AWS credentials

- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud Variables to be sensitive so they are not shown visibly in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uid="xyz"

This will override the pre-defined variable in other files:
```
terraform apply -var = "user_uid="my-user_uid"
```

### var-file flag

[Terraform Input Variables - Variable Definitions Files AKA .tfvars](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

`var-file` is a flag used to specify a variable definitions file

```tf
terraform apply -var-file = "testing.tfvars"
```

### terraform.tfvars 

This is the default file to load in terraform variables in bulk

### auto.tfvars

[Terraform Input Variables - .auto.tfvars](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

Files with names ending in `.auto.tfvars`  or `terraform.tfvars` automatically loads all the varaibles set in them (these files are called variable definitions)

### Order of Terraform Variables

[Terraform Input Variables - Variable Definition Precedence](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence)

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

Environment variables
The terraform.tfvars file, if present.
The terraform.tfvars.json file, if present.
Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

## Dealing with Configuration Drift

## What happens if we lose our state file?

If you lose your state file, you most likely have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and deletes or modifies cloud resources manually through ClickOps -

If we run `terraform plan` it will attempt to put our infrastructure back into the expected state, fixing Configuration Drift

## Fix using Terrafrom Refresh

```sh
terraform apply -refresh-only -auto-approve`
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)


Locally delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete a tag
```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated (often affecting providers).

## Working with Files in Terraform

### Fileexists function

https://developer.hashicorp.com/terraform/language/functions/fileexists

This is a built-in terraform function to check the existence of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

### Filemd5 function

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}

## Terraform Locals

Locals allow us to define local variables.
It can be very useful when we need to transform data into another format and have it referenced as a variable.

```tf
locals {
    s3_origin_id = "MyS3Origin"
}
```

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

This allows us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data

```tf
resource "aws_s3_object" "index_html" {
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
  }
}
```

## Provisioners

Provisioners allow you to execute commands on compute instances eg. an AWS CLI command.

They are not recommended for use by Hashicorp becausey Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute commandd on the machine running the terraform commands eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

### Remote=exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

## For Each Expressions

For Each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is useful for when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)
