# Terraform Beginner Bootcamp 2023 - Week 0

## Table of Contents

- [Terraform Syncing with Github](#erraform-syncing-with-github)
- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  - [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
  - [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  - [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    - [Shebang Considerations](#shebang-considerations)
    - [Execution Considerations](#execution-considerations)
    - [Linux Permissions Considerations](#linux-permissions-considerations)
- [GitHub Lifecycle - Before, Init, Command](#github-lifecycle---before-init-command)
- [Working with Env Vars](#working-env-vars)
    - [env command](#env-command)
    - [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
    - [Printing Vars](#printing-vars)
    - [Scoping of Env Vars](#scoping-of-env-vars)
    - [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  - [Terraform Registry](#terraform-registry)
  - [Terraform Console](#terraform-console)
    - [Terraform Init](#terraform-init)
    - [Terraform Plan](#terraform-plan)
    - [Terraform Apply](#terraform-apply)
    - [Terraform Destroy](#terraform-destroy)
    - [Terraform Lock Files](#terraform-lock-files)
    - [Terraform State Files](#terraform-state-files)
    - [Terraform Directory](#terraform-directory)
- [AWS S3 Terraform](#aws-s3-terraform)
  - [AWS S3 Bucket Naming](#aws-s3-bucket-naming)
- [Launching Terraform Cloud integration with CLI-driven workflow](#launching-terraform-cloud-integration-with-cli-driven-workflow)
- [Issues with Terraform Cloud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)
- [TF alias for Terraform](#tf-alias-for-terraform)

## Terraform Syncing with Github

At the beginning of an update to files, go to Gihub and create a new Issue (make a checklist inside of it), and make a new branch from it.

Then switch to that branch in Code, and open up a new Gitpod session.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

At the end of a Gitpod session when you want to apply changes, commit the Source Control file changes in Gitpod, then Sync Changes.

Next, go to Github and check off the completed steps in the Issue, and then create a new Pull Request with the branch you were working on in Gitpod (usually the latest one).

Check Code for the latest tag version, then go back to Gitpod and apply a new tag that syncs back to Github by doing the following:

```sh
git checkout main
git pull
git tag #.#.#
git push --tags
```

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

Given a version number **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward-compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed to refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu.
Please consider checking your Linux Distribution and change accordingly to distribution needs.

[How to Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:

```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we noticed that the bash scripts steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: ([/bin/install_terraform_cli](/bin/install_terraform_cli))

- This will keep the Gitpod Task File ([/.gitpod.yml](/.gitpod.yml)) tidy.
- This will allow an easier time to debug and execute manually Terraform CLI install.
- This will allow better portability for other projects that need to install Terraform CLI.

### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the bash script what program will interpret the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- for portability for different OS distributions
- will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

### Execution Considerations
When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

### Linux Permissions Considerations

In order to make our bash scripts executable we need to change the Linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:
```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

## GitHub Lifecycle - Before, Init, Command

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

[Configure gitpod workspaces](https://www.gitpod.io/docs/configure/workspaces/tasks)

## Working with Env Vars

### env command

We can list out all Environment Variables (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command 

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

### Scoping of Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg `/bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.

## AWS CLI Installation

AWS CLI is installed for the project via the bash script ([/bin/install_aws_cli](/bin/install_aws_cli))

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that looks like this:

```json
{
    "UserId": "AIDGTMXZIMEX3BEUMTBUS",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credentials from IAM User in order to use the AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow you to create resources in terraform. (Interact directly with.)
- **Modules** are a way to make large amounts of terraform code modular, portable, and shareable. (Templates.) Containers for multiple resources that are used together. A module consists of a collection of `.tf` and/or `.tf.json` files kept together in a directory. Modules are the main way to package and reuse resource configurations with terraform.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

- [Official Terraform Registry](https://registry.terraform.io/)
- [More on Terraform `random` provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- [Terraform AWS documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`

### Terraform Init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

Generates an overview of what is going to change from the current set of resources.

### Terraform Apply

`terraform apply`

This will run a `terraform plan` and pass the changeset to be executed by terraform. Apply should prompt yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto=approve`

(Executes the provisioning of the resources.)

### Terraform Destroy

`terraform destroy`

This will destroy all the resources that were created. (The safest way to get rid of resources; don't clean up manually.)

You can also use the auto approve flag to skip the approval prompt eg. `terraform destroy --auto-approve`

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VSC) eg. Github

### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be committed** to your VCS.

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

### **Terraform Commands**

**Main commands:**
- `init`          Prepare your working directory for other commands  
- `validate`      Check whether the configuration is valid  
- `plan`          Show changes required by the current configuration  
- `apply`         Create or update infrastructure  
- `destroy`       Destroy previously-created infrastructure  

**All other commands:**
- `console`       Try Terraform expressions at an interactive command prompt 
- `fmt`           Reformat your configuration in the standard style  
- `force-unlock`  Release a stuck lock on the current workspace  
- `get`           Install or upgrade remote Terraform modules  
- `graph`         Generate a Graphviz graph of the steps in an operation  
- `import`        Associate existing infrastructure with a Terraform resource  
- `login`         Obtain and save credentials for a remote host  
- `logout`        Remove locally-stored credentials for a remote host  
- `metadata`      Metadata related commands  
- `output`        Show output values from your root module  
- `providers`     Show the providers required for this configuration  
- `refresh`       Update the state to match remote systems  
- `show`          Show the current state or a saved plan  
- `state`         Advanced state management  
- `taint`         Mark a resource instance as not fully functional  
- `test`          Experimental support for module integration testing  
- `untaint`       Remove the 'tainted' state from a resource instance  
- `version`       Show the current Terraform version  
- `workspace`     Workspace management  

## AWS S3 Terraform

### AWS S3 Bucket Naming

We had to change the parameters in the bucket_name resource in ([/main.tf](/main.tf)) to only have lowercase letters (also increased the length just to make sure the name was globally unique).

## Launching Terraform Cloud integration with CLI-driven workflow

- Terraform Workspace: a container in Terraform Cloud for infrastructure state, configurations, and settings. 
- Terraform Project: an overarching effort or goal, potentially consisting of multiple Terraform Cloud Workspaces.

Created a Workspace in [app.terraform.io](https://app.terraform.io/app/david_richey/workspaces/terra-house-1) and followed the steps in the CLI-driven runs section by editing the ([/main.tf](/main.tf))

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will launch bash in a winswig view to generate a token. However, it does not work as expected in Gitpod VSCode in the browser.

The workaround is to manually generate a token in the Terraform Cloud console
```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create and open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

We have automated this workaround with the following bash script ([/bin/generate_tfrc_credentials](/bin/generate_tfrc_credentials))

## TF alias for Terraform

Set an alias for terraform to be tf in our bash profile.

`open ~/.bash_profile` in console
`alias tf="terraform"` in the opened file

Then created this bash script to make sure it is always set ([/bin/set_tf_alias](/bin/set_tf_alias))

Edited ([/.gitpod.yml](/.gitpod.yml)) to have `source ./bin/set_tf_alias` in both bash environemnts
