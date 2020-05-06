FROM python:3.8 AS open

RUN pip install devpi-server devpi-client devpi-web && \
    mkdir -p /etc/devpi && \
    mkdir -p /tmp/devpi_empty && \
    useradd -k /tmp/devpi_empty -m -d /data -s /bin/sh -N -g nogroup devpi && \
    rmdir /tmp/devpi_empty
USER devpi
WORKDIR /data
ADD --chown=devpi:nogroup config.yml /etc/devpi/config.yml
RUN devpi-server --init --serverdir /data

VOLUME /data
EXPOSE 3141

CMD [ "devpi-server", "-c", "/etc/devpi/config.yml"]

FROM open
RUN pip install devpi-lockdown
