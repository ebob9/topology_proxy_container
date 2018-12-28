# Copyright 2018, 2019 CloudGenix, Inc.
# License: CloudGenix Public License (v.1)

FROM tiangolo/uwsgi-nginx-flask:python3.7

ENV NGINX_WORKER_PROCESSES="auto" \
    NGINX_WORKER_CONNECTIONS=4096 \
    NGINX_WORKER_OPEN_FILES=4096 \
    NGINX_MAX_UPLOAD="1m"

WORKDIR /app

COPY build_container.sh LICENSE uwsgi.ini CGX_CPROD_CA_BUNDLE.crt /app/

RUN ./build_container.sh
