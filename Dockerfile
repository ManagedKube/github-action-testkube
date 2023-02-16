# Container image that runs your code
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y apt-transport-https gnupg2 curl unzip jq

# Install kubectl
# doc: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
ENV KUBECTL_VERSION=v1.23.14
RUN curl -LO https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl
RUN chmod 755 ./kubectl
RUN mv kubectl /usr/local/bin/kubectl

# Install testkube plugin - Specific version of https://github.com/kubeshop/testkube/releases
ENV TESTKUBE_VERSION=1.9.13
RUN curl -sSLf https://get.testkube.io | sh

# Install aws cli
ENV AWS_CLI_VERSION=2.9.23
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$AWS_CLI_VERSION.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
