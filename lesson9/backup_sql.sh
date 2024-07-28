#! /bin/bash
echo ">> Start backup"
BACKUP_DIR="/opt/mysql_backup"
BACKUP_NAME="rad-$(date +'%Y%m%d-%H%M%S').sql"
BACKUP_DB="rad_db"

sudo mysqldump -u vagrant -pvagrant $BACKUP_DB > $BACKUP_DIR/$BACKUP_NAME
echo ">> Create backup $BACKUP_NAME"