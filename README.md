# AWS Production Platform

[![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform)](https://developer.hashicorp.com/terraform)
[![AWS](https://img.shields.io/badge/Cloud-AWS-232F3E?logo=amazonaws)](https://aws.amazon.com/)
[![Docker](https://img.shields.io/badge/Containers-Docker-2496ED?logo=docker)](https://www.docker.com/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?logo=githubactions)](https://github.com/features/actions)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

AWS Production Platform is a production-style cloud platform demonstrating how infrastructure, containerized applications, CI/CD automation, networking, security, and operational validation work together on AWS.

The platform provisions AWS infrastructure using **Terraform**, builds and versions a **Dockerized Python application**, stores container images in **Amazon ECR**, runs the application using **Amazon ECS**, distributes traffic through an **Application Load Balancer**, and automatically deploys application changes through **GitHub Actions**.

The project was designed around an operational engineering principle:

**Build → Validate → Deploy → Observe → Troubleshoot → Recover → Improve**

---

## Problem

Deploying an application manually creates several operational risks:

- Inconsistent infrastructure
- Configuration drift
- Manual deployment errors
- Long-lived cloud credentials
- Limited deployment traceability
- Difficult troubleshooting
- Inconsistent application versions
- Limited deployment verification

A production platform needs more than infrastructure that simply launches successfully.

It should provide a repeatable process for:

- Provisioning infrastructure
- Building applications
- Versioning artifacts
- Authenticating securely
- Deploying changes
- Verifying service health
- Troubleshooting failures
- Recovering from unsuccessful deployments

---

## Solution

I built an automated AWS container platform using:

- **Terraform** for Infrastructure as Code
- **Amazon VPC** for network isolation
- **Amazon ECS** for container orchestration
- **Amazon ECR** for container image storage
- **Application Load Balancer** for application traffic
- **Docker** for application packaging
- **GitHub Actions** for CI/CD automation
- **GitHub OIDC** for keyless AWS authentication
- **AWS IAM** for deployment permissions
- **Python/Flask** for the application
- **Health checks** for deployment verification

Every push to the `main` branch can trigger the automated application deployment workflow.

---

# Architecture

```text
                         Developer
                             |
                             v
                     GitHub Repository
                             |
                             v
                      GitHub Actions
                             |
                    OIDC Authentication
                             |
                             v
                       AWS IAM Role
                             |
                 +-----------+-----------+
                 |                       |
                 v                       v
          Build Docker Image        AWS Infrastructure
                 |                    Terraform
                 v
            Amazon ECR
                 |
                 v
            Amazon ECS
                 |
                 v
             ECS Tasks
                 ^
                 |
       Application Load Balancer
                 ^
                 |
               Users
```

Terraform manages the AWS infrastructure while GitHub Actions manages the application deployment workflow.

---

# CI/CD Deployment Pipeline

The deployment workflow follows:

```text
Push to main
     |
     v
Checkout Repository
     |
     v
Request GitHub OIDC Token
     |
     v
Assume AWS IAM Deployment Role
     |
     v
Authenticate to Amazon ECR
     |
     v
Build Docker Image
     |
     v
Tag Image
   /     \
latest   Git SHA
   \     /
     v
Push to Amazon ECR
     |
     v
Deploy to Amazon ECS
     |
     v
Wait for ECS Service Stability
     |
     v
Verify Deployment
```

This provides a repeatable deployment path from source code to running AWS infrastructure.

---

# Key Engineering Features

## Infrastructure as Code

Terraform manages the AWS infrastructure through reusable modules.

Infrastructure changes are version controlled and can be reviewed before deployment.

```bash
terraform init
terraform plan
terraform apply
```

This reduces dependence on manual AWS console configuration and improves repeatability.

---

## Containerized Application Deployment

The Python application is packaged into a Docker image.

```bash
docker build -t aws-production-platform ./app
```

The same container artifact can be tested locally and deployed through Amazon ECS.

This reduces differences between development and deployment environments.

---

## Immutable Image Versioning

Each deployment publishes Docker images using:

- `latest`
- Full Git commit SHA

Example:

```text
latest
8c9182fbefdc781e28c59967a1605f19783f191b
```

The Git SHA creates traceability between:

**Source Code → Container Image → Deployment**

If an operational issue occurs, the deployed artifact can be associated with the exact source revision that produced it.

---

## Keyless AWS Authentication

GitHub Actions authenticates to AWS using **OpenID Connect (OIDC)**.

The workflow assumes an AWS IAM deployment role instead of storing permanent AWS access keys in GitHub.

```text
GitHub Actions
      |
      | OIDC Token
      v
AWS IAM Trust Policy
      |
      v
Temporary AWS Credentials
```

This reduces the security risk associated with long-lived cloud credentials.

---

## Deployment Stability Verification

The deployment pipeline does not stop after requesting an ECS deployment.

It waits for the ECS service to report a stable state.

This is an important operational distinction:

**Deployment initiated ≠ deployment successful**

The workflow verifies that the service reaches a stable state before considering the deployment complete.

---

# AWS Services

| AWS Service | Purpose |
|---|---|
| Amazon VPC | Provides network isolation |
| Public Subnets | Host internet-facing infrastructure |
| Private Subnets | Isolate application workloads |
| Internet Gateway | Provides public internet connectivity |
| NAT Gateway | Provides outbound connectivity for private resources |
| Route Tables | Control network routing |
| Security Groups | Control network access |
| Application Load Balancer | Routes application traffic |
| Amazon ECS | Runs and manages containerized workloads |
| Amazon ECR | Stores versioned Docker images |
| AWS IAM | Controls deployment permissions |
| GitHub OIDC / IAM | Provides keyless CI/CD authentication |

---

# Terraform Architecture

Infrastructure is separated into reusable modules.

```text
terraform/
├── backend.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── versions.tf
├── environments/
│   └── dev/
└── modules/
    ├── alb/
    ├── ecr/
    ├── ecs/
    ├── ecs-service/
    ├── github-oidc/
    └── networking/
```

## Networking Module

Manages:

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- NAT Gateway
- Route tables
- Security groups

## ALB Module

Manages:

- Application Load Balancer
- Target group
- Listener
- Load balancer outputs

## ECR Module

Creates the container repository used by the deployment pipeline.

## ECS Module

Creates the ECS cluster.

## ECS Service Module

Manages:

- ECS service
- Application task deployment
- Networking integration
- Load balancer integration

## GitHub OIDC Module

Manages:

- AWS OIDC identity provider
- IAM deployment role
- GitHub trust relationship
- Deployment permissions

---

# Application Health Checks

The application exposes:

```text
/
```

Example:

```json
{
  "application": "AWS Production Platform",
  "environment": "dev",
  "status": "running"
}
```

The application also provides:

```text
/health
```

Example:

```json
{
  "status": "healthy"
}
```

The health endpoint allows infrastructure components and operators to determine whether the application is responding successfully.

---

# Deployment Verification

The platform has been validated through:

- Successful GitHub Actions execution
- Successful AWS OIDC role assumption
- Successful authentication to Amazon ECR
- Docker image creation
- ECR image publication
- Git SHA image versioning
- Active ECS service
- Running ECS task
- Successful ECS deployment rollout
- Healthy ALB target
- Successful application response
- Successful `/health` response

This follows the principle:

**Deploy → Validate → Verify**

rather than assuming a successful pipeline command means the application is healthy.

---

# Troubleshooting Experience

Building this platform required diagnosing and resolving real deployment issues.

## GitHub OIDC Subject-Claim Mismatch

### Problem

GitHub Actions could not successfully assume the AWS IAM deployment role.

### Investigation

The GitHub OIDC token identity did not match the subject condition configured in the IAM trust policy.

### Resolution

The trust relationship was corrected so the expected GitHub repository identity could assume the deployment role.

### Lesson

Authentication problems often require tracing the complete trust chain:

**GitHub Identity → OIDC Token → IAM Trust Policy → IAM Role**

---

## IAM Trust Policy Failure

### Problem

The CI/CD pipeline could not obtain the AWS permissions required for deployment.

### Investigation

The IAM role and trust relationship were reviewed to determine whether GitHub Actions was authorized to assume the role.

### Lesson

IAM troubleshooting requires distinguishing between:

- Who can assume the role
- What the role can do after it is assumed

---

## GitHub Actions YAML Errors

### Problem

The deployment workflow failed because of workflow configuration issues.

### Investigation

GitHub Actions output was reviewed to identify YAML formatting and configuration problems.

### Resolution

The workflow configuration was corrected and rerun.

### Lesson

CI/CD troubleshooting begins with identifying the exact pipeline stage that failed rather than treating the pipeline as one system.

---

## Docker Image Tagging Problems

### Problem

The expected container image version was not available for deployment.

### Investigation

The build, tagging, and ECR publication stages were inspected.

### Resolution

The image-tagging workflow was corrected and the ECR repository was verified.

### Lesson

Container deployments require traceability between:

**Code → Build → Tag → Registry → Deployment**

---

## ECS Deployment Stabilization

### Problem

Starting an ECS deployment did not automatically mean that the new application version was healthy.

### Investigation

ECS service state, running tasks, load balancer target health, and application health were checked.

### Lesson

A successful deployment requires validation at multiple layers.

---

# Operational Troubleshooting Strategy

If the production application became unavailable, I would troubleshoot from the user-facing layer toward the application.

```text
User
  |
  v
Application Load Balancer
  |
  v
Target Group
  |
  v
ECS Service
  |
  v
ECS Task
  |
  v
Docker Container
  |
  v
Application
```

## 1. Confirm the Failure

Determine:

- Is the application completely unavailable?
- Are only some requests failing?
- When did the issue begin?
- Did the issue begin after a deployment?

## 2. Check Load Balancer Health

Review:

- Listener configuration
- Target group
- Target health
- Security groups

## 3. Check ECS

Review:

- Service status
- Desired task count
- Running task count
- Failed tasks
- Deployment state
- ECS events

## 4. Check Application Health

Test:

```bash
curl <application-url>/health
```

## 5. Check the Container

Determine whether:

- The expected image is deployed
- The container started successfully
- The correct port is exposed
- The application process is running

## 6. Correlate With Deployment History

Use the Git SHA image tag to identify the exact application revision associated with the deployment.

## 7. Remediate

Correct the root cause rather than only restarting infrastructure.

## 8. Verify

Confirm:

- ECS service is stable
- Tasks are running
- ALB targets are healthy
- Health endpoint succeeds
- User traffic succeeds

Operational workflow:

**Detect → Investigate → Isolate → Remediate → Verify**

---

# Failure-Mode Analysis

## Scenario 1: ECS Task Fails

**Failure:** A container task stops or becomes unhealthy.

**Investigate:**

- ECS service events
- Task status
- Container exit information
- Application logs
- ALB target health

**Recovery:**

ECS service scheduling can launch a replacement task to maintain the desired task count.

---

## Scenario 2: Bad Application Deployment

**Failure:** A newly deployed image causes the health check to fail.

**Detection:**

The ALB reports an unhealthy target or the ECS deployment fails to stabilize.

**Investigation:**

Compare the failing image's Git SHA with the corresponding source revision.

**Recovery strategy:**

Redeploy a known-good container image.

Future improvement:

Implement automated rollback.

---

## Scenario 3: CI/CD Authentication Failure

**Failure:** GitHub Actions cannot assume the AWS role.

**Investigate:**

```text
GitHub Repository
      |
      v
OIDC Token
      |
      v
IAM Trust Policy
      |
      v
Deployment Role
```

Check the repository identity, subject claim, IAM trust policy, and deployment permissions.

---

## Scenario 4: Application Load Balancer Reports Unhealthy Target

Investigate:

- Target group health
- Health-check path
- ECS task status
- Container port
- Security groups
- Application `/health` endpoint

The goal is to determine whether the failure exists at the:

**Network → Container → Application**

layer.

---

# What Happens at 10x Traffic?

A major increase in traffic requires examining the complete request path.

```text
Users
  |
  v
ALB
  |
  v
ECS Service
  |
  v
ECS Tasks
  |
  v
Application
```

## Load Balancer

Evaluate:

- Request volume
- Target response time
- HTTP errors
- Target health

## ECS

Evaluate:

- Number of running tasks
- CPU utilization
- Memory utilization
- Task failures

## Application

Evaluate:

- Response latency
- Error rate
- Resource consumption
- Downstream dependencies

The next production improvement would be **ECS Service Auto Scaling**, allowing task capacity to respond automatically to demand.

Scaling should be driven by observed system behavior rather than simply increasing resources everywhere.

**Measure → Identify Bottleneck → Scale → Verify**

---

# Reliability Improvements

The current platform provides a strong foundation, but production reliability could be improved further through:

- Multiple ECS tasks
- ECS Service Auto Scaling
- CPU-based scaling
- Memory-based scaling
- Multi-AZ resilience testing
- CloudWatch dashboards
- CloudWatch alarms
- ECS Container Insights
- Structured application logging
- Automated deployment rollback
- Blue/green deployments
- Production approval gates

---

# Monitoring and Observability Roadmap

Planned improvements include:

- CloudWatch dashboard
- CloudWatch alarms
- ECS Container Insights
- Application metrics
- Structured application logs

Important operational signals include:

### Traffic

- Request count

### Errors

- HTTP 4xx/5xx errors
- ECS task failures
- Application errors

### Latency

- ALB target response time
- Application response time

### Saturation

- ECS CPU utilization
- ECS memory utilization

These signals help answer:

**Is the system available?**

**Is it healthy?**

**Where is the bottleneck?**

---

# Security Design

## Keyless Authentication

GitHub Actions uses OIDC instead of permanent AWS access keys.

## Restricted Trust

The AWS IAM role trust policy restricts which GitHub repository identity can assume the deployment role.

## Network Controls

Security groups control communication between the ALB and ECS workloads.

## Private Application Networking

Application infrastructure can operate inside private networking while the ALB provides the public entry point.

## Immutable Artifacts

Git SHA image tags provide traceability between source code and deployed containers.

---

# Local Testing

Build:

```bash
docker build -t aws-production-platform ./app
```

Run:

```bash
docker run --rm -p 8080:8080 aws-production-platform
```

Test:

```bash
curl http://localhost:8080
```

Health check:

```bash
curl http://localhost:8080/health
```

---

# Terraform Usage

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Review outputs:

```bash
terraform output
```

Cleanup:

```bash
terraform destroy
```

Always review Terraform plans before applying or destroying infrastructure.

---

# Lessons Learned

Building this platform strengthened my understanding of how multiple engineering disciplines work together in a production cloud environment.

Key lessons include:

- Infrastructure deployment and application deployment are related but separate operational workflows.
- CI/CD pipelines require troubleshooting at individual stages.
- IAM trust relationships are critical to secure automation.
- OIDC removes the need for permanent AWS deployment credentials.
- Container image versioning improves deployment traceability.
- Starting a deployment does not mean the application is healthy.
- Health checks provide an objective mechanism for determining application availability.
- Infrastructure should be reproducible through code.
- Failures should be investigated systematically from symptoms to root cause.
- Production engineering requires thinking about deployment, reliability, security, observability, and recovery together.

---

# Skills Demonstrated

This project provides hands-on evidence of:

- AWS infrastructure architecture
- Terraform
- Infrastructure as Code
- Amazon ECS
- Amazon ECR
- Docker
- Application Load Balancers
- VPC networking
- IAM roles and trust policies
- GitHub Actions
- OpenID Connect federation
- CI/CD pipeline development
- Container image versioning
- Deployment automation
- Deployment troubleshooting
- YAML troubleshooting
- AWS CLI validation
- Application health checks
- Operational failure analysis
- Technical documentation

---

# What This Project Demonstrates

This project demonstrates the ability to manage the complete lifecycle of a cloud-hosted application:

**Provision → Build → Secure → Deploy → Validate → Troubleshoot → Recover → Improve**

The goal is not simply to create AWS resources.

The goal is to build infrastructure and deployment processes that are **repeatable, secure, traceable, supportable, and designed for reliable operations.**

---

# Future Improvements

## Observability

- CloudWatch dashboards
- CloudWatch alarms
- ECS Container Insights
- Structured application logging

## Scaling

- Multiple ECS tasks
- ECS Service Auto Scaling
- CPU and memory scaling policies
- Multi-AZ resilience testing

## Deployment Safety

- Automated rollback
- Blue/green deployment
- Automated application tests
- Production approval gates

## Security

- AWS WAF
- AWS Secrets Manager
- AWS KMS
- Container vulnerability scanning
- CI/CD security scanning

## Terraform

- Production remote state
- State locking
- Development/staging/production environments
- Terraform security scanning

---

## Author

**Alexius Thomas**

Cloud Infrastructure Engineer | AWS Solutions Architect

- GitHub: AlexiusThomas
- LinkedIn: Alexius Victoria

## License

This project is licensed under the terms included in the `LICENSE` file.
````
