#!/bin/env bash

YUM_REPO="/etc/yum.repos.d/CentOS-Base.repo"

if [ -f /home/vagrant/yum ]; then
    echo ">> Update yum"
    cat /home/vagrant/yum | sudo tee "$YUM_REPO"
fi
