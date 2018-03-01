/* Geral */

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE EXTENSION pgcrypto;
CREATE EXTENSION unaccent;


/* Tabelas */

CREATE TABLE usuarios (

    id_usuario SERIAL NOT NULL,

    usuario TEXT NOT NULL,
    senha TEXT NOT NULL,
    chave TEXT NOT NULL,
    tipo SMALLINT NOT NULL,
    ativado BOOLEAN NOT NULL,
    criado TIMESTAMP NOT NULL,

    id_autor INTEGER NOT NULL,
    ip INET NOT NULL,
    alterado TIMESTAMP NOT NULL,

    UNIQUE (usuario),
    PRIMARY KEY (id_usuario)

);

CREATE TABLE funcoes (

    id_funcao SMALLSERIAL NOT NULL,

    nome TEXT NOT NULL,

    PRIMARY KEY (id_funcao)

);

CREATE TABLE usuarios_funcoes (

    id_usuario INTEGER NOT NULL,
    id_funcao SMALLINT NOT NULL,

    PRIMARY KEY (id_usuario, id_funcao),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_funcao) REFERENCES funcoes(id_funcao)

);

CREATE TABLE empresas (

    id_empresa SMALLSERIAL NOT NULL,

    nome TEXT NOT NULL,
    sigla TEXT NOT NULL,

    PRIMARY KEY (id_empresa)

);

CREATE TABLE grupos (

    id_grupo SMALLSERIAL NOT NULL,
    id_empresa SMALLINT NOT NULL,

    nome TEXT NOT NULL,

    PRIMARY KEY (id_grupo),
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)

);

CREATE TABLE filiais (

    id_filial SMALLSERIAL NOT NULL,
    id_grupo SMALLINT NOT NULL,

    nome TEXT NOT NULL,
    sigla TEXT NOT NULL,

    PRIMARY KEY(id_filial),
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)

);

CREATE TABLE usuarios_filiais (

    id_usuario INTEGER NOT NULL,
    id_filial SMALLINT NOT NULL,

    PRIMARY KEY (id_usuario, id_filial),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_filial) REFERENCES filiais(id_filial)

);


/* Operações */

CREATE FUNCTION fn_registrar()
RETURNS TRIGGER AS $$
DECLARE
    table_name TEXT;
BEGIN

    SELECT TG_TABLE_NAME
    INTO table_name;

    IF (TG_OP = 'INSERT') THEN

        EXECUTE FORMAT('
            INSERT INTO %s
            VALUES (
                DEFAULT,
                1,
                $1.*
            );
            ',
            table_name || '_operacoes'
        ) USING NEW;

    ELSIF (TG_OP = 'UPDATE') THEN

        EXECUTE FORMAT('
            INSERT INTO %s
            VALUES (
                DEFAULT,
                2,
                $1.*
            );
            ',
            table_name || '_operacoes'
        ) USING NEW;

    ELSIF (TG_OP = 'DELETE') THEN

        EXECUTE FORMAT('
            INSERT INTO %s
            VALUES (
                DEFAULT,
                3,
                $1.*
            );
            ',
            table_name || '_operacoes'
        ) USING OLD;

    END IF;

    RETURN NULL;

END; $$
LANGUAGE 'plpgsql';

CREATE TABLE usuarios_operacoes (

    id_operacao BIGSERIAL NOT NULL,

    operacao SMALLINT NOT NULL,

    id_usuario INTEGER NOT NULL,

    usuario TEXT NOT NULL,
    senha TEXT NOT NULL,
    chave TEXT NOT NULL,
    tipo SMALLINT NOT NULL,
    ativado BOOLEAN NOT NULL,
    criado TIMESTAMP NOT NULL,

    id_autor INTEGER NOT NULL,
    ip INET NOT NULL,
    alterado TIMESTAMP NOT NULL,

    PRIMARY KEY (id_operacao)

);

CREATE TRIGGER tr_usuarios
AFTER INSERT OR UPDATE OR DELETE
ON usuarios
FOR EACH ROW
EXECUTE PROCEDURE fn_registrar();


/* Funções */

CREATE FUNCTION fn_senha(senha TEXT)
RETURNS TEXT AS $$
BEGIN

    RETURN CRYPT(senha, GEN_SALT('BF', 8));

END; $$
LANGUAGE 'plpgsql';

CREATE FUNCTION fn_chave()
RETURNS TEXT AS $$
BEGIN

    RETURN ENCODE(DIGEST(GEN_SALT('BF', 8), 'SHA512'), 'HEX');

END; $$
LANGUAGE 'plpgsql';


/* Teste */

INSERT INTO usuarios
VALUES (
    DEFAULT,
    'dev',
    fn_senha('Password1'),
    fn_chave(),
    1,
    TRUE,
    CURRENT_TIMESTAMP,
    1,
    '127.0.0.1',
    CURRENT_TIMESTAMP
) RETURNING *;

INSERT INTO funcoes
VALUES (
    DEFAULT,
    'Função teste'
) RETURNING *;

INSERT INTO usuarios_funcoes
VALUES (
    1,
    1
) RETURNING *;

INSERT INTO empresas
VALUES (
    DEFAULT,
    'Empresa Teste',
    'ET'
) RETURNING *;

INSERT INTO grupos
VALUES (
    DEFAULT,
    1,
    'Grupo Teste'
)
RETURNING *;

INSERT INTO filiais
VALUES (
    DEFAULT,
    1,
    'Filial Teste',
    'FT'
)
RETURNING *;

INSERT INTO usuarios_filiais
VALUES (
    1,
    1
)
RETURNING *;
