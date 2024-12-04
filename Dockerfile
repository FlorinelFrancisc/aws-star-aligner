# Use Amazon Linux as the base image
FROM public.ecr.aws/amazonlinux/amazonlinux:latest

RUN ls
# Set the default command to echo "hello world"
CMD ["echo", "hello world!"]
