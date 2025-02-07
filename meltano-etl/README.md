# Pipeline de dados com Meltano, Airflow e PostgreSQL #

Este projeto visa contruir uma pipeline de dados utilizando as seguinte ferramentas: Apache Airflow, Meltano e Postgres. 

A pipeline possui duas etapas que podem ser realizadas separadamente.

A primeira etapa extrai dados de um arquivo .csv e de uma base de dados no PostgreSQL, e então salva localmente o arquivo e as tabelas em formato .csv. Os dados são armazenados em diretórios nomeados com a data em foram extraídos.

A segunda etapa extrai os dados armazenados localmente e os carrega em outra base de dados do PostgreSQL como tabelas. A partir desse carregamento é possível fazer query SQL.

# Como executar a pipeline #

## Requisitos para executar a pipeline ##

Você deve ter instalado em sua máquina Docker, Docker Compose, Meltano e Python (Versão superior ou igual 3.9 e inferior ou igual a 3.11). Garanta que o pacote pip também esteja instalado e atualizado.

## Comandos ##

`git clone git@github.com:luana-r/code-challenge.git`

`cd code_challenge`

`chmod + pre-config.sh`

`source ./pre-config`

Step 1: Extrai arquivo .csv e tabelas do banco de dados e armazena localmente

`cd meltano-etl/my-meltano-project`

`meltano run tap-csv target-csv`

`meltano run tap-postgres target-postgres-to-csv`

Os dados serão armazenados na pasta code-challenge/local_data.

Step 2: Extrai arquivos .csv armazenados localmente e carrega para o banco de dados.

Antes de subir os dados é necessário limpar o banco de dados para não ocorrer conflito com tabelas de nomes iguais. Execute o script abaixo:

`chmod +x drop_table.sh`

`source ./drop_table.sh`

`cd meltano-etl/my-meltano-project`

`meltano run tap-csv-step2 target-postgres`

`meltano run tap-postgres-to-csv-step2 target-postgres`

Os dados serão carregados para o banco de dados que está rodando no container e pode ser acessado pela porta 5434.

# Execute uma query do SQL para verificar que as tabelas estão no banco de dados #

`psql -h localhost -U meltano -d warehouse --port 5434`

`password: meltano`

`\dt`

Esse comando irá mostrar todas as tabelas do banco de dados.

![image](https://github.com/user-attachments/assets/31ffc8c6-9829-4af2-86bd-7b922de6ca20)

`\q`
