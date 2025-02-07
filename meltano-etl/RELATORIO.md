## Relatório Desafio Indicium ##

Após o primeiro entendimento do desafio a expectativa inicial era rodar as ferramentas da pipeline em containers para evitar
conflito de dependências e para facilitar a execução da pipeline por qualquer usuário com qualquer configuração de máquina. 

Além de rodar em containers, o planejamento inicial era executar a pipeline por meio de scripts bash, cada comando iria retornar
fail ou success e indicar se os próximos comandos da pipe deveriam ser executados. Ou seja, com o script seria fácil implementar
em cada tarefa um requisito "depends on" onde ela só é executada se a tarefa anterior for bem sucedida.

## As tarefas macros identificadas logo após o entendimento do desafio: ##

`A pipeline deve ser capaz de subir dois banco de dados: source e destination`

O banco de dados de origem já está setado no desafio e deve subir com o docker-compose. O desafio é implementar outro banco de
dados no PostgreSQL para armazenar as tabelas, nesse momento idenfiquei que o banco de dados de destino deveria estar vazio sempre
que fosse fazer um novo carregamento para evitar conflitos de tabelas de mesmo nome. Assim, implementei um script "drop_table" para
garantir esse requisito. O banco de dados de destino é criado no script "pre-config.sh", e roda na porta 5434 do localhost.

`Estrutura de pastas do armazenamento local`

Como deve-se separar a extração de dados por datas para que seja possível acessar dados de dias anteriores, é necessário 
criar uma estrutura de pastas para armazenamento. O script "pre-config.sh" cria dentro dos diretórios local_data/csv e 
local_data/postgres pastas nomeadas com a data atual, dessa forma a extração de dados do dia será armazenada e identificada
corretamente.

`Criação da Step 1: Extrai arquivo .csv e tabelas do banco de dados e armazena localmente`

Todo o entendimento de extração e carregamento de dados foi feito por meio da documentação do meltano, os plugins extractor e loaders possuem fácil manuseio.
Para a extração segui este tutorial: https://docs.meltano.com/getting-started/part1 subtituindo pelo tap-csv.
Para o carregamento segui este tutorial: https://docs.meltano.com/getting-started/part2 e aqui ele sugeriu que o banco de 
dados de destino estivesse num container.

Os dados são armazenados localmente no formato .csv pela fácil manipulação do arquivo e pela abrangência de documentação do
plugin de target-csv do Meltano.

`Step 2: Extrai arquivos .csv armazenados localmente e carrega para o banco de dados.`

Para o step2 segui os mesmos tutoriais do Meltano, incluindo o detalhamento de cada plugin: target-postgres e tap-csv.

## Requisitos obrigatórios do desafio ##

### Você deve usar as ferramentas descritas acima para completar o desafio. ###

Meltano e PostgreSQL foram utilizados. Infelizmente, ao instalar o Airflow via utility do Meltano a instalação não foi bem sucedida pois requer python inferior a 3.12, como só consigo realizar o desafio no workspace do github só me atentei a isso no último dia do desafio e não foi possível implementar o airflow. A solução seria alterar as configurações do container
do workspace do github e criar um novo workspace com o python 3.11 instalado.

`  utilities:
  - name: airflow
    variant: apache
    pip_url: git+https://github.com/meltano/airflow-ext.git@main apache-airflow==2.8.1
      --constraint 
      https://raw.githubusercontent.com/apache/airflow/constraints-2.8.1/constraints-no-providers-3.11.txt`

O arquivo de config para a versão 3.12 não existe https://raw.githubusercontent.com/apache/airflow/constraints-2.8.1/constraints-no-providers-3.12.txt

### Todas as tarefas devem ser idempotentes, você deve ser capaz de executar o pipeline todos os dias e, neste caso em que os dados são estáticos, a saída deve ser a mesma. ###

Todos os dados são extraídos da mesma forma toda a vez que a pipeline é executada, e são armazenados tanto localmente quanto no PostgreSQL com o cuidado de excluir tabelas já existentes.

### A etapa 2 depende de ambas as tarefas da etapa 1, portanto, você não poderá executar a etapa 2 por um dia se as tarefas da etapa 1 não forem bem-sucedidas. ###

A ideia inicial era incluir num script bash a execução do step1 e step2, sendo que o step2 iria ter uma condição de "dependsOn" para garantir que só fosse iniciado se step1 fosse bem sucedido.

### Você deve extrair todas as tabelas do banco de dados de origem, não importa que você não use a maioria delas para a etapa final. ###

Todas as tabelas são estraídas do banco de dados e armazenadas localmente através do comando `meltano run meltano run tap-postgres target-postgres-to-csv`

### Você deve ser capaz de dizer onde o pipeline falhou claramente, para saber de qual etapa você deve executar novamente o pipeline. ###

O script principal iria executar tarefa por tarefa e imprimir mensagens de erros caso o retorno do Meltano indicasse alguma
falha, assim seria possível corrigir os erros.
Além dos erros do meltano, também deve-se incluir mensagens de erros para a criação das pastas, criação e run dos containers e exclusão das tabelas no banco de dados.

### Você deve fornecer evidências de que o processo foi concluído com sucesso, ou seja, você deve fornecer um csv ou json com o resultado da consulta descrita acima. ###

Não consegui fazer a consulta SQL e salvar num arquivo, porém há um print no README que mostra todas as tabelas no banco de dados do destino.

### Seu pipeline deve estar preparado para ser executado nos últimos dias, o que significa que você deve ser capaz de passar um argumento para o pipeline com um dia do passado e ele deve reprocessar os dados desse dia. Como os dados desse desafio são estáticos, a única diferença para cada dia de execução serão os caminhos de saída. ###

Esta etapa é garantida pela variável de ambiente DATE no script de pre-config. A ideia inicial era ter um script para a step2 em que o valor default de DATE seria o dia atual, porém se o usuário passar um valor de DATE passado então o step2 iria rodar para essa data. Por exemplo, se o usuário rodar o script `export DATE="2025-02-06" ./start_step2.sh`, os comandos do meltanto run iriam fazer a extração nas pastas:
`local_data/csv/$DATE/` e `local_data/postgres/$DATE`
