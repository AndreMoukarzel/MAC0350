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

--SERVERS
CREATE EXTENSION postgres_fdw;

CREATE SERVER server_pessoas FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'pessoas');
CREATE USER MAPPING FOR CURRENT_USER SERVER server_pessoas OPTIONS (user 'dba', password '123');

CREATE SERVER server_access FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'access');
CREATE USER MAPPING FOR CURRENT_USER SERVER server_access OPTIONS (user 'dba', password '123');

--DDL
CREATE FOREIGN TABLE b01_Pessoa(
	pes_id SERIAL,
	pes_cpf varchar(11) NOT NULL,
	pes_name varchar(200)
)
SERVER server_pessoas;

CREATE FOREIGN TABLE users(
	us_id       SERIAL,
	us_email    email,
	us_password TEXT NOT NULL
)
SERVER server_access;

CREATE TABLE b20_rel_pes_us (
	rel_pes_cpf varchar(11) NOT NULL,
	rel_us_email email NOT NULL,
	rel_pes_us_date_in TIMESTAMP NOT NULL,
	rel_pes_us_date_out TIMESTAMP,
	CONSTRAINT pk_rel_pes_us PRIMARY KEY (rel_pes_cpf, rel_us_email)
	/*CONSTRAINT fk_pes_cpf FOREIGN KEY (rel_pes_cpf)
		REFERENCES b01_Pessoa(pes_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_us_email FOREIGN KEY (rel_us_email)
		REFERENCES users(us_email)
		ON DELETE CASCADE
		ON UPDATE CASCADE*/
);

DROP TYPE IF EXISTS pes_us_key CASCADE;
CREATE TYPE pes_us_key AS (key1 varchar(11), key2 email);

--TRIGGERS
CREATE FUNCTION check_pes_us() RETURNS trigger AS $$
	DECLARE 
	pes_exist BOOLEAN;
	us_exist BOOLEAN;
    BEGIN

    	SELECT COUNT(*) = 1 INTO pes_exist
		FROM b01_Pessoa
		WHERE pes_cpf = NEW.rel_pes_cpf;

		IF NOT pes_exist THEN
			RAISE EXCEPTION 'Invalid Pessoa CPF';
		END IF;

		SELECT COUNT(*) = 1 INTO us_exist
		FROM users
		WHERE us_email = NEW.rel_us_email;

		IF NOT us_exist THEN
			RAISE EXCEPTION 'Invalid User Email';
		END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_pes_us BEFORE INSERT OR UPDATE ON b20_rel_pes_us
    FOR EACH ROW EXECUTE PROCEDURE check_pes_us();

--CREATES
BEGIN;
CREATE OR REPLACE FUNCTION create_rel_pes_us(arg0 varchar(11), arg1 email, arg2 TIMESTAMP, arg3 TIMESTAMP)
RETURNS pes_us_key AS
$$
DECLARE
id pes_us_key;
BEGIN
	INSERT INTO b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ($1, $2, $3, $4)
	RETURNING rel_pes_cpf, rel_us_email into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--DELETES
BEGIN;
CREATE OR REPLACE FUNCTION delete_pes_us_from_cpf(cpf varchar(11))
RETURNS email AS
$$
DECLARE
us_email email;
BEGIN
	DELETE FROM b20_rel_pes_us
	WHERE rel_pes_cpf = cpf
	RETURNING rel_us_email into us_email;
	RETURN us_email;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_pes_us(key1 varchar(11), key2 email)
RETURNS pes_us_key AS
$$
DECLARE
id pes_us_key;
BEGIN
	DELETE FROM b20_rel_pes_us
	WHERE rel_pes_cpf = key1 AND rel_us_email = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--UPDATES
BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Pessoa_Usuario_pes_cpf(key1 varchar(11), key2 email, new varchar(11))
RETURNS pes_us_key AS
$$
DECLARE
id pes_us_key;
BEGIN
	UPDATE b20_rel_pes_us
	SET rel_pes_cpf = new
	WHERE rel_pes_cpf= key1 AND rel_us_email = key2
	RETURNING rel_pes_cpf, rel_us_email into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Pessoa_Usuario_us_email(key1 varchar(11), key2 email, new email)
RETURNS pes_us_key AS
$$
DECLARE
id pes_us_key;
BEGIN
	UPDATE b20_rel_pes_us
	SET rel_us_email = new
	WHERE rel_pes_cpf= key1 AND rel_us_email = key2
	RETURNING rel_pes_cpf, rel_us_email into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Pessoa_Usuario_date_in(key1 varchar(11), key2 email, new TIMESTAMP)
RETURNS pes_us_key AS
$$
DECLARE
id pes_us_key;
BEGIN
	UPDATE b20_rel_pes_us
	SET rel_pes_us_date_in = new
	WHERE rel_pes_cpf= key1 AND rel_us_email = key2
	RETURNING rel_pes_cpf, rel_us_email into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Pessoa_Usuario_date_out(key1 varchar(11), key2 email, new TIMESTAMP)
RETURNS pes_us_key AS
$$
DECLARE
id pes_us_key;
BEGIN
	UPDATE b20_rel_pes_us
	SET rel_pes_us_date_out = new
	WHERE rel_pes_cpf= key1 AND rel_us_email = key2
	RETURNING rel_pes_cpf, rel_us_email into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;


--RETRIEVALS
/* Os argumentos são a chave de uma Pessoa */
/* Retorna o Usuario da Pessoa */
BEGIN;
CREATE OR REPLACE FUNCTION get_user(cpf varchar(11))
RETURNS TABLE(Email email) AS
$$
BEGIN
	RETURN QUERY
		SELECT us_email
		FROM b20_rel_pes_us
		INNER JOIN users ON rel_us_email = us_email
		WHERE rel_pes_cpf = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Usuario */
/* Retorna o CPF e nome da Pessoa relacionada ao Usuário especificado */
BEGIN;
CREATE OR REPLACE FUNCTION get_pes(mail email)
RETURNS TABLE(CPF varchar(11), Nome varchar(200)) AS
$$
BEGIN
	RETURN QUERY
		SELECT pes_cpf, pes_name
		FROM b20_rel_pes_us
		INNER JOIN b01_Pessoa ON rel_pes_cpf = pes_cpf
		WHERE rel_us_email = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b20_rel_pes_us_date_in(prim_key varchar(11), sec_key email)
RETURNS TIMESTAMP AS
$$
DECLARE
value TIMESTAMP;
BEGIN
	SELECT rel_pes_us_date_in INTO value
	FROM b20_rel_pes_us
	WHERE rel_pes_cpf = $1 AND rel_us_email = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b20_rel_pes_us_date_out(prim_key varchar(11), sec_key email)
RETURNS TIMESTAMP AS
$$
DECLARE
value TIMESTAMP;
BEGIN
	SELECT rel_pes_us_date_out INTO value
	FROM b20_rel_pes_us
	WHERE rel_pes_cpf = $1 AND rel_us_email = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* rel pessoa usuario */
INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão1'), 'admin@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão2'), '2_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão3'), '3_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão4'), '4_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão5'), '5_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão6'), '6_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão7'), '7_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão8'), '8_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão9'), '9_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão10'), '10_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');
