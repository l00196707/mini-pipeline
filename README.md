## Overview
This mini project demonstrates a mini pipeline for a simple Python web application using Flask. The goal is to automate every stage from code to deployment and monitoring following DevOps practices

## Objectives
- Implement CI/CD using GitHub Actions
- Automate build, test, and deployment
- Integrate static analysis & security scanning
- Containerize the application using Docker
- Use Terraform to deploy to AWS 
- Enable basic monitoring

## 🚀 Pipeline Overview
This project implements:

### Continuous Integration (CI)
- Python setup using actions/setup-python
- Linting with flake8
- Unit testing with pytest
- Static code analysis using SonarQube Cloud

### Continuous Delivery (CD)
- Docker image built with Buildx
- Multi architecture images (amd64, arm64)
- Automatic push to Docker Hub

### Architecture Flow
1. Code pushed → CI runs (lint, test, SonarQube)
2. Docker image builds & pushes
3. Terraform is applied → EC2 created → Docker container starts automatically
4. Output: public IP of deployed Flask app
  
### Infrastructure as code (IaC)
- Deployment to AWS using Terraform
- EC2 instance provisioning (t2.micro for free tier)
- Automated Docker run on instance startup
  
### Continuous Deployment (CD)
Github Actions automatically performs:
- ```terraform init```
- ```terraform apply -auto-approve```
- Passes Docker Hub username as a variable
- Creates an artifact so state can be shared to the Destroy infrastructure workflow


## 🐳 Docker
- Uses a Python base image
- Installs dependencies
- Exposes port 5000
- Runs the Flask app
- Image gets pushed as: ```dockerhubusername/mini-pipeline:latest```

## ☁️ AWS Deployment
Terraform performs:
### Resources created
- EC2 instance (Amazon Linux 2023)
- Security group allowing:
  - Port 5000 (Flask app)
  - Port 22 (SSH)
- Key pair
- Docker installation via user_data
- Container auto-start on boot

### Output
After Deployment:
```
Apply complete! Resources: x added, x changed, x destroyed.

Outputs:
app_url: "http://x.x.x.x:5000"
public_ip = "X.X.X.X"
```
### 🔐 Required GitHub Secrets

|      Secret Name      |           Purpose              |
| ----------------------| ------------------------------ |
| DOCKERHUB_USERNAME    | Push Docker images             |
| DOCKERHUB_TOKEN       | Docker Hub access token        |
| AWS_ACCESS_KEY_ID     | AWS deploy                     |
| AWS_SECRET_ACCESS_KEY | AWS deploy                     |
| SONAR_TOKEN           | SonarQube Cloud authentication |

## Local Development
### Run locally:
```
pip install -r requirements.txt
python app.py
```
Vist:
```
http://127.0.0.1:5000
```
### 🗑️ Teardown
To destroy deployed resources:
```
terraform destroy -auto-approve
```
- Or via GitHub Actions by manually running the destroy infrastructure workflow. Take note of the run-id from deployment build to pass to this workflow

## Future Improvenents
- Terraform remote backend (S3 + DynamoDB)
- ALB + Auto Scaling Group
- Prometheus + Grafana monitoring
- Secrets Manager for sensitive values
- Push versioned Docker tags
  
