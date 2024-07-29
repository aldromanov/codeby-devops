#! /bin/bash
echo ">> Start of transfer"
BACKUP_DIR="/opt/mysql_backup"
REMOTE_DIR="/opt/store/mysql"

rsync -avz -e "ssh -i /home/vagrant/.ssh/id_rsa" $BACKUP_DIR/ vagrant@192.168.56.202:/$REMOTE_DIR/
echo ">> End of transfer"