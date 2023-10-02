# Use an official Alpine Linux base image
FROM alpine:latest

# Set environment variables
ENV TERRAFORM_VERSION=0.15.4

# Install required packages
RUN apk --no-cache add \
    curl \
    unzip \
    python3 \
    py3-pip

# Install the latest version of Ansible available in Alpine Linux
RUN apk --no-cache add ansible

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Copy "aws_s3_inventory.py" to the container and make it executable
COPY aws_s3_inventory.py /usr/local/bin/
RUN chmod +x /usr/local/bin/aws_s3_inventory.py

# Cleanup
RUN apk del curl unzip && \
    rm -rf /var/cache/apk/*

# Set the working directory
WORKDIR /app

# Default command
CMD ["sh"]
