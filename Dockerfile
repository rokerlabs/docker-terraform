FROM alpine:latest

ARG TERRAFORM_VERSION

RUN apk --update add --no-cache git openssh bash zip gzip brotli \
  && git --version \
  && ssh -V \
  && bash --version \
  && zip --version \
  && gzip --version \
  && brotli --version

# Terraform handler bin stubs
COPY ./bin/apply /usr/local/bin/apply
COPY ./bin/plan /usr/local/bin/plan
COPY ./bin/tf /usr/local/bin/tf
COPY ./bin/validate /usr/local/bin/validate
RUN chmod +x /usr/local/bin/*

# Install terraform
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN terraform version