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
CREATE TABLE b01_Pessoa (
	pes_id SERIAL,
	pes_cpf varchar(11) NOT NULL,
	pes_name varchar(200),
	CONSTRAINT pk_pessoa PRIMARY KEY (pes_id),
	CONSTRAINT sk_pessoa UNIQUE (pes_cpf)
);

CREATE TABLE b02_Professor (
	prof_id SERIAL,
	prof_nusp varchar(9) NOT NULL,
	prof_cpf varchar(11) NOT NULL,
	CONSTRAINT pk_professor PRIMARY KEY (prof_id),
	CONSTRAINT sk_professor UNIQUE (prof_nusp),
	CONSTRAINT fk_pessoa FOREIGN KEY (prof_cpf)
		REFERENCES b01_Pessoa(pes_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE
); 

CREATE TABLE b03_Aluno (
	al_id SERIAL,
	al_nusp varchar(9) NOT NULL,
	al_cpf varchar(11) NOT NULL,
	CONSTRAINT pk_aluno PRIMARY KEY (al_id),
	CONSTRAINT sk_aluno UNIQUE (al_nusp),
	CONSTRAINT fk_pessoa FOREIGN KEY (al_cpf)
		REFERENCES b01_Pessoa(pes_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b04_Administrador (
	adm_id SERIAL,
	adm_cpf varchar(11) NOT NULL,
	adm_email email NOT NULL,
	adm_dat_in TIMESTAMP NOT NULL,
	adm_dat_out TIMESTAMP,
	CONSTRAINT pk_administrador PRIMARY KEY (adm_id),
	CONSTRAINT sk_administrador UNIQUE (adm_email),
	CONSTRAINT adm_cpf UNIQUE (adm_cpf),
	CONSTRAINT fk_pessoa FOREIGN KEY (adm_cpf)
		REFERENCES b01_Pessoa(pes_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- DML Funcoes

-- CREATES
BEGIN;
CREATE OR REPLACE FUNCTION create_Pessoa(arg0 varchar(11), arg1 varchar(200))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ($1, $2)
	RETURNING pes_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Professor(arg0 varchar(9), arg1 varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ($1, $2)
	RETURNING prof_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Aluno(arg0 varchar(9), arg1 varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ($1, $2)
	RETURNING al_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Administrador(arg0 varchar(11), arg1 email, arg2 TIMESTAMP, arg3 TIMESTAMP)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ($1, $2, $3, $4)
	RETURNING adm_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/*
Funções create_new_Cargo:
Criam tanto a pessoa (se precisar) quanto a especialização
*/

BEGIN;
CREATE OR REPLACE FUNCTION create_new_Professor(cpf varchar(11), nome varchar(200), nusp varchar(9))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	SELECT pes_id INTO id 
	FROM b01_Pessoa
	WHERE pes_cpf = $1 AND pes_name = $2;

	/* FOUND diz se o query acima retornou algo*/
	IF NOT FOUND THEN
		INSERT INTO b01_Pessoa (pes_cpf, pes_name)
		VALUES ($1, $2);
	END IF;

	INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ($3, $1)
	RETURNING prof_id into id;

	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_new_Aluno(cpf varchar(11), nome varchar(200), nusp varchar(9))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	SELECT pes_id INTO id 
	FROM b01_Pessoa
	WHERE pes_cpf = $1 AND pes_name = $2;

	/* FOUND diz se o query acima retornou algo*/
	IF NOT FOUND THEN
		INSERT INTO b01_Pessoa (pes_cpf, pes_name)
		VALUES ($1, $2);
	END IF;

	INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ($3, $1)
	RETURNING al_id into id;

	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_new_Administrador(cpf varchar(11), nome varchar(200), email email, dat_in TIMESTAMP, dat_out TIMESTAMP)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	SELECT pes_id INTO id 
	FROM b01_Pessoa
	WHERE pes_cpf = $1 AND pes_name = $2;

	/* FOUND diz se o query acima retornou algo*/
	IF NOT FOUND THEN
		INSERT INTO b01_Pessoa (pes_cpf, pes_name)
		VALUES ($1, $2);
	END IF;

	INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ($1, $3, $4, $5)
	RETURNING adm_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

-- DELETES
BEGIN;
CREATE OR REPLACE FUNCTION delete_Pessoa(key varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b01_Pessoa
	WHERE pes_cpf = key
	RETURNING pes_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Professor(key varchar(9))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b02_Professor
	WHERE prof_nusp = key
	RETURNING prof_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Aluno(key varchar(9))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b03_Aluno
	WHERE al_nusp = key
	RETURNING al_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Administrador(key varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	DELETE FROM b04_Administrador
	WHERE adm_cpf = key
	RETURNING adm_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

-- UPDATES
BEGIN;
CREATE OR REPLACE FUNCTION update_Full_Pessoa(id integer, name varchar(200), cpf varchar(11))
RETURNS int AS
$$
BEGIN
	UPDATE b01_Pessoa
	SET pes_cpf = cpf, pes_name = name
	WHERE pes_id = id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Pessoa_cpf(key varchar(11), new varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b01_Pessoa
	SET pes_cpf = new
	WHERE pes_cpf = key
	RETURNING pes_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Pessoa_name(key varchar(11), new varchar(200))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b01_Pessoa
	SET pes_name = new
	WHERE pes_cpf = key
	RETURNING pes_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Professor_nusp(key varchar(9), new varchar(9))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b02_Professor
	SET prof_nusp = new
	WHERE prof_nusp = key
	RETURNING prof_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Professor_cpf(key varchar(9), new varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b02_Professor
	SET prof_cpf = new
	WHERE prof_nusp = key
	RETURNING prof_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Aluno_nusp(key varchar(9), new varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b03_Aluno
	SET al_nusp = new
	WHERE al_nusp = key
	RETURNING al_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Aluno_cpf(key varchar(9), new varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b03_Aluno
	SET al_cpf = new
	WHERE al_nusp = key
	RETURNING al_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Administrador_cpf(key email, new varchar(11))
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b04_Administrador
	SET adm_cpf = new
	WHERE adm_email = key
	RETURNING adm_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Administrador_email(key email, new email)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b04_Administrador
	SET adm_email = new
	WHERE adm_email = key
	RETURNING adm_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Administrador_dat_in(key email, new TIMESTAMP)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b04_Administrador
	SET adm_dat_in = new
	WHERE adm_email = key
	RETURNING adm_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Administrador_dat_out(key email, new TIMESTAMP)
RETURNS int AS
$$
DECLARE
id int;
BEGIN
	UPDATE b04_Administrador
	SET adm_dat_out = new
	WHERE adm_email = key
	RETURNING adm_id into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

-- RETRIEVALS
BEGIN;
CREATE OR REPLACE FUNCTION select_b01_pes_name(prim_key varchar(11))
RETURNS varchar(200) AS
$$
DECLARE
value varchar(200);
BEGIN
	SELECT pes_name INTO value
	FROM b01_Pessoa
	WHERE pes_cpf = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b02_prof_cpf(prim_key varchar(9))
RETURNS varchar(11) AS
$$
DECLARE
value varchar(11);
BEGIN
	SELECT prof_cpf INTO value
	FROM b02_Professor
	WHERE prof_nusp = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b03_al_cpf(prim_key varchar(9))
RETURNS varchar(11) AS
$$
DECLARE
value varchar(11);
BEGIN
	SELECT al_cpf INTO value
	FROM b03_Aluno
	WHERE al_nusp = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b04_adm_email(prim_key varchar(11))
RETURNS email AS
$$
DECLARE
value email;
BEGIN
	SELECT adm_email INTO value
	FROM b04_Administrador
	WHERE adm_cpf = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b04_adm_dat_in(prim_key varchar(11))
RETURNS TIMESTAMP AS
$$
DECLARE
value TIMESTAMP;
BEGIN
	SELECT adm_dat_in INTO value
	FROM b04_Administrador
	WHERE adm_cpf = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b04_adm_dat_out(prim_key varchar(11))
RETURNS TIMESTAMP AS
$$
DECLARE
value TIMESTAMP;
BEGIN
	SELECT adm_dat_out INTO value
	FROM b04_Administrador
	WHERE adm_cpf = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--DML exemplos
/* Pessoa */
INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('1','Jão1');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('2','Jão2');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('3','Jão3');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('4','Jão4');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('5','Jão5');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('6','Jão6');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('7','Jão7');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('8','Jão8');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('9','Jão9');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('10','Jão10');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('11','Jão11');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('12','Jão12');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('13','Jão13');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('14','Jão14');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('15','Jão15');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('16','Mai16');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('17','Mai17');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('18','Mai18');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('19','Mai19');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('20','Mai20');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('21','Mai21');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('22','Mai22');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('23','Mai23');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('24','Mai24');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('25','Mai25');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('26','Mai26');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('27','Mai27');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('28','Mai28');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('29','Mai29');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('30','Mai30');

/* Insercao em Professor */
INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('1', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão1'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('2', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão2'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('3', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão3'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('4', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão4'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('5', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão5'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('6', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão6'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('7', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão7'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('8', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão8'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('9', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão9'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('10', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão10'));

/* Insercao em Aluno */
INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('11', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão11'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('12', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão12'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('13', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão13'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('14', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão14'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('15', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão15'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('16', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai16'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('17', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai17'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('18', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai18'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('19', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai19'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('20', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai20'));

/* Insercao em Administrador */
INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai21'), '21email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai22'), '22email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai23'), '23email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai24'), '24email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai25'), '25email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai26'), '26email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai27'), '27email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai28'), '28email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai29'), '29email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai30'), '30email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');
