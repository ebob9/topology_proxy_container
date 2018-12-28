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
docker run -d --name topology_proxy -p 80:80 \
  --link topology_memcached:memcached \
  -e CGX_AUTH_TOKEN=$CGX_AUTH_TOKEN \
  -e CGX_MEMCACHED="memcached,11211" \
  ebob9/topology_proxy:latest
```
topology_proxy_app will now be available port 80 on the docker host.

#### License
MIT

#### Version
Version | Changes
------- | --------
**2.0.1**| Better CA_BUNDLE handling (scales more efficiently), update to topology_proxy_app v2.0.1
**2.0.0**| First Containerization of topology_proxy_app

