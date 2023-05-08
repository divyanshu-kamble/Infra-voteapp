terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

required_version = ">= 1.2.0"

}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0215d43840f30b7f2"]
  subnet_id              = "subnet-0ec8047a99bd220b4" 

}