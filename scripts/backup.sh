#!/bin/bash

# Configurações
BACKUP_DIR="/var/lib/postgresql/backups"
TIMESTAMP=$(date +"%Y%m%d%H%M")
FILENAME="backup_$TIMESTAMP.sql"
COMPRESSED_FILENAME="$FILENAME.gz"
FILEPATH="$BACKUP_DIR/$FILENAME"
COMPRESSED_FILEPATH="$BACKUP_DIR/$COMPRESSED_FILENAME"

# Criar diretório de backup
mkdir -p $BACKUP_DIR

# Gerar backup do PostgreSQL
pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -F c -f "$FILEPATH"

# Comprimir o arquivo de backup
gzip -c "$FILEPATH" > "$COMPRESSED_FILEPATH"

# Enviar arquivo comprimido para o armazenamento S3 compatível
aws s3 cp "$COMPRESSED_FILEPATH" "s3://$BUCKET_NAME/$COMPRESSED_FILENAME" --endpoint-url "$S3_ENDPOINT"

# Remover arquivos temporários
rm "$FILEPATH" "$COMPRESSED_FILEPATH"

# Mensagem de confirmação
echo "Backup realizado, comprimido e enviado para S3 compatível: s3://$BUCKET_NAME/$COMPRESSED_FILENAME"
