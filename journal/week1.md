# Terraform Beginner Bootcamp 2023 - Week 1

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

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables 

In terraform we can set two kind of variables:

- Environment Variables - those you would set in your bash terminal eg. AWS credentials

-Terraform Variables - those that you would normally set in your tfvars file

We can cset Terraform Cloud Variables to be sensitvie so they are not shown visibly in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uid="my-user_uid"`

### var-file flag

- TODO: document this flag

### terraform.tfvars 

This is the default file to load in terraform variables in bulk

### auto.tfvars

- TODO: document this functionality for terraform cloud

### Order of Terraform Variables

- TODO: document which terraform variables take precedence

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

## Considerations when using ChatGPT to write Terrafomr

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