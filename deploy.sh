#!/bin/sh

sam validate --lint
sam build
sam package --region eu-north-1 --template-file template.yaml --output-template-file sam-package-output-file.yaml --s3-bucket my-cloudformation-batch-bucket-2024-11-24/
sam deploy --template-file sam-package-output-file.yaml --stack-name star-aligner --region eu-north-1 --capabilities CAPABILITY_NAMED_IAM