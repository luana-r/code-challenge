#!/bin/bash

# Lista de diretórios onde a pasta com a data atual deve ser criada
DIRS=("csv" "postgres")

# Obtém a data atual no formato YYYY-MM-DD
DATE=$(date +%Y-%m-%d)

# Loop para criar o subdiretório com a data atual 
for dir in "${DIRS[@]}"; do
  # Define o caminho completo
  OUTPUT_DIR="./local_data/$dir/$DATE"

  # Verifica se o diretório já existe; se não, cria
  if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
    echo "Diretório $OUTPUT_DIR criado."
  fi
done

export DATE=$(date +%Y-%m-%d)

#docker run --name postgres -e POSTGRES_PASSWORD=meltano -e POSTGRES_USER=meltano -e POSTGRES_DB=warehouse -d -p 5434:5432 -v ./db_destino:/var/lib/postgresql/data postgres