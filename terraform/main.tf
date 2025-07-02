#Bloco Principal
terraform {

  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0"
    }
  }

  #Backend para armazenar backup do state localmente
  backend "local" {

    path = "/etc/backups/state.tfstate"

  }
}
#Bloco do provider
provider "aws" {
  region = "us-east-1"
  
}
