FROM mcr.microsoft.com/vscode/devcontainers/base:buster AS base

ARG JSONNET_VERSION="0.16.0"

# Download & setup aux binaries
RUN mkdir /tmp/binaries \
    && curl -L --output /tmp/jsonnet.tar.gz "https://github.com/google/jsonnet/releases/download/v${JSONNET_VERSION}/jsonnet-bin-v${JSONNET_VERSION}-linux.tar.gz" \
    && cd /tmp \
    # Jsonnet
    && tar -xv -f jsonnet.tar.gz -C binaries/ \
    # Set execute permission & move to well-known location
    && chmod +x -R binaries/ \
    && mv binaries/* /usr/local/bin \
    && rm -rf /tmp/*
