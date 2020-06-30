FROM alpine:latest

ARG TERRAFORM_VERSION

RUN apk --update add --no-cache git openssh bash zip
RUN git --version
RUN ssh -V
RUN bash --version
RUN zip --version

# Terraform handler bin stubs
COPY ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*

# Install terraform
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN terraform version