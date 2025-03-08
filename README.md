# PostgreSQL Backup com Upload para S3 Compatível

## 🚀 Instalação e Configuração

### 1️⃣ **Configurar as variáveis de ambiente**

```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações.

### 2️⃣ **Construir a imagem Docker**

```bash
docker build -t postgres-backup -f docker/Dockerfile .
```

### 3️⃣ **Iniciar o container**

```bash
docker-compose up -d
```

## 🔄 Backup Manual

Caso queira executar um backup manualmente, rode o seguinte comando:

```bash
docker exec -it postgres-backup /scripts/backup.sh
```

Isso irá criar um novo arquivo de backup compactado (.gz) e enviá-lo ao S3.

---

## ♻️ Restaurar um Backup do S3

### 1️⃣ **Listar os backups armazenados no S3**

Para ver os backups disponíveis no bucket:

```bash
docker exec -it postgres-backup aws s3 ls s3://$BUCKET_NAME --endpoint-url "$S3_ENDPOINT"
```

Isso mostrará a lista de arquivos de backup compactados salvos no S3.

### 2️⃣ **Restaurar um backup específico**

Escolha um dos arquivos listados e execute:

```bash

docker exec -it postgres-backup /scripts/restore.sh nome_do_arquivo.sql.gz
```

Por exemplo:

```bash
docker exec -it postgres-backup /scripts/restore.sh backup_20250308.sql.gz
```

Isso irá:

1. Baixar o arquivo compactado do S3
2. Descomprimir o arquivo automaticamente
3. Restaurar o banco de dados
4. Limpar os arquivos temporários

---

## 📂 Estrutura do Projeto

```plaintext
postgres-backup/
│── docker/
│   ├── Dockerfile        # Dockerfile personalizado
│   ├── entrypoint.sh     # Script de entrada para configurar o cron
│── scripts/
│   ├── backup.sh         # Script de backup, compressão e envio para S3
│   ├── restore.sh        # Script de restauração do backup compactado
│── .env.example          # Exemplo de variáveis de ambiente
│── docker-compose.yml    # Arquivo opcional para execução
│── README.md            # Documentação do projeto
```
