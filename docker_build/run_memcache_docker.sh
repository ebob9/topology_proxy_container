#!/usr/bin/env bash
if [[ -z "$1" ]]
  then
    echo "ERROR: Requires version string (x.y.z) as first argument".
    exit 1
fi

if [[ -z "$CGX_AUTH_TOKEN" ]]
  then
    echo "ERROR: CGX_AUTH_TOKEN Environment variable NOT SET. Please set."
    exit 1
fi

docker run -d --name topology_memcached memcached:latest

docker run -d --name topology_proxy -p 80:80 \
  --link topology_memcached:memcached \
  --sysctl net.core.somaxconn=65535 \
  -e CGX_AUTH_TOKEN=$CGX_AUTH_TOKEN \
  -e CGX_MEMCACHED="memcached,11211" \
  -e CGX_DEBUG=$CGX_DEBUG \
  ebob9/topology_proxy:${1}
