topo_proxy_container
----------

#### Synopsis
This repository contains info for building a Docker container to house the [topology_proxy_app](https://github.com/ebob9/topology_proxy_app)

This allows for easier upgrade and deployment. The Container is available on docker hub as `ebob9/topology_proxy`. For more info, see
[ebob9/topology_proxy](https://cloud.docker.com/repository/docker/ebob9/topology_proxy).

#### Requirements
* Active CloudGenix Account
* Docker Host

#### Installation/Use
1. Set CGX_AUTH_TOKEN environment variable to a static CloudGenix AUTH_TOKEN.
2. For Memcached support, run the following commands:
```bash
export CGX_AUTH_TOKEN="<your CGX AUTH_TOKEN here>"
docker run -d --name topology_memcached memcached:latest
docker run -d --name topology_proxy \
  -p 80:80 \
  -p 443:443 \
  --link topology_memcached:memcached \
  --sysctl net.core.somaxconn=65535 \
  -e CGX_AUTH_TOKEN=$CGX_AUTH_TOKEN \
  -e CGX_MEMCACHED="memcached,11211" \
  ebob9/topology_proxy:latest
```
topology_proxy_app will now be available port 80 and 443 on the docker host.

The Container also can support serving TLS on 443, and will generate a self-signed certificate / key on first run in
`/app/tls/app.crt` and `/app/tls/app.key`. If you wish to use a specific key/cert, simply create a Bind Mount for 
`/app/tls`, and in the directory being mounted include the `app.key` (unencrypted RSA OR ECSDA) and `app.crt` bundle 
(with chain, if needed.) This is typically done by adding a `-v  <localfullpath>:<containerfullpath>` switch
to the `docker run` command, (ex: `-v "$(pwd)"/tls:/app/tls`).

This container can also support Basic Authentication over TLS on 443, if you pass the extra Environment Variables 
`CGX_USERNAME` and `CGX_USERPASS`. If these optional vars are not set, no Basic Auth will be used.

#### License
MIT

#### Version
Version | Changes
------- | --------
**2.0.2**| Support for Azure Container Instances, TLS in NGNIX, adaptive somaxconn listen in uwsgi.ini, and Optional BasicAuth support for TLS
**2.0.1**| Better CA_BUNDLE handling (scales more efficiently), update to topology_proxy_app v2.0.1
**2.0.0**| First Containerization of topology_proxy_app

