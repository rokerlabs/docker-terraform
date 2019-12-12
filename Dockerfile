FROM alpine:latest

ARG TERRAFORM_VERSION

RUN apk --update add --no-cache git openssh bash
RUN git --version
RUN ssh -V
RUN bash --version

# Terraform handler bin stubs
COPY ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*

# Install terraform
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN terraform version

# Install k8s provider dependencies
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl /bin/kubectl
RUN chmod +x /bin/kubectl
RUN kubectl version --short --client

ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator /bin/aws-iam-authenticator
RUN chmod +x /bin/aws-iam-authenticator
RUN aws-iam-authenticator help

# Install aws-cli
RUN apk add --no-cache python py-pip
RUN pip install awscli
RUN apk del --purge py-pip
RUN aws --version