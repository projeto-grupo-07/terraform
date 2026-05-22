#!/bin/bash

set -e

sleep 60

sudo apt update
sudo apt install -y cron

sudo systemctl enable cron
sudo systemctl start cron

USUARIO="ubuntu"
ARQUIVO_SCRIPT="/backup/backup.sh"
ARQUIVO_LOG="/var/log/backup_diario_cron.log"

sudo touch $ARQUIVO_LOG
sudo chmod 666 $ARQUIVO_LOG

CRON_JOB="0 02 * * * sh $ARQUIVO_SCRIPT >> $ARQUIVO_LOG 2>&1"

echo "cron job criado:"
echo "$CRON_JOB"

echo "$CRON_JOB" | sudo tee /var/spool/cron/crontabs/ubuntu > /dev/null

sudo chown ubuntu:crontab /var/spool/cron/crontabs/ubuntu
sudo chmod 600 /var/spool/cron/crontabs/ubuntu

sudo systemctl restart cron