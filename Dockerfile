FROM amazon/aws-cli:latest
WORKDIR /app
COPY README.md /app/README
CMD ["s3", "cp", "/app/README", "s3://star-aligner-files-975049994824/"]
