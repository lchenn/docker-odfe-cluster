# docker-odfe-cluster
Generate the docker-compose.yaml files so that:

1. Create an Elasticsearch cluster with dockers
2. Assume each node will stay in a different node
3. Use Open Distro for Elasticsearch as the base docker image.

## How to use this repo
1. Update the `NODE_NAMES`, `NODE_IPS`, and `NODE_HOSTS`, ensure each index represents one node
2. Run `sh generate_cluster.sh`
3. The results will be in the `out` directory

## SSL Config
This script doesn't support tls yet. We can use the following scripts to generate ssl certificates.
- https://opendistro.github.io/for-elasticsearch-docs/docs/security-configuration/generate-certificates/
Reference url for setup the ssl
- https://opendistro.github.io/for-elasticsearch-docs/docs/security-configuration/tls/

To replace the demo certificate, it's about configuring the following in the `docker-compose.yaml` file.
We would need 5 certificate related:
1. A root CA cert (key is not needed)
2. A pair of cert and key for the node (each node should be different)
2. A pair of cert and key for admin (the same for all the nodes)
```yaml
    volumes:
      - ./root-ca.pem:/usr/share/elasticsearch/config/root-ca.pem
      - ./node.pem:/usr/share/elasticsearch/config/node.pem
      - ./node-key.pem:/usr/share/elasticsearch/config/node-key.pem
      - ./admin.pem:/usr/share/elasticsearch/config/admin.pem
      - ./admin-key.pem:/usr/share/elasticsearch/config/admin-key.pem
```
See more there:
https://opendistro.github.io/for-elasticsearch-docs/docs/install/docker-security/
