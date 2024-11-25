sam validate
sam build
sam package --region eu-north-1 --template-file template.yaml --output-template-file sam-package-output-file.yaml
sam deploy --template-file sam-package-output-file.yaml --stack-name star-aligner --region eu-north-1 --capabilities CAPABILITY_NAMED_IAM
