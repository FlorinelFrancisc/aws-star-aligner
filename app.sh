#!/usr/bin/env bash

# Copy a file from S3 to the local directory
aws s3 cp s3://star-aligner-files-975049994824/README .

# Use wc to count what's in the file (lines, words, characters)
wc README > result.txt

aws s3 cp result.txt s3://star-aligner-files-975049994824/
