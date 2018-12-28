#!/usr/bin/env bash
docker stop topology_proxy
docker rm topology_proxy
docker stop topology_memcached
docker rm topology_memcached
