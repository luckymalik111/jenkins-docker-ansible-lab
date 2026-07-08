FROM jenkins/jenkins:lts-jdk17

USER root

# + openssh-client for the Jenkins+SSH remote-host lectures, + ansible for the Ansible lectures
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        openssh-client \
        ansible \
        default-mysql-client \
        awscli \
        maven && \
    rm -rf /var/lib/apt/lists/*

# Docker CLI only (so Jenkins jobs/Ansible can talk to the host Docker daemon via the
# mounted socket) - Debian's docker.io package no longer ships the client binary, so
# grab the official static build instead.
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-27.3.1.tgz \
        -o /tmp/docker.tgz && \
    tar -xzf /tmp/docker.tgz -C /usr/local/bin --strip-components=1 docker/docker && \
    rm /tmp/docker.tgz

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

USER jenkins
