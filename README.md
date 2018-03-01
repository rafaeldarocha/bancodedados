# PostgreSQL

Versão alfa

## Tabela de conteúdos

  * [Indentação](#indenta%C3%A7%C3%A3o)
  * [Tabelas](#tabelas)
  * [Colunas reservadas](#colunas-reservadas)
  * [Enumeradores](#enumeradores)
  * [Chaves, índices e sequências](#chaves-%C3%ADndices-e-sequ%C3%AAncias)
  * [Funções](#fun%C3%A7%C3%B5es)
  * [Gatilhos](#gatilhos)
  * [Procedimentos armazenados](#procedimentos-armazenados)
  * [Ambiente](#ambiente)
    * [Git](#git)
    * [Docker](#docker)
    * [Visual Studio Code](#visual-studio-code)
  * [Próximos passos](#pr%C3%B3ximos-passos)

## Indentação

```SQL
-- Em breve

SELECT
    id_usuario,
    nome
FROM usuarios
WHERE
    id_usuario = 1;
```

## Tabelas

  * Entidades `{nome da entidade no plural}`.
  * Relacionar duas entidades `{nome da tabela pai}_{nome da tabela filha}`.
  * Auditoria `{nome da tabela}_operacoes`.

| Versão | Tabela | Descrição | Relacionamento |
| --- | --- | --- | --- |
| 0.0 | `empresas` | Empresas | n empresas |
| 0.0 | `filiais` | Filiais do grupo | n filiais para 1 grupo |
| 0.0 | `funcoes` | Funções | n funções |
| 0.0 | `grupos` | Grupos da empresa | n grupos para 1 empresa |
| 0.0 | `usuarios` | Usuários | n usuários |
| 0.0 | `usuarios_filiais` | Filiais dos usuários | n filiais para m usuários |
| 0.0 | `usuarios_funcoes` | Funções dos usuários | n funções para m usuários |
| 0.0 | `usuarios_operacoes` | Operações do usuário | n operações para 1 usuário |

## Colunas reservadas

| Versão | Coluna | Descrição | Tipo | Nulo |
| --- | --- | --- | --- | --- |
| 0.0 | `alterado` | Data de alteração do registro | `TIMESTAMP` | Não |
| 0.0 | `ativado` | Permissão lógica do registro | `BOOLEAN` | Não |
| 0.0 | `cnpj` | Cadastro nacional de pessoa jurídica | `TEXT` | Não |
| 0.0 | `cpf` | Cadastro de pessoa física | `TEXT` | Não |
| 0.0 | `criado` | Data de criação do registro | `TIMESTAMP` | Não |
| 0.0 | `deletado` | Data de deleção lógica do registro | `TIMESTAMP` | Sim |
| 0.0 | `id_{nome da entidade}` | Chave primária ou estrangeira | `SMALLINT`, `INTEGER` e `BIGINT` | Não |
| 0.0 | `id_autor` | Identificador do autor da requisição | `INTEGER` | Não |
| 0.0 | `ip` | Endereço de rede do autor da requisição | `INET` | Não |
| 0.0 | `nome` | Nome | `TEXT` | Não |
| 0.0 | `tipo` | Enumerador iniciado em 1 | `SMALLINT` | Não |

## Enumeradores

| Versão | Tabela | Coluna | Valor | Descrição |
| --- | --- | --- | --- | --- |
| 0.0 | `{nome da tabela}_operacoes` | `operacao` | 1 | Inserir |
| 0.0 | `{nome da tabela}_operacoes` | `operacao` | 2 | Atualizar |
| 0.0 | `{nome da tabela}_operacoes` | `operacao` | 3 | Apagar |
| 0.0 | `usuarios` | `tipo` | 1 | Usuário |
| 0.0 | `usuarios` | `tipo` | 2 | Supervisor |
| 0.0 | `usuarios` | `tipo` | 3 | Administrador |

## Chaves, índices e sequências

  * Chaves primárias `{nome da tabela}_pkey`.
  * Chaves estrangeiras `{nome da tabela}_{nome da coluna}_fkey`.
  * Chaves de consistência `{nome da tabela}_{nome da coluna}_key`.
  * Sequências `{nome da tabela}_{nome da coluna}_seq`.
  * Índices `{nome da tabela}_{nome da coluna}_idx`.

| Versão | Objeto | Descrição |
| --- | --- | --- |
| 0.0 | `empresas_pkey` | Chave primária |
| 0.0 | `empresas_id_empresa_seq` | Sequência |
| 0.0 | `filiais_pkey` | Chave primária |
| 0.0 | `filiais_id_filial_seq` | Sequência |
| 0.0 | `filiais_id_grupo_fkey` | Chave estrangeira |
| 0.0 | `funcoes_pkey` | Chave primária |
| 0.0 | `funcoes_id_funcao_seq` | Sequência |
| 0.0 | `grupos_pkey` | Chave primária |
| 0.0 | `grupos_id_grupo_seq` | Sequência |
| 0.0 | `grupos_id_empresa_fkey` | Chave estrangeira |
| 0.0 | `usuarios_pkey` | Chave primária |
| 0.0 | `usuarios_id_usuario_seq` | Sequência |
| 0.0 | `usuarios_usuario_key` | Unicidade |
| 0.0 | `usuarios_filiais_pkey` | Chave primária |
| 0.0 | `usuarios_filiais_id_usuario_fkey` | Chave estrangeira |
| 0.0 | `usuarios_filiais_id_filial_fkey` | Chave estrangeira |
| 0.0 | `usuarios_funcoes_pkey` | Chave primária |
| 0.0 | `usuarios_funcoes_id_usuario_fkey` | Chave estrangeira |
| 0.0 | `usuarios_funcoes_id_funcao_fkey` | Chave estrangeira |
| 0.0 | `usuarios_operacoes_pkey` | Chave primária |
| 0.0 | `usuarios_operacoes_id_operacao_seq` | Sequência |

## Funções

  * Genéricas `fn_{verbo}`.
  * Colunas computadas `fn_{nome da coluna}`.

| Versão | Função | Descrição |
| --- | --- | --- |
| 0.0 | `fn_chave` | Criar chave para registro |
| 0.0 | `fn_registrar` | Registrar operação na tabela de operações |
| 0.0 | `fn_senha` | Criar senha para registro |

## Gatilhos

  * Registrar operação na tabela de operações `tr_{nome da tabela}`.

| Versão | Gatilho | Descrição |
| --- | --- | --- |
| 0.0 | `tr_usuarios` | Registrar operação na tabela de operações |

## Procedimentos armazenados

Em breve.

## Ambiente

### Git

1. Instale o [Git para Windows](https://git-scm.com/download/win).

### Docker

| Comando | Descrição |
| --- | --- |
| `docker pull {nome da imagem}` | Baixar uma imagem |
| `docker images -a` | Listar imagens |
| `docker rmi {id}` | Apagar uma imagem |
| `docker ps -a` | Listar recipientes |
| `docker run {lista de parâmetros}` | Iniciar um recipiente |
| `docker rm --force {id}` | Apagar um recipiente |

1. Verifique se a virtualização está ativada no computador utilizando a aba desempenho do gerenciador de tarefas. Caso a virtualização esteja desativada é necessário ativa-lá nas configurações do processador na BIOS.

    ![Task manager](https://i.stack.imgur.com/q3SEr.png)

2. Instale o [Docker para Windows](https://www.docker.com/docker-windows).

### Visual Studio Code

1. (Recomendado) Instale a fonte de programação com ligaduras [Fira Code](https://github.com/tonsky/FiraCode/releases).

2. Instale e abra a pasta dedicada a projetos no [Visual Studio Code](https://code.visualstudio.com).

3. Abra as configurações do usuário <kbd>CTRL</kbd>+<kbd>,</kbd>.

4. Utilize as seguintes configurações do usuário.

    ```json
    {
        "editor.fontFamily": "Fira Code",
        "editor.fontSize": 14,
        "editor.fontLigatures": true,
        "editor.tabSize": 4,
        "editor.renderWhitespace": "all",
        "editor.insertSpaces": true,
        "editor.detectIndentation": false,
        "editor.formatOnSave": true,
        "files.insertFinalNewline": true,
        "pgsql.connection": "postgres://dev:Password1@localhost:5432/dev"
    }
    ```

5. Abra o terminal PowerShell integrado <kbd>CTRL</kbd>+<kbd>`</kbd>.

6. Instale a extensão [PostgreSQL](https://marketplace.visualstudio.com/items?itemName=JPTarquino.postgresql) no Visual Studio Code.

    ```powershell
    code --install-extension doublefint.pgsql
    ```

7. Baixe a imagem do [PostgreSQL](https://hub.docker.com/r/library/postgres/) no Docker.

    ```powershell
    docker pull postgres
    ```

8. Inicie um recipiente PostgreSQL no Docker.

    ```powershell
    docker run --name postgres-dev -e POSTGRES_USER=dev -e POSTGRES_PASSWORD=Password1 -p 5432:5432 -d postgres

    # Verifique se o recipiente está ativo
    # docker ps -a
    ```

9. Baixe o projeto e abra o arquivo `postgre.sql`.

    ```git
    git clone https://github.com/incompletude/database-slingshot.git
    ```

10. Abra a paleta de comandos <kbd>CTRL</kbd>+<kbd>SHIFT</kbd>+<kbd>P</kbd> e execute o arquivo `postgre.sql` escolhendo o comando `run in postgres`.

## Próximos passos

  * Escalabilidade com partições.
