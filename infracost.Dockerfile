FROM infracost/infracost:v0.8.4 as infracost

RUN infracost --version

# Release image
FROM rokerlabs/terraform:beta

ENV INFRACOST_VERSION=latest

# Terraform handler bin stubs
COPY ./bin/cost /usr/local/bin/cost
RUN chmod +x /usr/local/bin/cost

# Install infracost
COPY --from=infracost /usr/bin/infracost /usr/bin/
