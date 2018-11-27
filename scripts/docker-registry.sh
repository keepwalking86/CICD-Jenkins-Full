#!/bin/bash
domain=hub.example.local
commonname=$domain
country=VN
state=HN
locality=HN
organization=$domain
organizationalunit=IT
email=keepwalking86@example.local

#Generate a self-signed certificate
echo "Generate a self-signed certificate for $domain"
mkdir -p /etc/certs && cd /etc/certs
openssl req -newkey rsa:4096 -nodes -sha256 -keyout $domain.key \
-x509 -days 365 -out $domain.crt \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

#setting insecure-registries
cat >/etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["$domain:5000"]
}
EOF