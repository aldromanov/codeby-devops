#!/bin/bash

echo ">> Installing apache and setting up configuration"
apt-get update
apt-get install -y apache2

touch /root/.rnd
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/rad.key -out /etc/ssl/certs/rad.crt -subj "/CN=rad.local" -addext "subjectAltName=DNS:rad.local,DNS:www.rad.local"

cp /etc/ssl/certs/rad.crt /vagrant
chown vagrant:vagrant /vagrant/rad.crt

cp /vagrant/rad.conf /etc/apache2/sites-available/rad.conf

a2enmod ssl
a2ensite rad.conf

systemctl restart apache2
