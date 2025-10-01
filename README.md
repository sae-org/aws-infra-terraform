# ☁️ `aws-infra-tf` — Terraform AWS Infrastructure  

This repository provisions all **AWS infrastructure** required to run the Nginx-based website. It uses **Terraform** with modular design and a remote S3 backend for state management.  

The infrastructure integrates with **ECR, EC2 Auto Scaling Groups, ALB, Route 53, ACM, IAM, CloudWatch, and SNS** to deliver a highly available, secure, and monitored environment. A GitHub Actions pipeline is also included for automated deployments.

---

## 🚀 Features
- **Infrastructure as Code (IaC)** with Terraform modules  
- **Remote S3 backend** with state locking  
- **VPC + subnets + IGW + NAT Gateway + Security Groups**  
- **EC2 Auto Scaling Group with User Data bootstrap**  
- **Application Load Balancer (ALB)** with HTTPS & automatic redirect from HTTP → HTTPS  
- **Elastic Container Registry (ECR)** for Docker images  
- **Route 53 DNS + ACM certificates** for domain + TLS management  
- **IAM roles/policies** for EC2, ECR, CloudWatch, and SSM  
- **CloudWatch monitoring + SNS alerts** for CPU utilization  
- **GitHub integration** for securely handling SSH keys & tokens  

---

## ⚙️ Components

### 🗂️ S3 Backend
- Stores Terraform state remotely in an S3 bucket (`dev-sae-tf-backend`).  
- Enables state locking and prevents drift when collaborating.  

---

### 🌐 Networking (VPC Module)
- Dedicated VPC (`10.0.0.0/16`).  
- **Public subnets** for ALB and NAT Gateway.  
- **Private subnets** for EC2 instances.  
- **Internet Gateway** for public traffic.  
- **NAT Gateway** for outbound access from private EC2s.  
- **Route Tables** for traffic management.  

---

## 🔐 Security Groups (ALB & EC2)

Two security groups are created via `security_groups` module:

### ALB Security Group 
- **Ingress**  
  - `0.0.0.0/0` → TCP **80** (HTTP)  
  - `0.0.0.0/0` → TCP **443** (HTTPS)
- **Egress**  
  - **All** outbound (`0.0.0.0/0`, protocol `-1`)

This makes the ALB publicly reachable on 80/443.

### EC2 Security Group 
- **Ingress**  
  - `0.0.0.0/0` → TCP **22** (SSH) *(recommend restricting to your IP/CIDR)*  
  - **From ALB SG only** → TCP **80**  
  - **From ALB SG only** → TCP **443** *(optional; useful if you ever terminate TLS on instances)*
- **Egress**  
  - **All** outbound (`0.0.0.0/0`, protocol `-1`)

**Why this matters**  
- Traffic to the app flows **Internet → ALB (80/443)**, then **ALB → EC2 (80/443)**, with EC2 not exposed directly to the internet for web ports.  
- Current app listens on **port 80** behind the ALB.

---

### ⚖️ Application Load Balancer (ALB)
- Internet-facing ALB distributes traffic across EC2 instances.  
- **Listeners**:  
  - Port 80 (HTTP) → Redirects to HTTPS (443).  
  - Port 443 (HTTPS) → Forwards traffic to target group.  
- **Target Groups**:  
  - One per port (80, 443).  
  - Health checks ensure only healthy instances receive traffic.  
- **Certificates**:  
  - Managed by ACM.  
  - TLS termination handled at ALB level.  

**Why this matters:**  
- Simplifies SSL management (certs on ALB, not EC2s).  
- Enforces HTTPS with automatic redirection.  

---

### 🖥️ EC2 Auto Scaling Group (ASG)
- Manages multiple EC2 instances running the Dockerized website.  
- Configured with **desired capacity = 2**, **min = 2**, **max = 3**.  
- Launch template includes IAM role, SGs, and user-data bootstrap.  

#### 🔑 User Data Bootstrap
Each EC2 instance automatically:
1. Installs Docker + AWS CLI.  
2. Logs in to Amazon ECR.  
3. Pulls latest image (`my-dev-ecr-repo-1:dev`).  
4. Runs/replaces container (`myapp`) with restart policy.  

**Benefit**:  
- On ASG refresh or scale-out, instances self-bootstrap with zero manual steps.  
- No downtime — new instances automatically pull and run the latest image.  

---

### 📦 Elastic Container Registry (ECR)
- Hosts the website’s Docker images.  
- Integrated with GitHub Actions (build & push).  
- Pulled dynamically by EC2 instances at boot.  

---

### 🌍 Route 53 + ACM
- **Route 53**:
  - Hosted zone for `saeeda.me`.  
  - Records point directly to ALB DNS via alias.  
- **ACM**:
  - Issues TLS certificates for domains.  
  - Auto-validated with DNS via Terraform.  

---

### 🔐 IAM
- IAM Role + Instance Profile for EC2s.  
- Permissions include:  
  - ECR pull access.  
  - SSM access for remote management.  
  - CloudWatch logging.  
- Attached managed policies:  
  - `AmazonSSMManagedInstanceCore`  
  - `CloudWatchAgentServerPolicy`  

---

### 📊 Monitoring & Alerts
- CloudWatch alarms monitor EC2 CPU utilization.  
- SNS topic sends alerts to email.  
- Provides visibility and proactive notifications.  

---

### 🔐 GitHub Integration
- Terraform pulls a GitHub token securely from AWS Secrets Manager.  
- Private SSH key for ASG instances (`ASG_SSH_KEY`) is also stored securely.  
- No sensitive values are ever hardcoded in the repo.  

---

## ⚡ CI/CD with GitHub Actions
This repo includes a workflow to automatically run Terraform on pushes to `main`.  

**Pipeline Steps:**  
1. Checkout repo.  
2. Configure AWS credentials (from GitHub Secrets).  
3. Install Terraform.  
4. Run `terraform init`, `fmt`, `plan`.  
5. Apply infrastructure with `terraform apply -auto-approve`.  

**Required GitHub Secrets:**  
- `AWS_ACCESS_KEY_ID`  
- `AWS_SECRET_ACCESS_KEY`  

---

## ✅ Summary
This repository fully automates AWS infrastructure for the website:  
- HA architecture with **ASG + ALB**.  
- End-to-end HTTPS via ACM + ALB redirect.  
- Docker image delivery via ECR + User Data.  
- Secure secrets handling with AWS Secrets Manager + GitHub Actions.  
- Monitoring and alerts for resiliency.  


## 📂 Repository Structure
```
aws-infra-terraform/
├── .github/workflows
  └── tf_cicd.yaml
├── deploy
  └── backend
    └── backend_root_main.tf
  └── main
    └── root_main.tf
    └── user_data.sh
├── modules/ 
  ├── acm/
  ├── backend/
  ├── ec2/
  ├── ecr/
  ├── github/
  ├── iam/
  ├── lb/
  ├── monitoring/
  ├── r53/
  ├── security_groups/
  └── vpc/

```
