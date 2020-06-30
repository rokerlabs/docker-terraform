FROM alpine:latest
# FROM ubuntu:focal

ARG TERRAFORM_VERSION

RUN apk --update add --no-cache git openssh bash zip
# RUN apt-get update -qq \
#   && apt-get install -qq -y git zip unzip
#   && apt-get autoremove -qq \
#   && apt-get clean \
#   && rm -r /var/lib/apt/lists/* /var/cache/apt
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

# Install awscli
ENV GLIBC_VER=2.31-r0

# install glibc compatibility for alpine
RUN apk --no-cache add binutils curl \
  && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
  && apk add --no-cache glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk \
  && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
  && unzip awscliv2.zip \
  && aws/install \
  && rm -rf \
    awscliv2.zip \
    aws \
    /usr/local/aws-cli/v2/*/dist/aws_completer \
    /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/*/dist/awscli/examples \
  && apk --no-cache del binutils curl \
  && rm glibc-${GLIBC_VER}.apk \
  && rm glibc-bin-${GLIBC_VER}.apk \
  && rm -rf /var/cache/apk/* \
  && aws --version