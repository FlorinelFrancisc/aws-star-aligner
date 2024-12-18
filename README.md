# Star Aligner Project

This repository hosts the infrastructure and CI/CD pipeline for the **Star Aligner** application. The solution leverages AWS services such as S3, ECR, Batch, and SAM for a containerized, serverless batch job workflow.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Infrastructure Resources](#infrastructure-resources)
- [Continuous Integration & Deployment](#continuous-integration--deployment)
- [Docker Image](#docker-image)
- [Prerequisites](#prerequisites)
- [Local Development](#local-development)
- [Deployment](#deployment)
- [License](#license)

## Overview

The Star Aligner project automates the process of aligning "stars" (placeholder for your domain logic) in a scalable, serverless environment. It uses AWS Batch with a Fargate compute environment to run containerized batch jobs, and stores artifacts in an S3 bucket. The pipeline is managed via GitHub Actions, ensuring a streamlined code-to-deployment workflow.

## Architecture

**Key Components:**

- **AWS S3 Bucket:** Stores input files, output artifacts, and any intermediate data.
- **AWS ECR Repository:** Hosts the Docker image for the batch job.
- **AWS Batch Compute Environment & Job Queue:** Manages job submission, scheduling, and execution using Fargate containers.
- **AWS IAM Roles & Policies:** Provide granular permissions for execution, job runs, and access to S3.
- **GitHub Actions:** Automate testing, validation, packaging, and deployment of the infrastructure and application code.

**High-Level Flow:**

1. Code is pushed or a pull request is opened to the `staging` branch.
2. GitHub Actions validate and format code, then run a dry-run deployment to test changes.
3. Once validated, changes are deployed to the staging environment via SAM.
4. Batch jobs can be submitted to the queue, pulling images from ECR and reading/writing files from S3.

## Infrastructure Resources

Defined in `template.yaml` (using AWS SAM + CloudFormation):

- **StarAlignerBucket (S3):** Stores all application files.
- **StarAlignerECRRepository (ECR):** Stores container images.
- **StarAlignerBatchComputeEnvironment (Batch):** Fargate-based compute environment for running jobs.
- **StarAlignerBatchJobQueue (Batch):** Queue to manage submitted jobs.
- **StarAlignerBatchJobDefinition (Batch):** Defines how a job runs, including container image, memory, CPU, and roles.

**IAM Roles & Policies:**

- **StarAlignerJobDefinitionExecutionRole:** Lets ECS tasks pull images and run jobs.
- **StarAlignerJobDefinitionJobRole:** Grants container tasks access to read/write objects in the S3 bucket.

## Continuous Integration & Deployment

Located in `.github/workflows/deploying-staging.yml`:

**Trigger Conditions:**

- Push to `staging` branch
- Pull requests targeting `staging`
- Manual `workflow_dispatch`

**Jobs:**

- **Format Checker:** Uses Ruff, Black, and Prettier to ensure code consistency.
- **Branch Analysis:** Determines if a dry-run deployment should occur (when not on `staging`).
- **Dry Run Deployment:** Builds and packages the SAM application, then attempts a non-executing changeset.
- **Deploy to Staging:** Performs the actual deployment if on `staging` or triggered manually.

This pipeline ensures safe and consistent deployments, preventing accidental changes from moving to staging without validation.

## Docker Image

**Dockerfile:**

- Pulls input data from S3.
- Processes the data (e.g., running alignment tasks using STAR).
- Writes processed results back to S3.

## Prerequisites

- **AWS CLI** and **SAM CLI** installed locally for manual testing or validation.
- AWS account with permissions to deploy the listed resources.
- GitHub repository with appropriate secrets and variables set for CI/CD.
  - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` stored as repository secrets.
  - Ensure `vars.AWS_ACCESS_KEY_ID` and `secrets.AWS_SECRET_ACCESS_KEY` are configured in GitHub.

## Local Development

## Local Deploy

```sh
sam validate --lint
sam build
sam package --region eu-north-1 --template-file template.yaml --output-template-file sam-package-output-file.yaml --s3-bucket aws-sam-cli-managed-default-samclisourcebucket-g29hhzcsbux0
sam deploy --template-file sam-package-output-file.yaml --stack-name star-aligner --region eu-north-1 --capabilities CAPABILITY_NAMED_IAM --s3-bucket aws-sam-cli-managed-default-samclisourcebucket-g29hhzcsbux0
```

## Create and Publish Docker Image

1. Authenticate Docker to ECR:

```sh
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 975049994824.dkr.ecr.eu-north-1.amazonaws.com
```

2. Build your Docker image (from the directory containing your Dockerfile):

```bash
docker build -t star-aligner-repo:latest .
```

3. Tag the image for your ECR repository:

```bash
docker tag star-aligner-repo:latest 975049994824.dkr.ecr.eu-north-1.amazonaws.com/star-aligner-repo-975049994824:latest
```

4. Push the image to ECR:

```bash
docker push 975049994824.dkr.ecr.eu-north-1.amazonaws.com/star-aligner-repo-975049994824:latest
```

**Linting & Formatting:**

```bash
pip install ruff black
npm install prettier
ruff check .
black --check .
prettier "./**/*.yaml" --check
prettier "./**/*.json" --check
```

**Build & Validate Templates:**

```bash
sam validate
sam build


Local Testing: You can run local tests using:

sam local start-api
sam local invoke

Deployment
Staging Deployment via GitHub Actions:

Push changes to the staging branch or open a pull request.
The CI pipeline will:
Check formatting and linting.
Run a dry run to ensure templates and steps are correct.
Deploy the updated stack to the staging environment.

Manual Deployment:
sam package --region eu-north-1 --template-file template.yaml --output-template-file sam-package-output-file.yaml --s3-bucket aws-sam-cli-managed-default-samclisourcebucket-g29hhzcsbux0
sam deploy --template-file sam-package-output-file.yaml --stack-name star-aligner --region eu-north-1 --capabilities CAPABILITY_NAMED_IAM --s3-bucket aws-sam-cli-managed-default-samclisourcebucket-g29hhzcsbux0
```
