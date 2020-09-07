FROM rokerlabs/terraform:beta

ENV INFRACOST_VERSION=latest

RUN apk --update add --no-cache curl jq \
  && curl --version \
  && jq --version

# Terraform handler bin stubs
COPY ./bin/cost /usr/local/bin/cost
RUN chmod +x /usr/local/bin/cost

# Install infracost
ADD https://github.com/infracost/infracost/releases/${INFRACOST_VERSION}/download/infracost-linux-amd64.tar.gz ./
RUN tar -xzf infracost-linux-amd64.tar.gz -C /tmp && \
  mv /tmp/infracost-linux-amd64 /usr/local/bin/infracost