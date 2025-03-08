#!/bin/bash

# Verificar se o nome do backup foi passado como argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <nome_do_arquivo_de_backup.sql.gz>"
  exit 1
fi

# Configurações
BACKUP_DIR="/var/lib/postgresql/backups"
FILENAME="$1"
COMPRESSED_FILEPATH="$BACKUP_DIR/$FILENAME"
UNCOMPRESSED_FILEPATH="${COMPRESSED_FILEPATH%.gz}"

# Criar diretório de backup caso não exista
mkdir -p $BACKUP_DIR

# Baixar o backup compactado do S3 compatível
echo "Baixando o backup do S3..."
aws s3 cp "s3://$BUCKET_NAME/$FILENAME" "$COMPRESSED_FILEPATH" --endpoint-url "$S3_ENDPOINT"

# Verificar se o download foi bem-sucedido
if [ ! -f "$COMPRESSED_FILEPATH" ]; then
  echo "Erro: O arquivo de backup não foi baixado corretamente."
  exit 1
fi

# Descomprimir o arquivo
echo "Descomprimindo o arquivo de backup..."
gunzip -c "$COMPRESSED_FILEPATH" > "$UNCOMPRESSED_FILEPATH"

# Restaurar o banco de dados
echo "Restaurando o banco de dados..."
pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists "$UNCOMPRESSED_FILEPATH"

# Limpar arquivos temporários
rm "$COMPRESSED_FILEPATH" "$UNCOMPRESSED_FILEPATH"

echo "Restauração concluída com sucesso!"
