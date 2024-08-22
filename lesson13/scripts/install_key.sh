#! /bin/bash

if [ -f /home/vagrant/id_ecdsa.pub ]; then
    echo ">> Install ssh key"
    cat /home/vagrant/id_ecdsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 644 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant/.ssh
fi
