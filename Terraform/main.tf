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

resource "aws_key_pair" "testing" {
  public_key = file("~/.ssh/id_rsa.pub")
  key_name = "testing-test"
}

resource "aws_instance" "app_server" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0215d43840f30b7f2"]
  subnet_id              = "subnet-0ec8047a99bd220b4" 
  key_name = "testing-test"

}

data "aws_security_groups" "test" {

  tags = {
    name = "tf-deploy"
  }
}


resource "aws_security_group_rule" "public_out" {

  type        = "ingress"

  from_port   = 5000

  to_port     = 5000

  protocol    = "http"

  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = [data.aws_security_groups.test.ids]

}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}



# resource "local_file" "app_server" {
#     content  = aws_instance.app_server.public_ip
#     filename = "app_server.txt"

# }

# resource "github_repository_file" "example" {
#   repository = "divyanshu-kamble/infra_voteapp"
#   branch     = "YOUT-17-Create-EC2-instance-with-Terraform"
#   file       = "./Ansible-script/"
#   content    = file("app_server.txt")
#   message    = "Add new file from local source"
# }
# resource "github_repository_file" "workflow_assign_issues" {
#   repository          = infra_voteapp
#   branch              = "YOUT-17-Create-EC2-instance-with-Terraform"
#   commit_message      = "modified inventory file"
#   overwrite_on_create = true
#   file                = ".github/workflows/organize-assign-issues.yml"
#   content             = data.local_file.workflow_assign_issues.content
# }
