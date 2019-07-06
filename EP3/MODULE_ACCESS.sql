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
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	us_id       SERIAL,
	us_email    email,
	us_password TEXT NOT NULL,
	CONSTRAINT pk_user PRIMARY KEY (us_id),
	CONSTRAINT sk_user UNIQUE (us_email)
);

CREATE TABLE b10_Perfil (
	perf_id SERIAL,
	perf_name varchar(20) NOT NULL, 
	perf_desc varchar(100),
	CONSTRAINT pk_perfil PRIMARY KEY (perf_id),
	CONSTRAINT sk_perfil UNIQUE (perf_name)
);

CREATE TABLE b11_Servico (
	serv_id SERIAL,
	serv_code integer NOT NULL,
	serv_name varchar(50) NOT NULL,
	serv_desc varchar(280),
	CONSTRAINT pk_servico PRIMARY KEY (serv_id),
	CONSTRAINT sk_servico UNIQUE (serv_code)
);

CREATE TABLE b14_rel_us_pf (
	rel_us_email email NOT NULL,
	rel_perf_name varchar(20) NOT NULL,
	rel_us_pf_date_in TIMESTAMP,
	rel_us_pf_date_out TIMESTAMP,
	CONSTRAINT pk_rel_us_pf PRIMARY KEY (rel_us_email, rel_perf_name),
	CONSTRAINT fk_us_email FOREIGN KEY (rel_us_email)
		REFERENCES users(us_email)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_perf_name FOREIGN KEY (rel_perf_name)
		REFERENCES b10_Perfil(perf_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b15_rel_pf_se (
	rel_perf_name varchar(20) NOT NULL,
	rel_serv_code integer NOT NULL,
	CONSTRAINT pk_rel_pf_se PRIMARY KEY (rel_perf_name, rel_serv_code),
	CONSTRAINT fk_perf_name FOREIGN KEY (rel_perf_name)
		REFERENCES b10_Perfil(perf_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_serv_code FOREIGN KEY (rel_serv_code)
		REFERENCES b11_Servico(serv_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

DROP TYPE IF EXISTS us_pf_key CASCADE;
CREATE TYPE us_pf_key AS (key1 email, key2 varchar(20));

DROP TYPE IF EXISTS pf_se_key CASCADE;
CREATE TYPE pf_se_key AS (key1 varchar(20), key2 integer);

--DML Funcoes

-- CREATES
BEGIN;
CREATE OR REPLACE FUNCTION create_users(arg0 email, arg1 TEXT)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO users (us_email, us_password)
	VALUES ($1, $2)
	RETURNING us_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Perfil(arg0 varchar(20), arg1 varchar(100))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ($1, $2)
	RETURNING perf_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Servico(arg0 integer, arg1 varchar(50), arg2 varchar(280))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES ($1, $2, $3)
	RETURNING serv_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_us_pf(arg0 email, arg1 varchar(20), arg2 TIMESTAMP, arg3 TIMESTAMP)
RETURNS us_pf_key AS
$$
DECLARE
id us_pf_key;
BEGIN
	INSERT INTO b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ($1, $2, $3, $4)
	RETURNING rel_us_email, rel_perf_name into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_pf_se(arg0 varchar(20), arg1 integer)
RETURNS pf_se_key AS
$$
DECLARE
id pf_se_key;
BEGIN
	INSERT INTO b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ($1, $2)
	RETURNING rel_perf_name, rel_serv_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

-- DELETES
BEGIN;
CREATE OR REPLACE FUNCTION delete_user(key email)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM users
	WHERE us_email = key
	RETURNING us_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Perfil(key varchar(20))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b10_Perfil
	WHERE perf_name = key
	RETURNING perf_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Servico(key integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b11_Servico
	WHERE serv_code = key
	RETURNING serv_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_us_pf(key1 email, key2 varchar(20))
RETURNS us_pf_key AS
$$
DECLARE
id us_pf_key;
BEGIN
	DELETE FROM b14_rel_us_pf
	WHERE rel_us_email = key1 AND rel_perf_name = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_pf_se(key1 varchar(20), key2 integer)
RETURNS pf_se_key AS
$$
DECLARE
id pf_se_key;
BEGIN
	DELETE FROM b15_rel_pf_se
	WHERE rel_perf_name = key1 AND rel_serv_code = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

-- UPDATES
BEGIN;
CREATE OR REPLACE FUNCTION update_users_email(key email, new email)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE users
	SET us_email = new
	WHERE us_email = key
	RETURNING us_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_users_password(key email, new TEXT)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE users
	SET us_password = new
	WHERE us_email = key
	RETURNING us_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Full_Perfil(id integer, name varchar(20), p_desc varchar(100))
RETURNS int AS
$$
BEGIN
	UPDATE b10_Perfil
	SET perf_name = name, perf_desc = p_desc
	WHERE perf_id = id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Perfil_name(key varchar(20), new varchar(20))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b10_Perfil
	SET perf_name = new
	WHERE perf_name = key
	RETURNING perf_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Perfil_description(key varchar(20), new varchar(100))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b10_Perfil
	SET perf_desc = new
	WHERE perf_name = key
	RETURNING perf_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Servico_code(key integer, new integer)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b11_Servico
	SET serv_code = new
	WHERE serv_code = key
	RETURNING serv_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Servico_name(key integer, new varchar(50))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b11_Servico
	SET serv_name = new
	WHERE serv_code = key
	RETURNING serv_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Servico_desc(key integer, new varchar(280))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b11_Servico
	SET serv_desc = new
	WHERE serv_code = key
	RETURNING serv_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Usuario_Perfil_email(key1 email, key2 varchar(20), new email)
RETURNS us_pf_key AS
$$
DECLARE
id us_pf_key;
BEGIN
	UPDATE b14_rel_us_pf
	SET rel_us_email = new
	WHERE rel_us_email = key1 AND rel_perf_name = key2
	RETURNING rel_us_email, rel_perf_name into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Usuario_Perfil_name(key1 email, key2 varchar(20), new varchar(20))
RETURNS us_pf_key AS
$$
DECLARE
id us_pf_key;
BEGIN
	UPDATE b14_rel_us_pf
	SET rel_perf_name = new
	WHERE rel_us_email = key1 AND rel_perf_name = key2
	RETURNING rel_us_email, rel_perf_name into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Usuario_Perfil_date_in(key1 email, key2 varchar(20), new TIMESTAMP)
RETURNS us_pf_key AS
$$
DECLARE
id us_pf_key;
BEGIN
	UPDATE b14_rel_us_pf
	SET rel_us_pf_date_in = new
	WHERE rel_us_email = key1 AND rel_perf_name = key2
	RETURNING rel_us_email, rel_perf_name into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Usuario_Perfil_date_out(key1 email, key2 varchar(20), new TIMESTAMP)
RETURNS us_pf_key AS
$$
DECLARE
id us_pf_key;
BEGIN
	UPDATE b14_rel_us_pf
	SET rel_us_pf_date_out = new
	WHERE rel_us_email = key1 AND rel_perf_name = key2
	RETURNING rel_us_email, rel_perf_name into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Perfil_Servico_name(key1 varchar(20), key2 integer, new varchar(20))
RETURNS pf_se_key AS
$$
DECLARE
id pf_se_key;
BEGIN
	UPDATE b15_rel_pf_se
	SET rel_perf_name = new
	WHERE rel_perf_name = key1 AND rel_serv_code = key2
	RETURNING rel_perf_name, rel_serv_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Perfil_Servico_code(key1 varchar(20), key2 integer, new integer)
RETURNS pf_se_key AS
$$
DECLARE
id pf_se_key;
BEGIN
	UPDATE b15_rel_pf_se
	SET rel_serv_code = new
	WHERE rel_perf_name = key1 AND rel_serv_code = key2
	RETURNING rel_perf_name, rel_serv_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

-- RETRIEVALS
/* Os argumentos são a chave de um user e sua senha*/
/* Retorna o email do user se o email e a senha estiverem corretos */
BEGIN;
CREATE OR REPLACE FUNCTION check_login(user_email email, user_pass TEXT)
RETURNS TABLE(Email email) AS
$$
BEGIN

	RETURN QUERY
	SELECT us_email
	FROM public.users
	WHERE us_email = $1 AND us_password = public.crypt($2, us_password);

END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um user*/
/* Retorna todos os servições que podem ser acessados pelo usuario */
BEGIN;
CREATE OR REPLACE FUNCTION get_servs_from_email(user_email email)
RETURNS TABLE(codigo integer) AS
$$
BEGIN

	RETURN QUERY
		SELECT serv_code
		FROM b11_servico
		INNER JOIN b15_rel_pf_se as b15
			ON serv_code = b15.rel_serv_code
		INNER JOIN b10_perfil
			ON perf_name = b15.rel_perf_name
		INNER JOIN b14_rel_us_pf as b14
			ON perf_name = b14.rel_perf_name
		WHERE b14.rel_us_email = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Perfil */
/* Retorna todos os nomes e descrições dos Serviços disponíveis ao Perfil */
BEGIN;
CREATE OR REPLACE FUNCTION get_servs(name varchar(20))
RETURNS TABLE(Nome varchar(50), Descricao varchar(280)) AS
$$
BEGIN
	RETURN QUERY
		SELECT serv_name, serv_desc
		FROM b15_rel_pf_se
		INNER JOIN b11_Servico ON rel_serv_code = serv_code
		WHERE rel_perf_name = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Usuário */
/* Retorna os nomes e descrições dos Perfis disponíveis ao Usuário */
BEGIN;
CREATE OR REPLACE FUNCTION get_perfs(mail email)
RETURNS TABLE(Nome varchar(20), Descricao varchar(100)) AS
$$
BEGIN
	RETURN QUERY
		SELECT perf_name, perf_desc
		FROM b14_rel_us_pf
		INNER JOIN b10_Perfil ON rel_perf_name = perf_name
		WHERE rel_us_email = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um serviço */
/* Retorna os nomes de perfis que tem acesso a tal serviço */
BEGIN;
CREATE OR REPLACE FUNCTION get_perfs(serv_code integer)
RETURNS TABLE(Nome varchar(20)) AS
$$
BEGIN
	RETURN QUERY
		SELECT perf_name
		FROM b15_rel_pf_se
		INNER JOIN b10_Perfil ON rel_perf_name = perf_name
		WHERE rel_serv_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um perfil */
/* Retorna os usuários com tal perfil */
BEGIN;
CREATE OR REPLACE FUNCTION get_users(perf_name varchar(20))
RETURNS TABLE(Email email) AS
$$
BEGIN
	RETURN QUERY
		SELECT us_email
		FROM b14_rel_us_pf
		INNER JOIN users ON rel_us_email = us_email
		WHERE rel_perf_name = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b10_perf_desc(prim_key varchar(20))
RETURNS varchar(100) AS
$$
DECLARE
value varchar(100);
BEGIN
	SELECT perf_desc INTO value
	FROM b10_Perfil
	WHERE perf_name = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b11_serv_name(prim_key integer)
RETURNS varchar(50) AS
$$
DECLARE
value varchar(50);
BEGIN
	SELECT serv_name INTO value
	FROM b11_Servico
	WHERE serv_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b11_serv_desc(prim_key integer)
RETURNS varchar(280) AS
$$
DECLARE
value varchar(280);
BEGIN
	SELECT serv_desc INTO value
	FROM b11_Servico
	WHERE serv_code = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b14_rel_us_pf_date_in(prim_key email, sec_key varchar(20))
RETURNS TIMESTAMP AS
$$
DECLARE
value TIMESTAMP;
BEGIN
	SELECT rel_us_pf_date_in INTO value
	FROM b14_rel_us_pf
	WHERE rel_us_email = $1 AND rel_perf_name = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b14_rel_us_pf_date_out(prim_key email, sec_key varchar(20))
RETURNS TIMESTAMP AS
$$
DECLARE
value TIMESTAMP;
BEGIN
	SELECT rel_us_pf_date_out INTO value
	FROM b14_rel_us_pf
	WHERE rel_us_email = $1 AND rel_perf_name = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--DML exemplos
/* Usuario */
INSERT INTO users (us_email, us_password)
	VALUES ('admin@gmail.com', crypt('admin', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('2_user@gmail.com', crypt('123456781', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('3_user@gmail.com', crypt('123456782', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('4_user@gmail.com', crypt('123456783', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('5_user@gmail.com', crypt('123456784', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('6_user@gmail.com', crypt('123456785', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('7_user@gmail.com', crypt('123456786', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('8_user@gmail.com', crypt('123456787', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('9_user@gmail.com', crypt('123456788', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('10_user@gmail.com', crypt('123456789', gen_salt('bf')));

/* Perfil */
INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Administrador', 'Todos os serviços ao seu dispor');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Webmaster', 'Pode ligar users com pessoas');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 3', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 4', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 5', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 6', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 7', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 8', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 9', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 10', 'Perfil usado por usuarios que inovam');

/* Servicos */
INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0001, 'CRUD Pessoas', 'Permite criar, deletar e atualizar uma pessoa, e ver as pessoas criadas');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0002, 'Acesso a Working Profs', 'Permite usar a função Working_Profs');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0003, 'CRUD Curso', 'Permite criar, deletar e atualizar um curso, e ver os cursos criados');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0004, 'CRUD Perfil', 'Permite criar, deletar e atualizar um perfil, e ver os perfis criados');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0005, 'CRUD Rel_Pes_Us', 'Permite criar, deletar e atualizar relação pessoa e usuario, e ver as relações criadas');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0006, 'CRUD Rel_Prof_Dis', 'Permite criar, deletar e atualizar relação professor e disc, e ver as relações criadas');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0007, 'create_new_Administrador()', 'cria um administrador e, se necessário, a pessoa correspondente');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0008, 'create_Disciplina()', 'cria uma disciplina');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0009, 'create_Curso()', 'cria um novo curso');

INSERT INTO b11_Servico (serv_code, serv_name, serv_desc)
	VALUES (0010, 'create_Trilha()', 'cria trilha');

/* rel user perfil*/
INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('admin@gmail.com', 'Administrador', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('2_user@gmail.com', 'Webmaster', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('3_user@gmail.com', 'Perfil Inovador 3', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('4_user@gmail.com', 'Perfil Inovador 4', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('5_user@gmail.com', 'Perfil Inovador 5', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('6_user@gmail.com', 'Perfil Inovador 6', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('7_user@gmail.com', 'Perfil Inovador 7', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('8_user@gmail.com', 'Perfil Inovador 8', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('9_user@gmail.com', 'Perfil Inovador 9', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('9_user@gmail.com', 'Perfil Inovador 10', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

/* rel perfil servico */
INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Administrador', 0001);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Administrador', 0002);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Administrador', 0003);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Administrador', 0004);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Administrador', 0005);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Administrador', 0006);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Webmaster', 0005);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 3', 0003);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 4', 0004);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 5', 0005);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 6', 0006);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 7', 0007);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 8', 0008);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 9', 0009);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 10', 0010);