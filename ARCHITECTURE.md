# System Architecture

## CI/CD Pipeline Flow (Blue/Green Deployment)

```mermaid
graph TD
    User[Developer] -->|Push Code| Github[GitHub Repo]
    Github -->|Webhook| Jenkins[Jenkins CI/CD]
    
    subgraph "CI Pipeline"
        Jenkins -->|1. Checkout| Code[Source Code]
        Jenkins -->|2. Build & Test| Build[Build Artifacts]
        Jenkins -->|3. Security Scan| Trivy[Trivy Vulnerability Scan]
        Jenkins -->|4. Docker Build| Image[Docker Image]
        Jenkins -->|5. Push| ECR[Amazon ECR]
    end

    subgraph "CD Pipeline"
        Jenkins -->|6. Terraform Plan| TF[Terraform Plan]
        Jenkins -->|7. Manual Approval| Approval{Approve?}
        Approval -->|Yes| Deploy[Deploy to ECS]
    end
    
    subgraph "AWS Infrastructure (Terraform Managed)"
        Deploy -->|Update Task Def| ECS[Amazon ECS Cluster]
        
        subgraph "VPC"
            ALB[Application Load Balancer]
            ALB -->|Listener 80: Prod| BlueGroup[Active (Blue)]
            ALB -->|Listener 8080: Test| GreenGroup[Staging (Green)]
            
            ECS --> BlueGroup
            ECS --> GreenGroup
            
            Secrets[AWS Secrets Manager] -.->|Inject Credentials| ECS
        end
        
        CW[CloudWatch Logs] -.->|Monitor| ECS
        DD[Datadog Agent] -.->|Metrics| ECS
    end

    classDef aws fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:white;
    classDef ci fill:#205081,stroke:#232F3E,stroke-width:2px,color:white;
    class ECR,ECS,ALB,Secrets,CW aws;
    class Jenkins,Github,Trivy ci;
```

## Component Interaction

1.  **Source Control (GitHub):** Triggers the pipeline on commit.
2.  **Jenkins Server:** Orchestrates the entire flow (Build, Test, Scan, Deploy).
3.  **Security (Trivy):** Scans the filesystem and Docker image for CVEs before pushing.
4.  **Registry (ECR):** Stores the vetted Docker images.
5.  **Infrastructure (Terraform):** Provisioned VPC, ECS, ALB, and Security Groups.
6.  **Deployment (Blue/Green):**
    *   **Blue (Production):** The currently live version.
    *   **Green (Staging/Candidate):** The new version deployed alongside Blue.
    *   **Switch:** After verification, ALB traffic listener is updated to point to Green.
7.  **Observability:**
    *   **CloudWatch:** Collecting container logs (stdout/stderr).
    *   **Datadog:** Sidecar container collecting host and application metrics.
