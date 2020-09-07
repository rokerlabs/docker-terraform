FROM rokerlabs/terraform:beta

ENV INFRACOST_VERSION=latest

RUN curl --silent --location https://github.com/infracost/infracost/releases/${INFRACOST_VERSION}/download/infracost-linux-amd64.tar.gz | tar xz -C /tmp
RUN mv /tmp/infracost-linux-amd64 /usr/local/bin/infracost