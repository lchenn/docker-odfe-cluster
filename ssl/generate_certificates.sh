#!/usr/bin/env bash

set -e
set -x

function gen_ca_pair() {
  # Generate the key for CA.
  openssl genrsa -out root-ca-key.pem 2048

  # Generate the CA cert.
  openssl req -config root-ca.conf \
    -new -x509 \
    -sha256 \
    -key root-ca-key.pem \
    -out root-ca.pem

  # Clean up.
  rm root-ca.srl
}

# Node cert
function generate_cert_pair() {
  local root_ca=$1
  local root_ca_key=$2
  local cert_name=$3

  # Build a temp key.
  openssl genrsa -out "${cert_name}-key-temp.pem" 2048

  # Build the key for the cert.
  openssl pkcs8 \
    -inform PEM \
    -outform PEM \
    -in "${cert_name}-key-temp.pem" \
    -topk8 \
    -nocrypt \
    -v1 PBE-SHA1-3DES \
    -out "${cert_name}-key.pem"

  # Generate the cert request config file.
  export CN_NAME=${cert_name}
  envsubst < csr.cnf > csr-temp.cnf
  unset CN_NAME

  # Generate a certificate request.
  openssl req -new \
    -config csr-temp.cnf \
    -key "${cert_name}-key.pem" \
    -out "${cert_name}.csr"
  # Sign the certificate request and create a certificate.
  openssl x509 -req \
    -in "${cert_name}.csr" \
    -CA "${root_ca}" \
    -CAkey "${root_ca_key}" \
    -CAcreateserial \
    -sha256 \
    -out "${cert_name}.pem"
  # Clean up.
  rm "${cert_name}-key-temp.pem" "${cert_name}.csr" "csr-temp.cnf"
}

gen_ca_pair
generate_cert_pair "root-ca.pem" "root-ca-key.pem" "admin"
generate_cert_pair "root-ca.pem" "root-ca-key.pem" "node1"
generate_cert_pair "root-ca.pem" "root-ca-key.pem" "node2"
