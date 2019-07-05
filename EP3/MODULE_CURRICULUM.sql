/*
Next lines checks if you have permission to create extensions
and:
	*create two extensions: pgcrypto for password and citext for email check
	*create a role dba and a schema admins
	*grant permissions to dba over admins
*/

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
-- For security create admin schema as well
CREATE ROLE dba
	WITH SUPERUSER CREATEDB CREATEROLE
	LOGIN ENCRYPTED PASSWORD 'dba1234'
	VALID UNTIL '2019-07-01';
CREATE SCHEMA IF NOT EXISTS admins;
GRANT admins TO dba;

DROP DOMAIN IF EXISTS email CASCADE;
CREATE DOMAIN email AS citext
	CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

-- DDL
CREATE TABLE b05_Disciplina (
	dis_id SERIAL,
	dis_code varchar(7) NOT NULL,
	dis_name varchar(80),
	dis_class_creds integer,
	dis_work_creds integer,
	CONSTRAINT pk_disciplina PRIMARY KEY (dis_id),
	CONSTRAINT sk_disciplina UNIQUE (dis_code)
);

CREATE TABLE b06_Curso (
	cur_id SERIAL,
	cur_code integer NOT NULL,
	cur_name varchar(60),
	adm_cpf varchar(11) NOT NULL,
	ad_cur_date_in TIMESTAMP,
	ad_cur_date_out TIMESTAMP,
	CONSTRAINT pk_curso PRIMARY KEY (cur_id),
	CONSTRAINT sk_curso UNIQUE (cur_code),
	CONSTRAINT fk_adm FOREIGN KEY (adm_cpf)
		REFERENCES b04_Administrador(adm_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b07_Trilha (
	tr_id SERIAL,
	tr_name varchar(80) NOT NULL,
	CONSTRAINT pk_trilha PRIMARY KEY (tr_id),
	CONSTRAINT sk_trilha UNIQUE (tr_name)
);

CREATE TABLE b08_Modulo (
	mod_id SERIAL,
	mod_code integer NOT NULL,
	mod_name varchar(40),
	mod_cred_min integer,
	CONSTRAINT pk_modulo PRIMARY KEY (mod_id),
	CONSTRAINT sk_modulo UNIQUE (mod_code),
	CONSTRAINT cred_check CHECK (mod_cred_min > 0)
);

CREATE TABLE b12_rel_tr_mod (
	rel_tr_name varchar(80) NOT NULL,
	rel_mod_code integer NOT NULL,
	rel_tr_mod_mandatory boolean,
	CONSTRAINT pk_rel_tr_mod PRIMARY KEY (rel_tr_name, rel_mod_code),
	CONSTRAINT fk_tr_name FOREIGN KEY (rel_tr_name)
		REFERENCES b07_Trilha(tr_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_mod_code FOREIGN KEY (rel_mod_code)
		REFERENCES b08_Modulo(mod_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b13_rel_tr_cur (
	rel_tr_name varchar(80) NOT NULL,
	rel_cur_code integer NOT NULL,
	CONSTRAINT pk_rel_tr_cur PRIMARY KEY (rel_tr_name, rel_cur_code),
	CONSTRAINT fk_tr_name FOREIGN KEY (rel_tr_name)
		REFERENCES b07_Trilha(tr_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_cur_code FOREIGN KEY (rel_cur_code)
		REFERENCES b06_Curso(cur_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b18_rel_dis_mod (
	rel_dis_code varchar(7) NOT NULL,
	rel_mod_code integer NOT NULL,
	CONSTRAINT pk_rel_dis_mod PRIMARY KEY (rel_dis_code, rel_mod_code),
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_mod_code FOREIGN KEY (rel_mod_code)
		REFERENCES b08_Modulo(mod_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b19_rel_mod_cur (
	rel_mod_code integer NOT NULL,
	rel_cur_code integer NOT NULL,
	CONSTRAINT pk_rel_mod_cur PRIMARY KEY (rel_mod_code, rel_cur_code),
	CONSTRAINT fk_mod_code FOREIGN KEY (rel_mod_code)
		REFERENCES b08_Modulo(mod_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_cur_code FOREIGN KEY (rel_cur_code)
		REFERENCES b06_Curso(cur_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b24_rel_dis_dis (
	dis_code varchar(7) NOT NULL,
	dis_req_code varchar(7) NOT NULL,
	CONSTRAINT pk_rel_dis_dis PRIMARY KEY (dis_code, dis_req_code),
	CONSTRAINT fk_dis FOREIGN KEY (dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_req_dis FOREIGN KEY (dis_req_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

DROP TYPE IF EXISTS tr_mod_key CASCADE;
CREATE TYPE tr_mod_key AS (key1 varchar(80), key2 integer);

DROP TYPE IF EXISTS tr_cur_key CASCADE;
CREATE TYPE tr_cur_key AS (key1 varchar(80), key2 integer);

DROP TYPE IF EXISTS dis_mod_key CASCADE;
CREATE TYPE dis_mod_key AS (key1 varchar(7), key2 integer);

DROP TYPE IF EXISTS mod_cur_key CASCADE;
CREATE TYPE mod_cur_key AS (key1 integer, key2 integer);

DROP TYPE IF EXISTS rel_dis_dis_key CASCADE;
CREATE TYPE rel_dis_dis_key AS (key1 varchar(7), key2 varchar(7));

--CREATES
BEGIN;
CREATE OR REPLACE FUNCTION create_Disciplina(arg0 varchar(7), arg1 varchar(80), arg2 integer, arg3 integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ($1, $2, $3, $4)
	RETURNING dis_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Curso(arg0 integer, arg1 varchar(60), arg2 varchar(11), arg3 TIMESTAMP, arg4 TIMESTAMP)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ($1, $2, $3, $4, $5)
	RETURNING cur_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Trilha(arg0 varchar(80))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b07_Trilha (tr_name)
	VALUES ($1)
	RETURNING tr_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Modulo(arg0 integer, arg1 varchar(40), arg2 integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES ($1, $2, $3)
	RETURNING mod_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_tr_mod(arg0 varchar(80), arg1 integer, arg2 boolean)
RETURNS tr_mod_key AS
$$
DECLARE
id tr_mod_key;
BEGIN
	INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ($1, $2, $3)
	RETURNING rel_tr_name, rel_mod_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_tr_cur(arg0 varchar(80), arg1 integer)
RETURNS tr_cur_key AS
$$
DECLARE
id tr_cur_key;
BEGIN
	INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ($1, $2)
	RETURNING rel_tr_name, rel_cur_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_dis_mod(arg0 varchar(7), arg1 integer)
RETURNS dis_mod_key AS
$$
DECLARE
id dis_mod_key;
BEGIN
	INSERT INTO b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ($1, $2)
	RETURNING rel_dis_code, rel_mod_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_mod_cur(arg0 integer, arg1 integer)
RETURNS mod_cur_key AS
$$
DECLARE
id mod_cur_key;
BEGIN
	INSERT INTO b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES ($1, $2)
	RETURNING rel_mod_code, rel_cur_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_dis_dis(arg0 varchar(7), arg1 varchar(7))
RETURNS rel_dis_dis_key AS
$$
DECLARE
id rel_dis_dis_key;
BEGIN
	INSERT INTO b24_rel_dis_dis (dis_code, dis_req_code)
	VALUES ($1, $2)
	RETURNING dis_code, dis_req_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--DELETES
BEGIN;
CREATE OR REPLACE FUNCTION delete_Disciplina(key varchar(7))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b05_Disciplina
	WHERE dis_code = key
	RETURNING dis_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Curso(key integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b06_Curso
	WHERE cur_code = key
	RETURNING cur_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Trilha(key varchar(80))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b07_Trilha
	WHERE tr_name = key
	RETURNING tr_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Modulo(key integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b08_Modulo
	WHERE mod_code = key
	RETURNING mod_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;


BEGIN;
CREATE OR REPLACE FUNCTION delete_tr_mod(key1 varchar(80), key2 integer)
RETURNS tr_mod_key AS
$$
DECLARE
id tr_mod_key;
BEGIN
	DELETE FROM b12_rel_tr_mod
	WHERE rel_tr_name = key1 AND rel_mod_code = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_tr_cur(key1 varchar(80), key2 integer)
RETURNS tr_cur_key AS
$$
DECLARE
id tr_cur_key;
BEGIN
	DELETE FROM b13_rel_tr_cur
	WHERE rel_tr_name = key1 AND rel_cur_code = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_dis_mod(key1 varchar(7), key2 integer)
RETURNS dis_mod_key AS
$$
DECLARE
id dis_mod_key;
BEGIN
	DELETE FROM b18_rel_dis_mod
	WHERE rel_dis_code = key1 AND rel_mod_code = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_mod_cur(key1 integer, key2 integer)
RETURNS mod_cur_key AS
$$
DECLARE
id mod_cur_key;
BEGIN
	DELETE FROM b19_rel_mod_cur
	WHERE rel_mod_code = key1 AND rel_cur_code = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_dis_dis(key1 varchar(7), key2 varchar(7))
RETURNS rel_dis_dis_key AS
$$
DECLARE
id rel_dis_dis_key;
BEGIN
	DELETE FROM b24_rel_dis_dis
	WHERE dis_code = key1 AND dis_req_code = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--UPDATE
BEGIN;
CREATE OR REPLACE FUNCTION update_Disciplina_code(key varchar(7), new varchar(7))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b05_Disciplina
	SET dis_code = new
	WHERE dis_code = key
	RETURNING dis_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Disciplina_name(key varchar(7), new varchar(80))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b05_Disciplina
	SET dis_name = new
	WHERE dis_code = key
	RETURNING dis_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Disciplina_class_creds(key varchar(7), new integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b05_Disciplina
	SET dis_class_creds = new
	WHERE dis_code = key
	RETURNING dis_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Disciplina_work_creds(key varchar(7), new integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b05_Disciplina
	SET dis_work_creds = new
	WHERE dis_code = key
	RETURNING dis_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Curso_code(key integer, new integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b06_Curso
	SET cur_code = new
	WHERE cur_code = key
	RETURNING cur_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Curso_name(key integer, new varchar(60))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b06_Curso
	SET cur_name = new
	WHERE cur_code = key
	RETURNING cur_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Curso_adm(key integer, new varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b06_Curso
	SET adm_cpf = new
	WHERE cur_code = key
	RETURNING cur_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Trilha_name(key varchar(80), new varchar(80))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b07_Trilha
	SET tr_name = new
	WHERE tr_name = key
	RETURNING tr_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Modulo_code(key integer, new integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b08_Modulo
	SET mod_code = new
	WHERE mod_code = key
	RETURNING mod_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Modulo_name(key integer, new varchar(40))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b08_Modulo
	SET mod_name = new
	WHERE mod_code = key
	RETURNING mod_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Modulo_cred_min(key integer, new integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b08_Modulo
	SET mod_cred_min = new
	WHERE mod_code = key
	RETURNING mod_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Trilha_Modulo_tr_name(key1 varchar(80), key2 integer, new varchar(80))
RETURNS tr_mod_key AS
$$
DECLARE
id tr_mod_key;
BEGIN
	UPDATE b12_rel_tr_mod
	SET rel_tr_name = new
	WHERE rel_tr_name = key1 AND rel_mod_code = key2
	RETURNING rel_tr_name, rel_mod_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Trilha_Modulo_mod_code(key1 varchar(80), key2 integer, new integer)
RETURNS tr_mod_key AS
$$
DECLARE
id tr_mod_key;
BEGIN
	UPDATE b12_rel_tr_mod
	SET rel_mod_code = new
	WHERE rel_tr_name = key1 AND rel_mod_code = key2
	RETURNING rel_tr_name, rel_mod_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Trilha_Modulo_mandatory(key1 varchar(80), key2 integer, new boolean)
RETURNS tr_mod_key AS
$$
DECLARE
id tr_mod_key;
BEGIN
	UPDATE b12_rel_tr_mod
	SET rel_tr_mod_mandatory = new
	WHERE rel_tr_name = key1 AND rel_mod_code = key2
	RETURNING rel_tr_name, rel_mod_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Trilha_Curso_name(key1 varchar(80), key2 integer, new varchar(80))
RETURNS tr_mod_key AS
$$
DECLARE
id tr_mod_key;
BEGIN
	UPDATE b13_rel_tr_cur
	SET rel_tr_name = new
	WHERE rel_tr_name = key1 AND rel_cur_code = key2
	RETURNING rel_tr_name, rel_cur_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Trilha_Curso_code(key1 varchar(80), key2 integer, new integer)
RETURNS tr_mod_key AS
$$
DECLARE
id tr_mod_key;
BEGIN
	UPDATE b13_rel_tr_cur
	SET rel_cur_code = new
	WHERE rel_tr_name = key1 AND rel_cur_code = key2
	RETURNING rel_tr_name, rel_cur_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Disciplina_Modulo_dis_code(key1 varchar(7), key2 integer, new varchar(7))
RETURNS dis_mod_key AS
$$
DECLARE
id dis_mod_key;
BEGIN
	UPDATE b18_rel_dis_mod
	SET rel_dis_code = new
	WHERE rel_dis_code = key1 AND rel_mod_code = key2
	RETURNING rel_dis_code, rel_mod_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Disciplina_Modulo_dis_code(key1 varchar(7), key2 integer, new integer)
RETURNS dis_mod_key AS
$$
DECLARE
id dis_mod_key;
BEGIN
	UPDATE b18_rel_dis_mod
	SET rel_mod_code = new
	WHERE rel_dis_code = key1 AND rel_mod_code = key2
	RETURNING rel_dis_code, rel_mod_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Modulo_Curso_mod_code(key1 integer, key2 integer, new integer)
RETURNS mod_cur_key AS
$$
DECLARE
id mod_cur_key;
BEGIN
	UPDATE b19_rel_mod_cur
	SET rel_mod_code = new
	WHERE rel_mod_code = key1 AND rel_cur_code = key2
	RETURNING rel_mod_code, rel_cur_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Modulo_Curso_cur_code(key1 integer, key2 integer, new integer)
RETURNS mod_cur_key AS
$$
DECLARE
id mod_cur_key;
BEGIN
	UPDATE b19_rel_mod_cur
	SET rel_cur_code = new
	WHERE rel_mod_code = key1 AND rel_cur_code = key2
	RETURNING rel_mod_code, rel_cur_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Disciplina_Disciplina_dis_code(key1 varchar(7), key2 varchar(7), new varchar(7))
RETURNS rel_dis_dis_key AS
$$
DECLARE
id rel_dis_dis_key;
BEGIN
	UPDATE b24_rel_dis_dis
	SET dis_code = new
	WHERE dis_code = key1 AND dis_req_code = key2
	RETURNING  dis_code, dis_req_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Disciplina_Disciplina_dis_req_code(key1 varchar(7), key2 varchar(7), new varchar(7))
RETURNS rel_dis_dis_key AS
$$
DECLARE
id rel_dis_dis_key;
BEGIN
	UPDATE b24_rel_dis_dis
	SET dis_req_code = new
	WHERE dis_code = key1 AND dis_req_code = key2
	RETURNING  dis_code, dis_req_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Administrador */
/* Retorna os Cursos administrados por tal Administrador */
BEGIN;
CREATE OR REPLACE FUNCTION get_Curso(cpf varchar(11))
RETURNS TABLE(Codigo integer, Nome varchar(60)) AS
$$
BEGIN
	RETURN QUERY
		SELECT b06.cur_code, b06.cur_name
		FROM b06_Curso as b06
		WHERE adm_cpf = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de uma Trilha */
/* Retorna os Cursos relacionados a tal Trilha */
BEGIN;
CREATE OR REPLACE FUNCTION get_Curso_from_Trilha(tr varchar(80))
RETURNS TABLE(Codigo integer, Nome varchar(60)) AS
$$
BEGIN
	RETURN QUERY
		SELECT b06.cur_code, b06.cur_name
		FROM b06_Curso as b06
		INNER JOIN b13_rel_tr_cur on b06.cur_code = rel_cur_code
		WHERE rel_tr_name = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Curso */
/* Retorna as Trilhas relacionados a tal Curso */
BEGIN;
CREATE OR REPLACE FUNCTION get_Trilha(curso integer)
RETURNS TABLE(Nome varchar(80)) AS
$$
BEGIN
	RETURN QUERY
		SELECT rel_tr_name
		FROM b13_rel_tr_cur
		WHERE rel_cur_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Modulo */
/* Retorna as Trilhas relacionados a tal Modulo */
BEGIN;
CREATE OR REPLACE FUNCTION get_Trilha_from_modulo(mod integer)
RETURNS TABLE(Nome varchar(80)) AS
$$
BEGIN
	RETURN QUERY
		SELECT rel_tr_name
		FROM b12_rel_tr_mod
		WHERE rel_mod_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de uma Trilha */
/* Retorna os Modulos relacionados a tal Trilha */
BEGIN;
CREATE OR REPLACE FUNCTION get_Modulo(name varchar(80))
RETURNS TABLE(Codigo integer, Nome varchar(40), Creditos_Minimos integer) AS
$$
BEGIN
	RETURN QUERY
		SELECT mod_code, mod_name, mod_cred_min
		FROM b08_Modulo
		INNER JOIN b12_rel_tr_mod on rel_mod_code = mod_code
		WHERE rel_tr_name = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são o código de um curso */
/* Retorna todos os módulos desse curso */
BEGIN;
CREATE OR REPLACE FUNCTION get_Modulos_from_Curso(codigo1 integer)
RETURNS TABLE(Codigo integer, Nome_modulo varchar(60), Creditos_Minimos integer) AS
$$
BEGIN
	RETURN QUERY
		SELECT b08.mod_code, b08.mod_name, b08.mod_cred_min
		FROM b08_Modulo as b08
		INNER JOIN b19_rel_mod_cur as b19 ON b19.rel_mod_code = b08.mod_code
		WHERE rel_cur_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são o codigo de um módulo */
/* Retorna todos os cursos que contêm esse módulo */
BEGIN;
CREATE OR REPLACE FUNCTION get_Cursos_with_Modulo(codigo2 integer)
RETURNS TABLE(Codigo integer, Nome_curso varchar(60)) AS
$$
BEGIN
	RETURN QUERY
		SELECT b06.cur_code, b06.cur_name
		FROM b06_Curso as b06
		INNER JOIN b19_rel_mod_cur as b19 ON b19.rel_cur_code = b06.cur_code
		WHERE rel_mod_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Disciplina */
/* Retorna as Disciplinas que são requisito da Disciplina referida */
BEGIN;
CREATE OR REPLACE FUNCTION get_requisitos(code varchar(7))
RETURNS TABLE(Requisitos varchar(7)) AS
$$
BEGIN
	RETURN QUERY
		SELECT dis_req_code
		FROM b24_rel_dis_dis
		WHERE dis_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

				 
/* Os argumentos são a chave de um Modulo */
/* Retorna as Disciplinas relacionados a tal Modulo */
BEGIN;
CREATE OR REPLACE FUNCTION get_Disciplina(mod integer)
RETURNS TABLE(Nome varchar(7)) AS
$$
BEGIN
	RETURN QUERY
		SELECT rel_dis_code
		FROM b18_rel_dis_mod
		WHERE rel_mod_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;
			   
/* Os argumentos são a chave de uma Disciplina */
/* Retorna os Modulos relacionados a tal Disciplina */
BEGIN;
CREATE OR REPLACE FUNCTION get_Modulo_Disciplina(dis varchar(7))
RETURNS TABLE(Codigo integer) AS
$$
BEGIN
	RETURN QUERY
		SELECT rel_mod_code
		FROM b18_rel_dis_mod
		WHERE rel_dis_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b05_dis_name(prim_key varchar(7))
RETURNS varchar(80) AS
$$
DECLARE
value varchar(80);
BEGIN
	SELECT dis_name INTO value
	FROM b05_Disciplina
	WHERE dis_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b05_dis_class_creds(prim_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT dis_class_creds INTO value
	FROM b05_Disciplina
	WHERE dis_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b05_dis_work_creds(prim_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT dis_work_creds INTO value
	FROM b05_Disciplina
	WHERE dis_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b06_cur_name(prim_key integer)
RETURNS varchar(60) AS
$$
DECLARE
value varchar(60);
BEGIN
	SELECT cur_name INTO value
	FROM b06_Curso
	WHERE cur_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b06_adm_cpf(prim_key integer)
RETURNS varchar(11) AS
$$
DECLARE
value varchar(11);
BEGIN
	SELECT adm_cpf INTO value
	FROM b06_Curso
	WHERE cur_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b06_ad_cur_date_in(prim_key integer)
RETURNS TIMESTAMP AS
$$
DECLARE
value TIMESTAMP;
BEGIN
	SELECT ad_cur_date_in INTO value
	FROM b06_Curso
	WHERE cur_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b06_ad_cur_date_out(prim_key integer)
RETURNS TIMESTAMP AS
$$
DECLARE
value TIMESTAMP;
BEGIN
	SELECT ad_cur_date_out INTO value
	FROM b06_Curso
	WHERE cur_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b08_mod_name(prim_key integer)
RETURNS varchar(40) AS
$$
DECLARE
value varchar(40);
BEGIN
	SELECT mod_name INTO value
	FROM b08_Modulo
	WHERE mod_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b08_mod_cred_min(prim_key integer)
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT mod_cred_min INTO value
	FROM b08_Modulo
	WHERE mod_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--DML
INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 0', 'MAC0100', 1, 1);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 1', 'MAC0101', 2, 2);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 2', 'MAC0102', 3, 3);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 3', 'MAC0103', 4, 4);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 4', 'MAC0104', 5, 5);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 5', 'MAC0105', 6, 6);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 6', 'MAC0106', 7, 7);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 7', 'MAC0107', 8, 8);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 8', 'MAC0108', 9, 9);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 9', 'MAC0109', 10, 10);

/* Curso */
INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (0, 'Bacharelado Generico 0', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '21email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (1, 'Bacharelado Generico 1', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '22email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (2, 'Bacharelado Generico 2', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '23email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (3, 'Bacharelado Generico 3', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '24email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (4, 'Bacharelado Generico 4', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '25email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (5, 'Bacharelado Generico 5', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '26email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (6, 'Bacharelado Generico 6', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '27email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (7, 'Bacharelado Generico 7', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '28email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (8, 'Bacharelado Generico 8', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '29email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (9, 'Bacharelado Generico 9', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '30email@gmail.com'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

/* Trilha */
INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 0');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 1');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 2');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 3');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 4');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 5');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 6');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 7');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 8');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 9');

/* Modulo */
INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (1, 'Modulo Legal 0', 2);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (2, 'Modulo Legal 1', 4);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (3, 'Modulo Legal 2', 6);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (4, 'Modulo Legal 3', 8);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (5, 'Modulo Legal 4', 10);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (6, 'Modulo Legal 5', 12);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (7, 'Modulo Legal 6', 14);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (8, 'Modulo Legal 7', 16);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (9, 'Modulo Legal 8', 18);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (10, 'Modulo Legal 9', 20);

/* rel trilha modulo */
INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 0', 1, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 1', 2, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 2', 3, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 3', 4, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 4', 5, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 5', 6, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 6', 7, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 7', 8, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 8', 9, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 8', 10, false);

/* rel trilha curso */
INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 0', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 0'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 1', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 1'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 2', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 2'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 3', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 3'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 4', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 4'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 5', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 5'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 6', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 6'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 7', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 7'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 8', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 8'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 9', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 9'));

/* rel modulo disciplina */
INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0100', 1);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0101', 2);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0102', 3);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0103', 4);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0104', 5);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0105', 6);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0106', 7);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0107', 8);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0108', 9);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0109', 10);

/* rel modulo curso */
INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (1, 1);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (2, 2);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (3, 3);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (4, 4);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (5, 5);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (6, 6);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (7, 7);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (8, 8);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (9, 9);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (10, 0);

/* Pre requisitos de matricula */
INSERT INTO b24_rel_dis_dis (dis_code, dis_req_code)
	VALUES ('MAC0102','MAC0100');

INSERT INTO b24_rel_dis_dis (dis_code, dis_req_code)
	VALUES ('MAC0102','MAC0101');

INSERT INTO b24_rel_dis_dis (dis_code, dis_req_code)
	VALUES ('MAC0109','MAC0108');
