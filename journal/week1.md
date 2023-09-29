# Terraform Beginner Bootcamp 2023 - Week 1

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