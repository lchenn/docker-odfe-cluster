# docker-odfe-cluster
Generate the docker-compose.yaml files so that:

1. Create an Elasticsearch cluster with dockers
2. Assume each node will stay in a different node
3. Use Open Distro for Elasticsearch as the base docker image.

## How to use this repo
1. Update the `NODE_NAMES`, `NODE_IPS`, and `NODE_HOSTS`, ensure each index represents one node
2. Run `sh generate_cluster.sh`
3. The results will be in the `out` directory

## Generate TLS
This script doesn't support tls yet. We can use the following scripts to generate ssl certificates.
- https://docs.search-guard.com/latest/generating-tls-certificates
- https://docs.search-guard.com/latest/offline-tls-tool
Reference url for setup the ssl
https://opendistro.github.io/for-elasticsearch-docs/docs/security-configuration/tls/