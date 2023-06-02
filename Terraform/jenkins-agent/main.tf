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

resource "aws_instance" "jenkins-agent" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0215d43840f30b7f2"]
  subnet_id              = "subnet-0ec8047a99bd220b4" 
  key_name = "testing-test"
  user_data = "${file("files/script.sh")}"

}

output "instance_public_ip" {
  value = aws_instance.jenkins-agent.public_ip
}

resource "aws_security_group_rule" "public_out1" {

  type        = "ingress"

  from_port   = 5000

  to_port     = 5000

  protocol    = "tcp"

  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = element(tolist(data.aws_security_groups.test.ids), 0)
  

}