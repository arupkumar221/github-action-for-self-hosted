# GitHub Actions Self-Hosted Runner with Terraform on AWS

## 📌 Project Overview

This project demonstrates how to configure a **GitHub Actions Self-Hosted Runner** on an **Amazon Linux 2023 EC2 instance** and use it to deploy AWS infrastructure with **Terraform**.

Unlike `ubuntu-latest`, a self-hosted runner provides a **persistent environment**, so installed tools such as Terraform and AWS CLI remain available between workflow runs.

---

## 🚀 Technologies Used

* GitHub Actions
* Self-Hosted Runner
* Terraform
* AWS EC2
* Amazon Linux 2023
* AWS CLI
* Git

---

## 📁 Project Structure

```text
.
├── .github
│   └── workflows
│       └── deploy.yml
├── main.tf
├── provider.tf
└── README.md
```

---

## 🛠 Prerequisites

* AWS Account
* GitHub Account
* EC2 Instance (Amazon Linux 2023)
* AWS CLI
* Terraform
* Git

---

## ⚙️ Setup Steps

### Step 1: Launch EC2

* Launch Amazon Linux 2023 EC2
* Allow SSH (Port 22)
* Connect using SSH

```bash
ssh -i key.pem ec2-user@<EC2-PUBLIC-IP>
```

---

### Step 2: Install Git

```bash
sudo dnf update -y
sudo dnf install git -y
```

---

### Step 3: Install Terraform

```bash
sudo dnf install unzip wget -y

wget https://releases.hashicorp.com/terraform/1.13.2/terraform_1.13.2_linux_amd64.zip

unzip terraform_1.13.2_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform version
```

---

### Step 4: Configure AWS CLI

```bash
aws configure
```

Provide:

* AWS Access Key
* AWS Secret Access Key
* Region
* Output Format

Verify:

```bash
aws sts get-caller-identity
```

---

### Step 5: Configure GitHub Self-Hosted Runner

Navigate to:

```
Repository
→ Settings
→ Actions
→ Runners
→ New Self-Hosted Runner
```

Download and configure:

```bash
mkdir actions-runner
cd actions-runner

curl -o actions-runner-linux-x64.tar.gz -L <runner-download-url>

tar xzf actions-runner-linux-x64.tar.gz

./config.sh --url <repository-url> --token <runner-token>
```

Start Runner:

```bash
./run.sh
```

Install as a service:

```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

---

## Terraform Configuration

### provider.tf

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

### main.tf

```hcl
resource "aws_instance" "my_ec2" {
  ami           = "ami-08f44e8eca9095668"
  instance_type = "t3.micro"

  tags = {
    Name = "terraform-ec2-arup"
  }
}
```

---

## GitHub Actions Workflow

Location:

```
.github/workflows/deploy.yml
```

```yaml
name: Terraform Deploy

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: self-hosted

    steps:
      - uses: actions/checkout@v4

      - run: terraform init

      - run: terraform plan

      - run: terraform apply -auto-approve
```

---

## Workflow Execution

```text
Developer
     │
     ▼
Git Push
     │
     ▼
GitHub Repository
     │
     ▼
GitHub Actions
     │
     ▼
Self-Hosted Runner (Amazon Linux 2023)
     │
     ├── Terraform Init
     ├── Terraform Plan
     └── Terraform Apply
     │
     ▼
AWS EC2 Instance Created
```

---

## Common Issues

### No valid credential sources found

Cause:

* AWS credentials are not configured for the user running the GitHub runner.

Solution:

```bash
aws configure
aws sts get-caller-identity
```

---

### Runner must not run with sudo

Run the GitHub runner as **ec2-user**, not **root**.

---

### Missing libicu

Install:

```bash
sudo dnf install libicu -y
```

---

## Commands

```bash
terraform init

terraform plan

terraform apply -auto-approve

terraform destroy -auto-approve
```

---

## Future Improvements

* Remote Terraform State (S3 Backend)
* DynamoDB State Locking
* IAM Role Authentication
* Docker Integration
* Kubernetes Deployment
* Multi-Environment Support (Dev, QA, Prod)

---

## Author

**Arup Kumar Dash**

DevOps | AWS | Terraform | GitHub Actions | Jenkins | Linux
