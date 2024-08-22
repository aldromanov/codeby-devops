#! /bin/bash

if [ -f /vagrant/yum ]; then
    echo ">> Copy yum"
    cp /vagrant/yum /home/vagrant/
    chown -R vagrant:vagrant /home/vagrant/yum
fi
