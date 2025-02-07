#!/bin/bash

# Defina as variáveis de conexão
DB_NAME="warehouse"  # Substitua pelo nome do seu banco de dados
DB_USER="meltano"       # Substitua pelo usuário do banco de dados
DB_HOST="localhost"      # Substitua pelo host do banco de dados (localhost, por exemplo)
DB_PORT="5434"           # Substitua pela porta do banco de dados (se diferente)
export PGPASSWORD="meltano" # Substitua pela senha do usuário do banco de dados
# Conectando ao banco de dados e obtendo uma lista das tabelas
TABLES=$(psql -h $DB_HOST -U $DB_USER -d $DB_NAME --port 5434 -t -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';")

# Iterando sobre as tabelas e excluindo-as
for TABLE in $TABLES; do
  if [ "$TABLE" != "" ]; then
    echo "Excluindo tabela: $TABLE"
    psql -h $DB_HOST -U $DB_USER -d $DB_NAME --port 5434 -c "DROP TABLE IF EXISTS public.$TABLE CASCADE;"
  fi
done