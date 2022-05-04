# Container image that runs your code
FROM ubuntu:21.10

RUN apt-get update && apt-get install -y apt-transport-https gnupg2 curl unzip jq

# Install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# Install testkube plugin - Specific version of https://github.com/kubeshop/testkube/releases
ENV TESTKUBE_VERSION=1.0.14
RUN curl -sSLf https://kubeshop.github.io/testkube/install.sh | bash

# Install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
