FROM postgres:latest

# Definir variáveis de ambiente
ENV BACKUP_DIR="/var/lib/postgresql/backups"

# Instalar AWS CLI e Cron
RUN apt-get update && apt-get install -y awscli cron

# Criar diretório de backups
RUN mkdir -p $BACKUP_DIR && chown postgres:postgres $BACKUP_DIR

# Copiar scripts para o contêiner
COPY scripts/backup.sh /scripts/backup.sh
COPY scripts/restore.sh /scripts/restore.sh
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /scripts/backup.sh /scripts/restore.sh /entrypoint.sh

# Definir entrypoint personalizado
ENTRYPOINT ["/entrypoint.sh"]
