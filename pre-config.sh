#!/bin/bash

# Lista de diretórios onde a pasta com a data atual deve ser criada
DIRS=("categories" "customer_customer_demo" "customer_demographics" "customers" "employee_territories" "employees" "orders" "products" "region" "shippers" "suppliers" "territories" "us_states")

# Obtém a data atual no formato YYYY-MM-DD
DATE=$(date +%Y-%m-%d)

OUTPUT_DIR="./local_data/csv/$DATE"
  if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
    echo "Diretório $OUTPUT_DIR criado."
  fi
# Loop para criar o subdiretório com a data atual em cada diretório da lista
for dir in "${DIRS[@]}"; do
  # Define o caminho completo
  OUTPUT_DIR="./local_data/postgres/$dir/$DATE"

  # Verifica se o diretório já existe; se não, cria
  if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
    echo "Diretório $OUTPUT_DIR criado."
  fi
done