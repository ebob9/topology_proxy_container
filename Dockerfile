# Copyright 2018, 2019 CloudGenix, Inc.
# License: CloudGenix Public License (v.1)

FROM tiangolo/uwsgi-nginx-flask:python3.8
# Legacy container - better error printing, actually shows nginix messages.. :(
#FROM tiangolo/uwsgi-nginx-flask:latest-2019-10-14

ENV NGINX_WORKER_PROCESSES="auto" \
    NGINX_WORKER_CONNECTIONS=4096 \
    NGINX_WORKER_OPEN_FILES=4096 \
    NGINX_MAX_UPLOAD="1m"

WORKDIR /app

COPY build_container.sh LICENSE uwsgi.ini CGX_CPROD_CA_BUNDLE.crt prestart.sh prestart-bash.sh /app/

RUN /app/build_container.sh
