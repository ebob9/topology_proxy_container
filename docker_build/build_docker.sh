#!/usr/bin/env bash
if [[ -z "$1" ]]
  then
    echo "ERROR: Requires version string (x.y.z) as first argument".
    exit 1
fi

cp ../* .

docker build --no-cache -t ebob9/topology_proxy:${1} -t ebob9/topology_proxy:latest .
