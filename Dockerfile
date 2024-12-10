# Use the AWS CLI image as the base image
FROM amazon/aws-cli:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the local README file into the container (optional if you want to package it inside the container)
COPY README.md /app/README

# Default command to copy the README to an S3 bucket
CMD ["aws", "s3", "cp", "/app/README.", "s3://star-aligner-files-975049994824/"]
