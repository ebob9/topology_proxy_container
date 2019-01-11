#!/bin/bash
#
# This is an example script to use Azure CLI to launch a container group for use with topology_proxy_container.
# It uses container_group.yml to spin up the container.
#
# Please edit the region below in 'az group create' and the CGX_AUTH_TOKEN in the YAML file at a minimum.
#
# login
az login

# create resource group
az group create --name topologyProxyRG --location eastus

# deploy containers
az container create --resource-group topologyProxyRG --dns-name-label test-topo-proxy --file container_group.yaml
