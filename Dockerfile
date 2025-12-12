# Base image with R preinstalled
# https://hub.docker.com/r/rocker/r-ver
FROM rocker/r-ver:4.4.2

ARG DEBIAN_FRONTEND=noninteractive
# Quarto is installed from GitHub releases; override at build time if you want a newer version:
#   docker build --build-arg QUARTO_VERSION=1.6.0 -t analyzing_assistent:latest .
ARG QUARTO_VERSION=1.5.57

# System tooling + sqlite3 + build deps for common R packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg \
        apt-transport-https \
        sqlite3 \
        libsqlite3-dev \
        build-essential \
        gfortran \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# PowerShell (pwsh)
# Uses the Microsoft apt repo for Debian 12 (the base for current rocker images).
RUN wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb \
    && dpkg -i /tmp/packages-microsoft-prod.deb \
    && rm /tmp/packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends powershell \
    && ln -sf /usr/bin/pwsh /usr/bin/powershell \
    && rm -rf /var/lib/apt/lists/*

# Quarto CLI
RUN curl -fsSL -o /tmp/quarto.deb \
        https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends /tmp/quarto.deb \
    && rm /tmp/quarto.deb \
    && rm -rf /var/lib/apt/lists/*

# R packages used by SQ1/eda/report_1/eda1.r
RUN R -q -e "install.packages(c('RSQLite','ggplot2','dplyr','tidyr'), repos='https://cloud.r-project.org')"

WORKDIR /workspace
COPY . /workspace

# Default to an interactive shell
CMD ["bash"]
