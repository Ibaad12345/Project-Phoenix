
# Project Phoenix: Modernizing Legacy Cloud Infrastructure to IaC

## 1. Executive Summary
CloudScale Analytics migrated its core infrastructure from manual, unversioned "click-ops" management in the AWS Console to a 100% automated, production-grade Infrastructure as Code (IaC) model using Terraform and GitHub Actions.

## 2. Business Bottlenecks & Solutions
* **Manual Configuration Drift:** Eliminated by defining all network, compute, and database resources declaratively in Terraform.
* **Public Attack Surface:** Closed SSH ports (`22`) to `0.0.0.0/0`. Instances are isolated in private subnets and managed securely via AWS SSM Session Manager.
* **Hardcoded Credentials:** Replaced plain-text secrets with AWS Secrets Manager and dynamic IAM roles via OpenID Connect (OIDC).
* **Audit & Compliance Risk:** Implemented automated static security scans (Checkov) in CI/CD to enforce SOC 2 security controls.

## 3. Network Architecture
* **VPC:** Multi-AZ (2 Availability Zones) spanning CIDR `10.0.0.0/16`.
* **Public Subnets (`10.0.1.0/24`, `10.0.2.0/24`):** Application Load Balancers (ALB) only.
* **Private Subnets (`10.0.10.0/24`, `10.0.20.0/24`):** Application runtime compute with zero public IPs.
* **Isolated Subnets (`10.0.100.0/24`, `10.0.200.0/24`):** PostgreSQL RDS instances isolated from the internet.

## 4. Repository Structure

## 4. Repository Structure

```text
project-phoenix/
├── README.md                   # Project documentation and architectural overview
├── .gitignore                  # Prevents committing state files, secrets, or logs
├── .github/
│   └── workflows/
│       └── terraform-ci.yml    # CI/CD pipeline (Lint, Validate, Checkov, Plan)
└── terraform/
    ├── bootstrap/              # Provisions S3 bucket & native state locking
    │   ├── main.tf
    │   └── outputs.tf
    ├── modules/                # Reusable Terraform infrastructure modules
    │   ├── vpc/
    │   ├── compute/
    │   └── database/
    └── environments/           # Environment-specific configuration
        └── dev/
            ├── main.tf
            ├── backend.tf
            ├── variables.tf
            ├── outputs.tf
            └── terraform.tfvars
