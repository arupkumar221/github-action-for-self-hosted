terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-08f44e8eca9095668"   # Amazon Linux 2023 (us-east-1)
  instance_type = "t3.micro"

  tags = {
    Name = "terraform-ec2-arup"
  }
}
