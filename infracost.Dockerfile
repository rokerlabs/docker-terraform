FROM rokerlabs/terraform:beta

ENV INFRACOST_VERSION=latest

ADD https://github.com/infracost/infracost/releases/${INFRACOST_VERSION}/download/infracost-linux-amd64.tar.gz ./
RUN tar -xzf infracost-linux-amd64.tar.gz -C /tmp && \
  mv /tmp/infracost-linux-amd64 /usr/local/bin/infracost