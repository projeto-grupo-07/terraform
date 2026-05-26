#!/bin/bash

sleep 60

apt-get update -y
apt-get install -y cron msmtp msmtp-mta

# Configura msmtp globalmente
cat > /etc/msmtprc <<EOF
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        /var/log/msmtp.log

account        gmail
host           smtp.gmail.com
port           587
from           ${gmail_user}
user           ${gmail_user}
password       ${gmail_password}

account default : gmail
EOF

chmod 644 /etc/msmtprc

systemctl enable cron
systemctl start cron

ARQUIVO_SCRIPT="/backup/backup.sh"
LOG_BACKUP="/var/log/backup.log"

touch $LOG_BACKUP
chmod 666 $LOG_BACKUP

chmod +x $ARQUIVO_SCRIPT

CRON_JOB="* * * * * root bash $ARQUIVO_SCRIPT"

echo "$CRON_JOB" > /etc/cron.d/backup-mysql
chown root:root /etc/cron.d/backup-mysql
chmod 644 /etc/cron.d/backup-mysql

systemctl restart cron

echo "Cron e msmtp configurados com sucesso."