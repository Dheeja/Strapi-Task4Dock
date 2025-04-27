# Strapi CI/CD Deployment with Terraform and Docker

This project demonstrates how to create, Dockerize, and deploy a **Strapi** application to **AWS EC2** using **Terraform** for infrastructure management and **GitHub Actions** for Continuous Integration and Deployment (CI/CD).

## Prerequisites

- **Docker**: Installed on your local machine to Dockerize the Strapi app.
- **Terraform**: Installed for deploying infrastructure to AWS.
- **AWS Account**: You must have an AWS account to deploy resources.
- **GitHub Account**: For CI/CD setup using GitHub Actions.
- **Docker Hub Account**: To store the Docker image for the Strapi application.

## Steps

### 1. **Create and Set Up Strapi Application Locally**

If you haven't already set up a Strapi project, follow these steps:

1. Install Strapi globally (if you haven't already):
   npm install strapi@latest -g
Create a new Strapi project:

npx create-strapi-app my-project --quickstart
Navigate to the my-project directory and start the Strapi application:

cd my-project
npm run develop
Your Strapi app should now be running locally at http://localhost:1337.

2. Dockerize the Strapi Application
In the root of your Strapi project, create a Dockerfile:

Dockerfile

docker build -t your-dockerhub-username/strapi-app .
docker run -p 1337:1337 your-dockerhub-username/strapi-app
Push the Docker image to Docker Hub:

docker login
docker push your-dockerhub-username/strapi-app:latest
3. Set Up CI/CD with GitHub Actions
Create a .github/workflows/ci.yml file in your repository to automate the build and push process to Docker Hub:

name: Build and Push Docker Image

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build Docker image
        run: docker build -t your-dockerhub-username/strapi-app:latest .

      - name: Push Docker image
        run: docker push your-dockerhub-username/strapi-app:latest
4. Deploy with Terraform
Once the Docker image is available on Docker Hub, deploy the infrastructure using Terraform. Make sure you have the following files in your terraform/ directory:

main.tf: Contains the AWS infrastructure configuration.

provider.tf: Specifies the AWS provider.

variables.tf: Manages any input variables for your Terraform setup.

outputs.tf: Specifies the output values after deployment.

user_data.sh: Contains the script to pull the Docker image and run it on an EC2 instance.

5. Terraform Configuration for AWS Deployment
In your terraform/main.tf file, configure the AWS EC2 instance to run the Strapi Docker container:

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "strapi" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with a suitable AMI ID
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              docker pull your-dockerhub-username/strapi-app:latest
              docker run -d -p 1337:1337 your-dockerhub-username/strapi-app:latest
              EOF

  tags = {
    Name = "StrapiApp"
  }
}
6. Run Terraform to Deploy the Infrastructure
Initialize Terraform:

terraform init

Plan the deployment:

terraform plan
Apply the configuration to create the AWS EC2 instance:

terraform apply -auto-approve
7. Access Strapi on EC2
After the Terraform deployment completes, you can access your Strapi application by visiting the public IP of the EC2 instance at http://<EC2_PUBLIC_IP>:1337.

