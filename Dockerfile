FROM hashicorp/terraform:1.2.3

RUN apk --update add --no-cache openssh openssl bash curl jq zip gzip brotli \
  && git --version \
  && ssh -V \
  && openssl version \ 
  && bash --version \
  && curl --version \
  && jq --version \
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
RUN terraform version

# Upstream image runs terraform in current working directory, we require user defined command execution.
ENTRYPOINT []
