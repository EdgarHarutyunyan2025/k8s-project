FROM ghcr.io/actions/actions-runner:latest

USER runner

WORKDIR app

RUN sudo apt-get update && \
    sudo apt-get install -y wget tar && \
    sudo  wget -c https://github.com/helmwave/helmwave/releases/download/v0.41.4/helmwave_0.41.4_linux_amd64.tar.gz -O - | tar -xz && \
    sudo  mv helmwave /usr/local/bin/ && \
    sudo chmod +x /usr/local/bin/helmwave

RUN helmwave --version

#CMD ["bash"]

