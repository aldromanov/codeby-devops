#! /bin/bash

if [ -f /vagrant/id_ecdsa.pub ]; then
    echo ">> Copy ssh key"
    mkdir -p /home/vagrant/.ssh
    cp /vagrant/id_ecdsa.pub /home/vagrant/
    chown -R vagrant:vagrant /home/vagrant/id_ecdsa.pub
fi

