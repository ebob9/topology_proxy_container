#!/bin/bash

# This preflight script tries to set somaxconn, and then sets the listen of uwsgi to 4096 if somaxconn is > 4096, or
# somaxconn - 1 if lower
# It then enables TLS, and sets basic auth in TLS, if requested.

# Try and set
#echo 65535 > /proc/sys/net/core/somaxconn

# Read if it took
SOMAXCONN=$(cat /proc/sys/net/core/somaxconn)

# Set UWSGI listen to 4096 or somaxconn - 1.
if ((${SOMAXCONN} > 4096))
    then
        echo "listen = 4096" >> /app/uwsgi.ini
    else
        LISTEN=$(expr ${SOMAXCONN} - 1)
        echo "listen = ${LISTEN}" >> /app/uwsgi.ini
fi


# Ensure TLS NGNIX can run, make sure certs exist (previously created OR mounted from a volume)
APPKEY='/app/tls/app.key'
APPCERT='/app/tls/app.crt'
APPHTPASSWD='/app/htpasswd'

if [[ -r ${APPKEY} && -r ${APPCERT} ]]
    then
        echo "APP key (${APPKEY}) and APP Cert (${APPCERT}) found and readable, re-using."
    else
        # no app key and cert found, create.
        openssl req -new -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes \
        -subj "/C=US/ST=California/L=San Jose/O=Self Signed Certificate/OU=IT Department/CN=*" \
        -out ${APPCERT} -keyout ${APPKEY}
fi

# check if username/password requested
if [[ -z ${CGX_USERNAME} || -z ${CGX_USERPASS} ]]
    then
        echo "CGX_USERNAME or CGX_USERPASS not set, not enabling HTTP Basic auth for 443."
        # ensure lines are not set
        unset AUTH_BASIC_LINE
        unset AUTH_BASIC_USER_FILE
    else
        echo "Creating ${CGX_USERNAME} in ${APPHTPASSWD}."
        htpasswd -cb ${APPHTPASSWD} ${CGX_USERNAME} ${CGX_USERPASS}
        if [[ -r ${APPHTPASSWD} ]]
            then
                # Password created successfully, add to config.
                AUTH_BASIC_LINE="auth_basic \"API Login\""
                AUTH_BASIC_USER_FILE="auth_basic_user_file ${APPHTPASSWD}"
            else
                # ensure lines are not set
                unset AUTH_BASIC_LINE
                unset AUTH_BASIC_USER_FILE
        fi
fi

# Create the TLS NGNIX conf
cat << EOM > /etc/nginx/conf.d/tls-ngnix.conf
server {
    listen 443 http2 ssl;
    listen [::]:443 http2 ssl;
    ssl_certificate ${APPCERT};
    ssl_certificate_key ${APPKEY};
    location / {
        try_files \$uri @app;
    }
    location @app {
        include uwsgi_params;
        uwsgi_pass unix:///tmp/uwsgi.sock;
        ${AUTH_BASIC_LINE};
        ${AUTH_BASIC_USER_FILE};
    }
    location /static {
        alias /app/static;
    }
}
EOM
