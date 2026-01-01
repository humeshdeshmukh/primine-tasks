# Enterprise CI/CD Pipeline on AWS ECS (Blue/Green)

> **Status:** Production-Ready Logic | **Infrastructure:** AWS ECS Fargate + Terraform | **Pipeline:** Jenkins

## 📌 Project Overview
This project demonstrates a **senior-level DevOps architecture** for deploying containerized applications. It implements a fully automated **Blue/Green Deployment** strategy on **AWS ECS Fargate**, provisioning infrastructure via **Terraform** and managing secrets with **AWS Secrets Manager**.

**Key Features:**
*   **Zero-Downtime Deployments:** Blue/Green strategy via Application Load Balancer (ALB).
*   **Infrastructure as Code (IaC):** Full Terraform suite (`vpc`, `ecs`, `alb`, `iam`) with state management.
*   **Security First:**
    *   Secrets injected at runtime via **AWS Secrets Manager**.
    *   Images scanned with **Trivy** (simulated).
    *   Identity-based access via **IAM Roles**.
*   **Observability:**
    *   **CloudWatch Logs** for application output.
    *   **Datadog Sidecar** pattern for infrastructure metrics.

---

## 🏗️ Architecture
*(See `ARCHITECTURE.md` for full Mermaid diagram)*

The pipeline follows this flow:
1.  **Code Commit** → Jenkins Webhook.
2.  **Jenkins CI**:
    *   Build & Test (Node.js).
    *   Security Scan (Trivy).
    *   Docker Build & Push (ECR).
3.  **Jenkins CD**:
    *   Terraform Plan (Infrastructure Audit).
    *   **Manual Approval Gate**.
    *   Blue/Green Deploy (Traffic Switch).

---

## 🛠️ Infrastructure Components

| Component | Resource Type | Description |
| :--- | :--- | :--- |
| **Compute** | `aws_ecs_service` | Fargate Launch Type (Serverless Containers). |
| **Networking** | `aws_lb` | Application Load Balancer with Blue/Green Target Groups. |
| **Secrets** | `aws_secretsmanager_secret` | Stores DB credentials; injected as Envars. |
| **Monitoring** | `aws_cloudwatch_log_group` | Centralized logging for all containers. |
| **Sidecar** | `datadog-agent` | Runs alongside app to scrape metrics. |

---

## 🚀 How to Run

### Prerequisities
*   Docker (Installed & Running).
*   AWS Credentials (Access Key & Secret Key).

### 1. Verify Infrastructure (Terraform)
We use a Dockerized helper script to run Terraform without local installation.

```powershell
# Verify the plan against your AWS Account
./scripts/tf_docker.ps1 plan "<ACCESS_KEY>" "<SECRET_KEY>"
```

### 2. Run the Pipeline Simulation
Start Jenkins locally to see the pipeline in action.

```powershell
./scripts/start_jenkins.ps1
```

### 3. Deploy (Real AWS)
To apply the changes live to your AWS Playground:

```powershell
./scripts/tf_docker.ps1 "apply -auto-approve" "<ACCESS_KEY>" "<SECRET_KEY>"
```

---

## 📂 Project Structure
```
.
├── app/                 # Node.js Application Source
├── jenkins/             # Jenkinsfile (Pipeline as Code)
├── scripts/             # Helper Scripts (Deploy Sim, Docker Wrappers)
└── terraform/           # IaC Configuration
    ├── main.tf          # Provider & State
    ├── ecs.tf           # Cluster, Service, Task Def
    ├── alb.tf           # Load Balancer, Listeners
    ├── vpc.tf           # Networking, Security Groups
    └── extras.tf        # Secrets & Monitoring
```
