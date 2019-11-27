#!/usr/bin/env bash
set -e

CLUSTER_NAME="odfe-dev"
NODE_LOCAL_DATA_DIR="/opt/data/elasticsearch_data/data"

NODE_NAMES=(
  "example-node1"
  "example-node2"
  "example-node3"
)

NODE_IPS=(
  "10.1.2.1"
  "10.1.2.2"
  "10.1.2.3"
)

NODE_HOSTS=(
  "node1.domain"
  "node2.domain"
  "node3.domain"
)

function generate_docker_compose_yaml() {
  node_name=$1
  node_ip=$2
  node_name_list=$3
  node_host_list=$4

  CLUSTER_NAME=${CLUSTER_NAME} \
	NODE_LOCAL_DATA_DIR=${NODE_LOCAL_DATA_DIR} \
	NODE_LIST=${node_name_list} \
	HOST_LIST=${node_host_list} \
  NODE_NAME=${node_name} \
  TRANSPORT_PUBLISH_HOST=${node_ip} \
		envsubst < docker-compose-odfe-node.yml > "out/docker-compose-odfe-${node_name}.yml"
}

function generte_docker_compose_yamls() {
  mkdir -p out
  printf "%s\t%s\n" "cluster_name" "${CLUSTER_NAME}"
  for i in "${!NODE_NAMES[@]}"; do
    printf "%s\t%s\n" "Node name $i:" "${NODE_NAMES[$i]}"
    printf "%s\t%s\n" "Name IP $i" "${NODE_IPS[$i]}"
    printf "%s\t%s\n" "Node host $i" "${NODE_HOSTS[$i]}"
    node_name_list="${NODE_NAMES[$i]},${node_name_list}"
    node_host_list="${NODE_HOSTS[$i]},${node_host_list}"
  done
  for i in "${!NODE_NAMES[@]}"; do
    generate_docker_compose_yaml "${NODE_NAMES[$i]}" "${NODE_IPS[$i]}" "${node_name_list}" "${node_host_list}"
  done
}

generte_docker_compose_yamls