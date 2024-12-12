# Star Aligner

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
