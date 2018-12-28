#!/usr/bin/env bash
docker stop topology_proxy
docker stop topology_memcached
docker system prune --all --force --volumes
