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

`step 1: 
