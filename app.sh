Description:

Submit a Batch job that uses the same Docker image.
Verify that app.sh runs correctly in the AWS Batch environment.
Check that the job can retrieve data from S3 and write the processed output back to S3.
Checklist:

 Ensure template.yaml and the Batch Job Definition reference the correct ECR image.
 Push the locally tested Docker image to ECR.
 Use aws batch submit-job or the AWS Console to submit the job.
 Inspect job logs in CloudWatch to confirm app.sh executed without errors.
 Verify that the output data is available in S3 (or the designated storage location).
