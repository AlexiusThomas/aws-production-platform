# AWS Production Platform

A production-style Infrastructure as Code (IaC) project that demonstrates how to design, provision, and manage secure, scalable AWS infrastructure using Terraform and modern DevOps practices.

This project is being built from the ground up following the same architectural patterns used by professional Cloud Infrastructure, Platform Engineering, and DevOps teams.

---

# Project Goals

This repository demonstrates practical experience with:

- Infrastructure as Code (Terraform)
- Modular Terraform architecture
- AWS networking
- Production VPC design
- Public and private subnet architecture
- ECS Fargate
- Docker
- Application Load Balancers
- IAM
- CloudWatch Monitoring
- GitHub Actions CI/CD
- Secrets Manager
- Infrastructure automation
- High Availability design
- Security best practices

---

# Current Progress

## ✅ Phase 1 — Project Foundation

Completed

- Repository created
- GitHub connected
- Terraform installed
- AWS CLI configured
- AWS Provider configured
- IAM deployment user created
- Modular Terraform project structure created
- Initial Terraform validation completed

---

## ✅ Phase 2 — Production VPC

Completed

- Reusable Terraform VPC module
- Production VPC deployed
- CIDR Block: `10.0.0.0/16`
- DNS Support enabled
- DNS Hostnames enabled
- Modular outputs
- Infrastructure successfully deployed using Terraform

---

# Planned Infrastructure

The completed environment will include:

- Production VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- ECS Cluster
- ECS Fargate Services
- Dockerized Application
- Application Load Balancer
- IAM Roles
- CloudWatch Monitoring
- Secrets Manager
- GitHub Actions CI/CD Pipeline

---

# Planned Architecture

```text
                     Internet
                         │
                         ▼
              Application Load Balancer
                         │
        ┌────────────────┴────────────────┐
        │                                 │
 Public Subnet A                  Public Subnet B
        │                                 │
        └────────────────┬────────────────┘
                         │
              ECS Fargate Services
                         │
        ┌────────────────┴────────────────┐
        │                                 │
 Private Subnet A                 Private Subnet B
                         │
                  CloudWatch Logs
```

---

# Repository Structure

```text
aws-production-platform/
│
├── app/
├── docker/
├── terraform/
│   ├── environments/
│   ├── modules/
│   │   └── vpc/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── versions.tf
│
└── README.md
```

---

# Technologies

### Cloud

- Amazon Web Services (AWS)

### Infrastructure as Code

- Terraform

### Containers

- Docker
- Amazon ECS Fargate

### Networking

- Amazon VPC
- Public & Private Subnets
- Route Tables
- Internet Gateway
- NAT Gateway
- Security Groups

### Monitoring

- Amazon CloudWatch

### CI/CD

- GitHub Actions

### Security

- IAM
- AWS Secrets Manager

---

# Learning Objectives

This project is designed to demonstrate real-world cloud engineering skills rather than simply provisioning AWS resources.

Each phase focuses on understanding:

- Why the architecture exists
- How AWS services interact
- Infrastructure design decisions
- Security best practices
- Scalability
- High availability
- Automation
- Production deployment strategies

---

# Project Milestones

| Phase | Status |
|--------|--------|
| Project Foundation | ✅ Complete |
| Terraform Setup | ✅ Complete |
| Production VPC | ✅ Complete |
| Public Subnets | ⏳ In Progress |
| Private Subnets | ⏳ Planned |
| Internet Gateway | ⏳ Planned |
| NAT Gateway | ⏳ Planned |
| Route Tables | ⏳ Planned |
| Security Groups | ⏳ Planned |
| ECS Cluster | ⏳ Planned |
| Docker Application | ⏳ Planned |
| Load Balancer | ⏳ Planned |
| GitHub Actions | ⏳ Planned |
| CloudWatch Monitoring | ⏳ Planned |

---

# Author

**Alexius Thomas**

Cloud Infrastructure Engineer with a focus on AWS, Infrastructure Engineering, Platform Engineering, DevOps, and scalable cloud architecture.

- LinkedIn: https://linkedin.com/in/alexiusvictoria
- GitHub: https://github.com/AlexiusThomas