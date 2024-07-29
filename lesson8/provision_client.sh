#!/bin/bash

echo ">> Adding domain and updating certificate"
echo -e "192.168.56.201    rad.local\n192.168.56.201    www.rad.local" >> /etc/hosts
mkdir -p /usr/local/share/ca-certificates
cp /vagrant/rad.crt /usr/local/share/ca-certificates/rad.crt
update-ca-certificates
