terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.32.0"
    }
  }
  backend "remote" {
    organization = "kwiniaskaridge"
    workspaces {
      name = "website-org"
    }
  }
}

data "terraform_remote_state" "zones" {
  backend = "remote"
  config = {
    organization = "kwiniaskaridge"
    workspaces = {
      name = "dns"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "redirects" {
  for_each            = data.terraform_remote_state.zones.outputs.zones
  source              = "./redirects"
  zone                = each.value.hosted-zone
  core-website-domain = "www.${data.terraform_remote_state.zones.outputs.zones["org"].hosted-zone.name}"
}
