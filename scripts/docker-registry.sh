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

#Stop registry
docker container stop registry

#Create directory to contain images
mkdir -p /srv/registry/data

#Start registry container
docker run -d --restart=always --name registry \
-v /etc/certs:/certs -v  /srv/registry:/var/lib/registry \
-e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/hub.example.local.crt \
-e REGISTRY_HTTP_TLS_KEY=/certs/hub.example.local.key \
-p 443:443 registry:2

#Troubleshoot insecure registry
if [ -f /etc/debian_version ]; then
    echo "Add and update Certificate"
    cp /etc/certs/$domain.crt /usr/local/share/ca-certificates/$domain.crt
    update-ca-certificates
else
    if [ -f /etc/redhat-release ]; then
        echo "Add and update Certificate"
        cp /etc/certs/$domain.crt /etc/pki/ca-trust/source/anchors/$domain.crt
        update-ca-trust
    else
        echo "Distro hasn't been supported by this certs"
    fi
fi

#Restart docker
systemctl restart docker
