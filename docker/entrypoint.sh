#!/bin/bash

# Definir um cron padrão caso a variável não esteja definida
CRON_SCHEDULE="${CRON_SCHEDULE:-0 */4 * * *}"

# Criar o arquivo do cron job
echo "$CRON_SCHEDULE postgres /scripts/backup.sh" > /etc/cron.d/backup-cron

# Aplicar permissões corretas e recarregar o cron
chmod 0644 /etc/cron.d/backup-cron
crontab /etc/cron.d/backup-cron

# Iniciar o cron e o PostgreSQL
cron && docker-entrypoint.sh postgres
