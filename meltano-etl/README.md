# Pipeline de dados com Meltano, Airflow e PostgreSQL #

Este projeto visa contruir uma pipeline de dados utilizam as seguinte ferramentas: Apache Airflow, Meltano e Postgres. 

A pipeline possui duas etapas que podem ser realizadas separadamente.

A primeira etapa extrai dados de um arquivo .csv e de uma base de dados no PostgreSQL, e então salva localmente o arquivo e as tabelas em formato .csv. Os dados são armazenados em diretórios nomeados com a data em foram extraídos.

A segunda etapa extrai os dados armazenados localmente e os carrega em outra base de dados do PostgreSQL como tabelas. A partir desse carregamento é possível fazer query SQL.

# Como executar a pipeline #

## Requisitos para executar a pipeline ##

Você deve ter instalado em sua máquina Docker, Docker Compose e Python (Versão superior ou igual 3.9 e inferior ou igual a 3.11). Garanta que o pacote pip também esteja instalado e atualizado.

## Comandos ##

git 