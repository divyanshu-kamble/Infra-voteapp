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

# resource "aws_key_pair" "testing" {
#   public_key = file("~/.ssh/id_rsa.pub")
#   key_name = "testing-test"
# }
resource "aws_iam_user" "testing" {
  name = "testing-user"
    tags = {
    use = "tesing"
  }
}

data "user_arn" "testing_arn" {  
  value = aws_iam_user.testing.*.arn
}

resource "aws_iam_user_policy" "testing-policy" {
  name = "test-policy"
  user = aws_iam_user.testing.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
          {
      "Sid": "EC2InstanceActions",
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:RebootInstances",
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ],
      "Resource": "arn:aws:ec2:*:*:instance/*"
    },
    {
      "Sid": "EC2SecurityGroupActions",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ],
      "Resource": "arn:aws:ec2:*:*:security-group/*"
    },
    {
      "Sid": "EC2SubnetActions",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSubnet",
        "ec2:DeleteSubnet",
        "ec2:ModifySubnetAttribute",
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ],
      "Resource": "arn:aws:ec2:*:*:subnet/*"
    }
  ]
})
}

#*? EC2 INSTANCE WITH PLACEMENT GROUP 
resource "aws_instance" "DEV" {
  name = "testing-EC2"
  ami           = data.user_arn.testing_arn.value
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0215d43840f30b7f2"]
  subnet_id              = "subnet-0ec8047a99bd220b4" 
  key_name = "testing-test"
  user_data = "${file("files/script.sh")}"
  placement_group = "test-placement" 

}

#? EBS VOLUME CREATION
resource "aws_ebs_volume" "testing-ebs-vol" {
  availability_zone = "us-east-1"
  size              = 1
  encrypted = true

  tags = {
    Name = "HelloWorld"
  }
}

#? EBS VOLUME ATTACHMENT
resource "aws_volume_attachment" "testing-ebs-attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.testing-ebs-vol.id
  instance_id = aws_instance.DEV.id 
  skip_destroy = false
}


#? SECURITY GROUP OUTPUT
data "aws_security_groups" "test" {

  tags = {
    Name = "tf-deploy"
  }
}

#*? OUTPUT OF SECURITY GROUP
output "security_group_id" {
  value = data.aws_security_groups.test.ids
}

#*? PLACEMENT GROUP CREATION
resource "aws_placement_group" "testin-placement-grp" {
  name     = "test-placement"
  strategy = "cluster"
}

#*? PUBLIC IP ADDRESS OUTPUT
output "instance_public_ip" {
  value = aws_instance.DEV.public_ip
}


#** THIS IS THE ORIGNAL CODE
# resource "aws_instance" "DEV" {
#   ami           = "ami-007855ac798b5175e"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = ["sg-0215d43840f30b7f2"]
#   subnet_id              = "subnet-0ec8047a99bd220b4" 
#   key_name = "testing-test"
#   user_data = "${file("files/script.sh")}"

# }

#** THIS IS THE ORIGNAL CODE
# data "aws_security_groups" "test" {

#   tags = {
#     Name = "tf-deploy"
#   }
# }

#** THIS IS THE ORIGNAL CODE
# resource "aws_security_group_rule" "public_out1" {

#   type        = "ingress"

#   from_port   = 9000

#   to_port     = 9000

#   protocol    = "tcp"

#   cidr_blocks = ["0.0.0.0/0"]

#   security_group_id = element(tolist(data.aws_security_groups.test.ids), 0)
  

# }

#** THIS IS THE ORIGNAL CODE
# output "instance_public_ip" {
#   value = aws_instance.DEV.public_ip
# }

