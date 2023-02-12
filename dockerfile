FROM ubuntu:focal

RUN \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y python3 \
    python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN \
    apt-get update \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

ENV HOME /root
WORKDIR $HOME/mine-pddl

SHELL ["/bin/bash", "-c"]

RUN pip install minerl


