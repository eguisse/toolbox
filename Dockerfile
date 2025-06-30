# syntax=docker/dockerfile:1.4
FROM ubuntu:22.04

ARG APP_VERSION="snapshot"
LABEL maintainer="emmanuel.guisse@egitc.com"
LABEL description="toolbox docker image to be used for debugging network in kubernetes cluster"
LABEL project-name="eguisse/toolbox"
LABEL project_url="https://github.com/eguisse/toolbox"
LABEL org.opencontainers.image.source = "https://github.com/eguisse/toolbox"
LABEL version="${APP_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q \
  && apt-get install -q -y --no-install-recommends \
    apt-utils \
    curl \
    ca-certificates \
    software-properties-common \
    tzdata \
    python3 \
    locales \
    unzip \
    gnupg2 \
    jq \
    openssl \
    net-tools \
    dnsutils \
    ncat \
    sudo \
    bash \
    bash-completion \
    lsb-release \
    vim \
    tmux \
    iputils-ping \
    traceroute \
    telnet \
    lynx \
    nano \
    wget \
    iputils-ping \
    openssh-client \
    nfs-common


# install redis client
RUN curl -fsSL https://packages.redis.io/gpg | apt-key add - && \
  echo "deb https://packages.redis.io/deb jammy main" | sudo tee /etc/apt/sources.list.d/redis.list

RUN  apt update && apt install redis-tools


# install mongodb tools
RUN curl https://downloads.mongodb.com/compass/mongodb-mongosh_2.1.1_amd64.deb --output /tmp/mongodb-mongosh_amd64.deb && \
    dpkg -i /tmp/mongodb-mongosh_amd64.deb && \
    rm /tmp/mongodb-mongosh_amd64.deb

RUN curl https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.9.4.tgz --output /tmp/mongodb-database-tools.tgz && \
    tar -xvzf /tmp/mongodb-database-tools.tgz -C /usr/local/bin --strip-components=2 && \
    rm /tmp/mongodb-database-tools.tgz \
    && chmod +x /usr/local/bin/bsondump \
    && chmod +x /usr/local/bin/mongodump \
    && chmod +x /usr/local/bin/mongoexport \
    && chmod +x /usr/local/bin/mongofiles \
    && chmod +x /usr/local/bin/mongoimport \
    && chmod +x /usr/local/bin/mongorestore \
    && chmod +x /usr/local/bin/mongostat \
    && chmod +x /usr/local/bin/mongotop


# install ibmcloud cli
RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | sh

RUN rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8


# create the user app, add to sudoers and create the app directory
RUN useradd --uid 1000 -m -s /bin/bash -d /home/app app \
    && usermod -aG sudo app \
    && echo "app ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && mkdir -p /app \
    && chown -R app:app /app



WORKDIR /app
USER app

# Install ibmcloud cli plugins
RUN ibmcloud plugin install container-service -f && \
    ibmcloud plugin install container-registry -f && \
    ibmcloud plugin install cloud-databases -f && \
    ibmcloud plugin install cloud-object-storage -f && \
    ibmcloud plugin install cloud-internet-services -f && \
    ibmcloud plugin install cloud-logs -f && \
    ibmcloud plugin install vpc-infrastructure -f

RUN ibmcloud plugin install monitoring -f && \
    ibmcloud plugin install secrets-manager -f && \
    ibmcloud plugin install metrics-router -f && \
    ibmcloud plugin install event-streams -f

ENV LANG en_US.utf8
ENV TZ=UTC
ENV PATH="/opt/mssql-tools/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
