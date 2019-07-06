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

--Server
CREATE EXTENSION postgres_fdw;

CREATE SERVER server_pessoas FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'pessoas');
CREATE USER MAPPING FOR CURRENT_USER SERVER server_pessoas OPTIONS (user 'dba', password '123');

CREATE SERVER server_curriculum FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'curriculum');
CREATE USER MAPPING FOR CURRENT_USER SERVER server_curriculum OPTIONS (user 'dba', password '123');

--DDL
CREATE FOREIGN TABLE b01_Pessoa (
	pes_id SERIAL,
	pes_cpf varchar(11) NOT NULL,
	pes_name varchar(200)
)
SERVER server_pessoas;

CREATE FOREIGN TABLE b02_Professor (
	prof_id SERIAL,
	prof_nusp varchar(9) NOT NULL,
	prof_cpf varchar(11) NOT NULL
)
SERVER server_pessoas; 

CREATE FOREIGN TABLE b03_Aluno (
	al_id SERIAL,
	al_nusp varchar(9) NOT NULL,
	al_cpf varchar(11) NOT NULL
)
SERVER server_pessoas;

CREATE FOREIGN TABLE b05_Disciplina (
	dis_id SERIAL,
	dis_code varchar(7) NOT NULL,
	dis_name varchar(80),
	dis_class_creds integer,
	dis_work_creds integer
)
SERVER server_curriculum;

CREATE TABLE b16_rel_prof_dis (
	rel_prof_nusp varchar(9) NOT NULL,
	rel_dis_code varchar(7) NOT NULL,
	rel_prof_disc_semester integer,
	rel_prof_disc_year integer,
	CONSTRAINT pk_rel_prof_dis PRIMARY KEY (rel_prof_nusp, rel_dis_code)
	/*CONSTRAINT fk_prof_nusp FOREIGN KEY (rel_prof_nusp)
		REFERENCES b02_Professor(prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE*/
);

CREATE TABLE b17_rel_al_dis (
	rel_al_nusp varchar(9) NOT NULL,
	rel_dis_code varchar(7) NOT NULL,
	plan_semester integer,
	plan_year integer,
	CONSTRAINT pk_rel_al_dis PRIMARY KEY (rel_al_nusp, rel_dis_code)
	/*CONSTRAINT fk_al_nusp FOREIGN KEY (rel_al_nusp)
		REFERENCES b03_Aluno(al_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES  b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE*/
);

CREATE TABLE b21_Oferecimento (
	rel_prof_nusp varchar(9) NOT NULL,
	rel_dis_code varchar(7) NOT NULL,
	rel_oferecimento_year integer NOT NULL,
	rel_oferecimento_semester integer NOT NULL,
	rel_oferecimento_class integer,
	CONSTRAINT pk_oferecimento PRIMARY KEY (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester)
	/*CONSTRAINT fk_prof_nusp FOREIGN KEY (rel_prof_nusp)
		REFERENCES b02_Professor(prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE*/
);

CREATE TABLE b22_rel_al_of (
	rel_prof_nusp varchar(9) NOT NULL,
	rel_dis_code varchar(7) NOT NULL,
	rel_al_nusp varchar(9) NOT NULL,
	rel_al_of_year integer NOT NULL,
	rel_al_of_semester integer NOT NULL,
	rel_al_of_grade float(24),
	rel_al_of_attendance float(24),
	CONSTRAINT pk_rel_al_of PRIMARY KEY (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester)
	/*CONSTRAINT fk_prof_nusp FOREIGN KEY (rel_prof_nusp)
		REFERENCES b02_Professor(prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_al_nusp FOREIGN KEY (rel_al_nusp)
		REFERENCES b03_Aluno(al_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE*/
);

CREATE TABLE b23_of_times (
	prof_nusp varchar(9) NOT NULL,
	dis_code varchar(7) NOT NULL,
	year integer NOT NULL,
	semester integer NOT NULL,
	time_in TIME NOT NULL,
	time_out TIME NOT NULL,
	day integer,
	CONSTRAINT pk_of_times PRIMARY KEY (prof_nusp, dis_code, year, semester, time_in, day)
	/*CONSTRAINT fk_prof FOREIGN KEY (prof_nusp)
		REFERENCES b02_Professor(prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis FOREIGN KEY (dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE*/
);

DROP TYPE IF EXISTS prof_dis_key CASCADE;
CREATE TYPE prof_dis_key AS (key1 varchar(9), key2 varchar(7), key3 integer, key4 integer);

DROP TYPE IF EXISTS al_dis_key CASCADE;
CREATE TYPE al_dis_key AS (key1 varchar(9), key2 varchar(7), key3 integer, key4 integer);

DROP TYPE IF EXISTS of_key CASCADE;
CREATE TYPE of_key AS (key1 varchar(9), key2 varchar(7), key3 integer, key4 integer);

DROP TYPE IF EXISTS al_of_key CASCADE;
CREATE TYPE al_of_key AS (key1 varchar(9), key2 varchar(7), key3 varchar(9), key4 integer, key5 integer);

DROP TYPE IF EXISTS of_times_key CASCADE;
CREATE TYPE of_times_key AS (key1 varchar(9), key2 varchar(7), key3 integer, key4 integer, key5 TIME, key6 integer);

--TRIGGERS
CREATE FUNCTION check_prof_dis() RETURNS trigger AS $$
	DECLARE 
	dis_exist BOOLEAN;
	prof_exist BOOLEAN;
    BEGIN

    	SELECT COUNT(*) = 1 INTO dis_exist
		FROM b05_Disciplina
		WHERE dis_code = NEW.rel_dis_code;

		IF NOT dis_exist THEN
			RAISE EXCEPTION 'Invalid Discipline Code';
		END IF;

		SELECT COUNT(*) = 1 INTO prof_exist
		FROM b02_Professor
		WHERE prof_nusp = NEW.rel_prof_nusp;

		IF NOT prof_exist THEN
			RAISE EXCEPTION 'Invalid Professor Nusp';
		END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_prof_dis BEFORE INSERT OR UPDATE ON b16_rel_prof_dis
    FOR EACH ROW EXECUTE PROCEDURE check_prof_dis();

CREATE FUNCTION check_al_dis() RETURNS trigger AS $$
	DECLARE 
	dis_exist BOOLEAN;
	al_exist BOOLEAN;
    BEGIN

    	SELECT COUNT(*) = 1 INTO dis_exist
		FROM b05_Disciplina
		WHERE dis_code = NEW.rel_dis_code;

		IF NOT dis_exist THEN
			RAISE EXCEPTION 'Invalid Discipline Code';
		END IF;

		SELECT COUNT(*) = 1 INTO al_exist
		FROM b03_Aluno
		WHERE al_nusp = NEW.rel_al_nusp;

		IF NOT al_exist THEN
			RAISE EXCEPTION 'Invalid Aluno Nusp';
		END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_al_dis BEFORE INSERT OR UPDATE ON b17_rel_al_dis
    FOR EACH ROW EXECUTE PROCEDURE check_al_dis();

CREATE TRIGGER check_prof_dis BEFORE INSERT OR UPDATE ON b21_Oferecimento
    FOR EACH ROW EXECUTE PROCEDURE check_prof_dis();

CREATE FUNCTION check_al_prof_dis() RETURNS trigger AS $$
	DECLARE 
	dis_exist BOOLEAN;
	prof_exist BOOLEAN;
	al_exist BOOLEAN;
    BEGIN

    	SELECT COUNT(*) = 1 INTO dis_exist
		FROM b05_Disciplina
		WHERE dis_code = NEW.rel_dis_code;

		IF NOT dis_exist THEN
			RAISE EXCEPTION 'Invalid Discipline Code';
		END IF;

		SELECT COUNT(*) = 1 INTO prof_exist
		FROM b02_Professor
		WHERE prof_nusp = NEW.rel_prof_nusp;

		IF NOT prof_exist THEN
			RAISE EXCEPTION 'Invalid Professor Nusp';
		END IF;

		SELECT COUNT(*) = 1 INTO al_exist
		FROM b03_Aluno
		WHERE al_nusp = NEW.rel_al_nusp;

		IF NOT al_exist THEN
			RAISE EXCEPTION 'Invalid Aluno Nusp';
		END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_al_prof_dis BEFORE INSERT OR UPDATE ON b22_rel_al_of
    FOR EACH ROW EXECUTE PROCEDURE check_al_prof_dis();

CREATE FUNCTION b23_check_prof_dis() RETURNS trigger AS $$
	DECLARE 
	dis_exist BOOLEAN;
	prof_exist BOOLEAN;
    BEGIN

    	SELECT COUNT(*) = 1 INTO dis_exist
		FROM b05_Disciplina
		WHERE dis_code = NEW.dis_code;

		IF NOT dis_exist THEN
			RAISE EXCEPTION 'Invalid Discipline Code';
		END IF;

		SELECT COUNT(*) = 1 INTO prof_exist
		FROM b02_Professor
		WHERE prof_nusp = NEW.prof_nusp;

		IF NOT prof_exist THEN
			RAISE EXCEPTION 'Invalid Professor Nusp';
		END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER b23_check_prof_dis BEFORE INSERT OR UPDATE ON b23_of_times
    FOR EACH ROW EXECUTE PROCEDURE b23_check_prof_dis();

--CREATES
BEGIN;
CREATE OR REPLACE FUNCTION create_rel_prof_dis(arg0 varchar(9), arg1 varchar(7), arg2 integer, arg3 integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	INSERT INTO b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ($1, $2, $3, $4)
	RETURNING rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_al_dis(arg0 varchar(9), arg1 varchar(7), arg2 integer, arg3 integer)
RETURNS al_dis_key AS
$$
DECLARE
id al_dis_key;
BEGIN
	INSERT INTO b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ($1, $2, $3, $4)
	RETURNING rel_al_nusp, rel_dis_code, plan_semester, plan_year into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Oferecimento(arg0 varchar(9), arg1 varchar(7), arg2 integer, arg3 integer, arg4 integer)
RETURNS of_key AS
$$
DECLARE
id of_key;
BEGIN
	INSERT INTO b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ($1, $2, $3, $4, $5)
	RETURNING rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_al_of(arg0 varchar(9), arg1 varchar(7), arg2 varchar(9),arg3 integer, arg4 integer, arg5 float(24), arg6 float(24))
RETURNS al_of_key AS
$$
DECLARE
id al_of_key;
BEGIN
	INSERT INTO b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ($1, $2, $3, $4, $5, $6, $7)
	RETURNING rel_prof_nusp, rel_dis_code, rel_al_nusp into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_of_times(arg0 varchar(9), arg1 varchar(7), arg2 integer, arg3 integer, arg4 TIME, arg5 TIME, arg6 integer)
RETURNS of_times_key AS
$$
DECLARE
id of_times_key;
BEGIN
	INSERT INTO b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ($1, $2, $3, $4, $5, $6, $7)
	RETURNING prof_nusp, dis_code, year, semester, time_in, day into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_prof_dis(key1 varchar(9), key2 varchar(7), key3 integer, key4 integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	DELETE FROM b16_rel_prof_dis
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_prof_disc_semester = key3 AND rel_prof_disc_year = key4
	RETURNING key1, key2, key3, key4 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_al_dis(key1 varchar(9), key2 varchar(7), key3 integer, key4 integer)
RETURNS al_dis_key AS
$$
DECLARE
id al_dis_key;
BEGIN
	DELETE FROM b17_rel_al_dis
	WHERE rel_al_nusp = key1 AND rel_dis_code = key2 AND plan_semester = key3 AND plan_year = key4
	RETURNING key1, key2, key3, key4 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_Oferecimento(key1 varchar(9), key2 varchar(7), key3 integer, key4 integer)
RETURNS of_key AS
$$
DECLARE
id of_key;
BEGIN
	DELETE FROM b21_Oferecimento
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_oferecimento_year = key3 AND rel_oferecimento_semester = key4
	RETURNING key1, key2, key3, key4 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_al_of(key1 varchar(9), key2 varchar(7), key3 varchar(9))
RETURNS al_of_key AS
$$
DECLARE
id al_of_key;
BEGIN
	DELETE FROM b22_rel_al_of
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_al_nusp = key3
	RETURNING key1, key2, key3 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION delete_of_times(key1 varchar(9), key2 varchar(7), key3 integer, key4 integer, key5 TIME, key6 integer)
RETURNS of_times_key AS
$$
DECLARE
id of_times_key;
BEGIN
	DELETE FROM b23_of_times
	WHERE prof_nusp = key1 AND dis_code = key2 AND year = key3 AND semester = key4 AND time_in = key5 AND day = key6
	RETURNING key1, key2, key3, key4, key5, key6 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--UPDATES
BEGIN;
CREATE OR REPLACE FUNCTION update_Full_rel_Professor_Disciplina(key1 varchar(9), key2 varchar(7), nusp varchar(9), code varchar(7), semester integer, year integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b16_rel_prof_dis
	SET rel_prof_nusp = nusp, rel_dis_code = code, rel_prof_disc_semester = semester, rel_prof_disc_year = year
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_prof_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Professor_Disciplina_prof_nusp(key1 varchar(9), key2 varchar(7), new varchar(9))
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b16_rel_prof_dis
	SET rel_prof_nusp = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_prof_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Professor_Disciplina_dis_code(key1 varchar(9), key2 varchar(7), new varchar(7))
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b16_rel_prof_dis
	SET rel_dis_code = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_prof_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Professor_Disciplina_prof_disc_semester(key1 varchar(9), key2 varchar(7), new integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b16_rel_prof_dis
	SET rel_prof_disc_semester = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_prof_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Professor_Disciplina_prof_disc_year(key1 varchar(9), key2 varchar(7), new integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b16_rel_prof_dis
	SET rel_prof_disc_year = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_prof_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Aluno_Disciplina_al_nusp(key1 varchar(9), key2 varchar(7), new varchar(9))
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b17_rel_al_dis
	SET rel_al_nusp = new
	WHERE rel_al_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_al_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Aluno_Disciplina_dis_code(key1 varchar(9), key2 varchar(7), new varchar(7))
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b17_rel_al_dis
	SET rel_dis_code = new
	WHERE rel_al_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_al_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Aluno_Disciplina_plan_semester(key1 varchar(9), key2 varchar(7), new integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b17_rel_al_dis
	SET plan_semester = new
	WHERE rel_al_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_al_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_rel_Aluno_Disciplina_plan_year(key1 varchar(9), key2 varchar(7), new integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	UPDATE b17_rel_al_dis
	SET plan_year = new
	WHERE rel_al_nusp = key1 AND rel_dis_code = key2
	RETURNING rel_al_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_prof_nusp(key1 varchar(9), key2 varchar(7), key3 int, key4 int, new varchar(9))
RETURNS of_key AS
$$
DECLARE
id of_key;
BEGIN
	UPDATE b21_Oferecimento
	SET rel_prof_nusp = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_oferecimento_year = key3 AND rel_oferecimento_semester = key4
	RETURNING rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_dis_code(key1 varchar(9), key2 varchar(7), key3 int, key4 int, new varchar(7))
RETURNS of_key AS
$$
DECLARE
id of_key;
BEGIN
	UPDATE b21_Oferecimento
	SET rel_dis_code = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_oferecimento_year = key3 AND rel_oferecimento_semester = key4
	RETURNING rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_year(key1 varchar(9), key2 varchar(7), key3 int, key4 int, new integer)
RETURNS of_key AS
$$
DECLARE
id of_key;
BEGIN
	UPDATE b21_Oferecimento
	SET rel_oferecimento_year = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_oferecimento_year = key3 AND rel_oferecimento_semester = key4
	RETURNING rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_semester(key1 varchar(9), key2 varchar(7), key3 int, key4 int, new integer)
RETURNS of_key AS
$$
DECLARE
id of_key;
BEGIN
	UPDATE b21_Oferecimento
	SET rel_oferecimento_semester = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_oferecimento_year = key3 AND rel_oferecimento_semester = key4
	RETURNING rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_class(key1 varchar(9), key2 varchar(7), key3 int, key4 int,  new integer)
RETURNS of_key AS
$$
DECLARE
id of_key;
BEGIN
	UPDATE b21_Oferecimento
	SET rel_oferecimento_class = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_oferecimento_year = key3 AND rel_oferecimento_semester = key4
	RETURNING rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Aluno_Oferecimento_prof_nusp(key1 varchar(9), key2 varchar(7), key3 varchar(9), new varchar(9))
RETURNS al_of_key AS
$$
DECLARE
id al_of_key;
BEGIN
	UPDATE b22_rel_al_of
	SET rel_prof_nusp = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_al_nusp = key3
	RETURNING rel_prof_nusp, rel_dis_code, rel_al_nusp into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Aluno_Oferecimento_dis_code(key1 varchar(9), key2 varchar(7), key3 varchar(9), new varchar(7))
RETURNS al_of_key AS
$$
DECLARE
id al_of_key;
BEGIN
	UPDATE b22_rel_al_of
	SET rel_dis_code = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_al_nusp = key3
	RETURNING rel_prof_nusp, rel_dis_code, rel_al_nusp into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Aluno_Oferecimento_al_nusp(key1 varchar(9), key2 varchar(7), key3 varchar(9), new varchar(9))
RETURNS al_of_key AS
$$
DECLARE
id al_of_key;
BEGIN
	UPDATE b22_rel_al_of
	SET rel_al_nusp = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_al_nusp = key3
	RETURNING rel_prof_nusp, rel_dis_code, rel_al_nusp into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Aluno_Oferecimento_grade(key1 varchar(9), key2 varchar(7), key3 varchar(9), new float(24))
RETURNS al_of_key AS
$$
DECLARE
id al_of_key;
BEGIN
	UPDATE b22_rel_al_of
	SET rel_al_of_grade = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_al_nusp = key3
	RETURNING rel_prof_nusp, rel_dis_code, rel_al_nusp into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Aluno_Oferecimento_attendance(key1 varchar(9), key2 varchar(7), key3 varchar(9), new float(24))
RETURNS al_of_key AS
$$
DECLARE
id al_of_key;
BEGIN
	UPDATE b22_rel_al_of
	SET rel_al_of_attendance = new
	WHERE rel_prof_nusp = key1 AND rel_dis_code = key2 AND rel_al_nusp = key3
	RETURNING rel_prof_nusp, rel_dis_code, rel_al_nusp into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_Times_prof_nusp(key1 varchar(9), key2 varchar(7), key3 TIME, key4 integer, new varchar(9))
RETURNS of_times_key AS
$$
DECLARE
id of_times_key;
BEGIN
	UPDATE b23_of_times
	SET prof_nusp = new
	WHERE prof_nusp = key1 AND dis_code = key2 AND time_in = key3 AND day = key4
	RETURNING prof_nusp, dis_code, time_in, day into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_Times_dis_code(key1 varchar(9), key2 varchar(7), key3 TIME, key4 integer, new varchar(7))
RETURNS of_times_key AS
$$
DECLARE
id of_times_key;
BEGIN
	UPDATE b23_of_times
	SET dis_code = new
	WHERE prof_nusp = key1 AND dis_code = key2 AND time_in = key3 AND day = key4
	RETURNING prof_nusp, dis_code, time_in, day into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_Times_time_in(key1 varchar(9), key2 varchar(7), key3 TIME, key4 integer, new TIME)
RETURNS of_times_key AS
$$
DECLARE
id of_times_key;
BEGIN
	UPDATE b23_of_times
	SET time_in = new
	WHERE prof_nusp = key1 AND dis_code = key2 AND time_in = key3 AND day = key4
	RETURNING prof_nusp, dis_code, time_in, day into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_Times_time_out(key1 varchar(9), key2 varchar(7), key3 TIME, key4 integer, new TIME)
RETURNS of_times_key AS
$$
DECLARE
id of_times_key;
BEGIN
	UPDATE b23_of_times
	SET time_out = new
	WHERE prof_nusp = key1 AND dis_code = key2 AND time_in = key3 AND day = key4
	RETURNING prof_nusp, dis_code, time_in, day into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_Oferecimento_Times_day(key1 varchar(9), key2 varchar(7), key3 TIME, key4 integer, new integer)
RETURNS of_times_key AS
$$
DECLARE
id of_times_key;
BEGIN
	UPDATE b23_of_times
	SET day = new
	WHERE prof_nusp = key1 AND dis_code = key2 AND time_in = key3 AND day = key4
	RETURNING prof_nusp, dis_code, time_in, day into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--RETRIEVALS
/* Os argumentos são um ano e semestre */
/* Retorna o nome e nusp de todos os professores lecionando neste ano e semestre, assim como o código e nome das disciplinas */
/* que o respectivo professor lecionou em tal ano e semestre */
BEGIN;
CREATE OR REPLACE FUNCTION working_profs(semestre integer, ano integer)
RETURNS TABLE(Nome varchar(11), Nusp varchar(9), Disc_Code varchar(7), Disciplina varchar(80)) AS
$$
BEGIN
	RETURN QUERY
		SELECT pes_name as Nome, prof_nusp as Nusp, dis_code as Disc_Code, dis_name as Disciplina 
		FROM b01_pessoa
		INNER JOIN b02_professor on pes_cpf = prof_cpf
		INNER JOIN b21_oferecimento on prof_nusp = rel_prof_nusp 
		INNER JOIN b05_disciplina on rel_dis_code = dis_code
		WHERE rel_oferecimento_semester = $1 and rel_oferecimento_year = $2;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são um ano e semestre */
/* Retorna o nome e nusp de todos os professores lecionando neste ano e semestre, assim como o código e nome das disciplinas */
/* que o respectivo professor lecionou em tal ano e semestre */
BEGIN;
CREATE OR REPLACE FUNCTION working_profs(semestre integer, ano integer)
RETURNS TABLE(Nome varchar(11), Nusp varchar(9), Disc_Code varchar(7), Disciplina varchar(80)) AS
$$
BEGIN
	RETURN QUERY
		SELECT pes_name as Nome, prof_nusp as Nusp, dis_code as Disc_Code, dis_name as Disciplina 
		FROM b01_pessoa
		INNER JOIN b02_professor on pes_cpf = prof_cpf
		INNER JOIN b21_oferecimento on prof_nusp = rel_prof_nusp 
		INNER JOIN b05_disciplina on rel_dis_code = dis_code
		WHERE rel_oferecimento_semester = $1 and rel_oferecimento_year = $2;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave do Oferecimento */
/* Retorna todos os Alunos de determinado Oferecimento */
BEGIN;
CREATE OR REPLACE FUNCTION assigned_students(prof_nusp varchar(9), dis_code varchar(7), semestre integer, ano integer)
RETURNS TABLE(Disc_Code varchar(7), Disciplina varchar(80), Nome varchar(200), Nusp varchar(9)) AS
$$
BEGIN
	RETURN QUERY
		SELECT dis.dis_code, dis.dis_name, pe.pes_name, al.al_nusp
		FROM b21_oferecimento as of
		INNER JOIN b05_disciplina as dis on of.rel_dis_code = dis.dis_code
		INNER JOIN b22_rel_al_of as rel 
			ON of.rel_prof_nusp = rel.rel_prof_nusp 
			AND of.rel_dis_code = rel.rel_dis_code
			AND of.rel_oferecimento_year = rel.rel_al_of_year
			AND of.rel_oferecimento_semester = rel.rel_al_of_semester
		INNER JOIN b03_Aluno as al ON rel.rel_al_nusp = al.al_nusp
		INNER JOIN b01_pessoa as pe ON al.al_cpf = pes_cpf
		WHERE of.rel_prof_nusp = $1 and of.rel_dis_code = $2 
			and of.rel_oferecimento_semester = $3 
			and of.rel_oferecimento_year = $4;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são as chaves de um Aluno e Oferecimento */
/* Retorna a nota do Aluno no Oferecimento especificado */
BEGIN;
CREATE OR REPLACE FUNCTION aluno_grade(al_nusp varchar(9), prof_nusp varchar(9), dis_code varchar(7), semestre integer, ano integer)
RETURNS TABLE(Disc_Code varchar(7), Disciplina varchar(80), Nusp varchar(9), Nota float(24)) AS
$$
BEGIN
	RETURN QUERY
		SELECT dis.dis_code, dis_name, al_nusp, rel_al_of_grade
		FROM b22_rel_al_of
		INNER JOIN b05_disciplina as dis on rel_dis_code = dis.dis_code
		WHERE rel_al_nusp = $1 and rel_prof_nusp = $2 
			and rel_dis_code = $3
			and rel_al_of_semester = $4
			and rel_al_of_year = $5;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são as chaves de um Aluno e Oferecimento */
/* Retorna o nusp e presença do Aluno no Oferecimento especificado, assim como o código e nome da Disciplina */
BEGIN;
CREATE OR REPLACE FUNCTION aluno_attendance(al_nusp varchar(9), prof_nusp varchar(9), dis_code varchar(7), semestre integer, ano integer)
RETURNS TABLE(Disc_Code varchar(7), Disciplina varchar(80), Nusp varchar(9), Attendance float(24)) AS
$$
BEGIN
	RETURN QUERY
		SELECT dis.dis_code, dis_name, al_nusp, rel_al_of_attendance
		FROM b22_rel_al_of
		INNER JOIN b05_disciplina as dis on rel_dis_code = dis.dis_code
		WHERE rel_al_nusp = $1 and rel_prof_nusp = $2 
			and rel_dis_code = $3
			and rel_al_of_semester = $4
			and rel_al_of_year = $5;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são as chaves de um Aluno e Oferecimento */
/* Retorna verdadeiro caso o Aluno tenha tido nota maior ou igual a 5 e presença maior que 70%, e falso caso contrário */
BEGIN;
CREATE OR REPLACE FUNCTION aluno_aproved(al_nusp varchar(9), prof_nusp varchar(9), dis_code varchar(7), semestre integer, ano integer)
RETURNS TABLE(Disc_Code varchar(7), Disciplina varchar(80), Nusp varchar(9), Aprovado boolean) AS
$$
BEGIN
	RETURN QUERY
		SELECT dis.dis_code, dis_name, rel_al_nusp, 
		CASE WHEN rel_al_of_grade >= 5 and rel_al_of_attendance >= 0.7 THEN true
			ELSE false
			END as aproved
		FROM b22_rel_al_of
		INNER JOIN b05_disciplina as dis on rel_dis_code = dis.dis_code
		WHERE rel_al_nusp = $1 and rel_prof_nusp = $2 
			and rel_dis_code = $3
			and rel_al_of_semester = $4
			and rel_al_of_year = $5;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Oferecimento e um valor nota_min */
/* Retorna o nusp nota do Aluno no Oferecimento especificado, assim como o código e nome da Disciplina */
BEGIN;
CREATE OR REPLACE FUNCTION aproved_students(prof_nusp varchar(9), dis_code varchar(7), semestre integer, ano integer, nota_min float(24))
RETURNS TABLE(Disc_Code varchar(7), Disciplina varchar(80), Nusp varchar(9), Nota float(24)) AS
$$
BEGIN
	RETURN QUERY
		SELECT dis.dis_code, dis.dis_name, al.al_nusp, rel.rel_al_of_grade
		FROM b21_oferecimento as of
		INNER JOIN b05_disciplina as dis on of.rel_dis_code = dis.dis_code
		INNER JOIN b22_rel_al_of as rel 
			ON of.rel_prof_nusp = rel.rel_prof_nusp 
			AND of.rel_dis_code = rel.rel_dis_code
			AND of.rel_oferecimento_year = rel.rel_al_of_year
			AND of.rel_oferecimento_semester = rel.rel_al_of_semester
		INNER JOIN b03_Aluno as al ON rel.rel_al_nusp = al.al_nusp
		WHERE of.rel_prof_nusp = $1 and of.rel_dis_code = $2 
			and of.rel_oferecimento_semester = $3 
			and of.rel_oferecimento_year = $4
			and rel.rel_al_of_grade >= $5
			and rel.rel_al_of_attendance >= 0.7;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são a chave de um Aluno */
/* Retorna as trilhas completadas pelo Aluno */
BEGIN;
CREATE OR REPLACE FUNCTION check_trilhas(al_nusp varchar(9))
RETURNS TABLE(Trilha varchar(80), Completa boolean) AS
$$
DECLARE
tr record;
mod record;
disc record;
creds integer;
BEGIN
	FOR tr IN (SELECT tr_name FROM b07_Trilha)
	LOOP
		FOR mod IN (SELECT mod_code, mod_cred_min FROM b12_rel_tr_mod
						INNER JOIN b08_Modulo ON mod_code = rel_mod_code
						WHERE rel_tr_name = tr.tr_name and rel_tr_mod_mandatory = true)
		LOOP
			creds := 0;

			FOR disc IN (SELECT dis_code, dis_class_creds, dis_work_creds FROM b05_Disciplina as dis
							INNER JOIN b18_rel_dis_mod as b18 ON dis.dis_code = b18.rel_dis_code
															  and b18.rel_mod_code = mod.mod_code)
			LOOP
				IF EXISTS (SELECT 1 FROM b22_rel_al_of WHERE rel_al_nusp = $1 
														and rel_dis_code = disc.dis_code
														and rel_al_of_grade >= 5
														and rel_al_of_attendance >= 0.7)
				THEN
					creds := creds + disc.dis_class_creds + disc.dis_work_creds;
				END IF;

			END LOOP;

				IF creds >= mod.mod_cred_min

				THEN
					Completa := true;

				ELSE
					Completa := false;

				END IF;

				Trilha := tr.tr_name;
				RETURN NEXT;
		END LOOP;

	END LOOP;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são as chaves de um Aluno e Oferecimento */
/* Retorna o código da Disciplina e se o Aluno cumpriu seus requerimentos (true) ou não (false) */
BEGIN;
CREATE OR REPLACE FUNCTION check_disc(al_nusp varchar(9), dis_code varchar(7))
RETURNS TABLE(Disciplina varchar(7), Disponivel boolean) AS
$$
DECLARE
disp boolean;
req record;
creds integer;
BEGIN
	Disciplina := $2;
	disp := true;
	FOR req IN (SELECT dis_req_code FROM b24_rel_dis_dis as b24 WHERE b24.dis_code = $2)
	LOOP

		IF NOT EXISTS (SELECT 1 FROM b22_rel_al_of WHERE rel_al_nusp = $1 
													and rel_dis_code = req.dis_req_code
													and rel_al_of_grade >= 5
													and rel_al_of_attendance >= 0.7)
		THEN
			disp := false;
			EXIT;
		END IF;

	END LOOP;
	Disponivel := disp;
	RETURN NEXT;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* Os argumentos são as chaves de um Aluno, um ano e um semestre */
/* Retorna o nome das disciplinas cursadas pelo tal Aluno no ano e semestre específicado, e o nome do professor que as lecionou */
BEGIN;
CREATE OR REPLACE FUNCTION get_Oferecimentos(nusp varchar(9), ano integer, semestre integer)
RETURNS TABLE(Nome_disciplina varchar(80), Nome_professor varchar(200)) AS
$$
BEGIN
	RETURN QUERY
		SELECT b05.dis_name, b01.pes_name
		FROM b22_rel_al_of as b22
		INNER JOIN b05_Disciplina as b05 ON b22.rel_dis_code = b05.dis_code
		INNER JOIN b21_Oferecimento as b21 ON b21.rel_dis_code = b22.rel_dis_code
		INNER JOIN b02_Professor as b02 ON b22.rel_prof_nusp = b02.prof_nusp
		INNER JOIN b01_Pessoa as b01 ON b02.prof_cpf = b01.pes_cpf
		WHERE rel_al_nusp = $1 AND rel_oferecimento_year = $2 AND rel_oferecimento_semester = $3;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b16_rel_prof_disc_semester(prim_key varchar(9), sec_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT rel_prof_disc_semester INTO value
	FROM b16_rel_prof_dis
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b16_rel_prof_disc_year(prim_key varchar(9), sec_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT rel_prof_disc_year INTO value
	FROM b16_rel_prof_dis
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b17_plan_semester(prim_key varchar(9), sec_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT plan_semester INTO value
	FROM b17_rel_al_dis
	WHERE rel_al_nusp = $1 AND rel_dis_code = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b17_plan_year(prim_key varchar(9), sec_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT plan_year INTO value
	FROM b17_rel_al_dis
	WHERE rel_al_nusp = $1 AND rel_dis_code = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b21_rel_oferecimento_class(prim_key varchar(9), sec_key varchar(7), tec_key integer, qua_key integer)
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT rel_oferecimento_class INTO value
	FROM b21_Oferecimento
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2 AND rel_oferecimento_year = $3 AND rel_oferecimento_semester = $4;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b22_rel_al_of_grade(prim_key varchar(9), sec_key varchar(7), tec_key varchar(9), qua_key integer, pen_key integer)
RETURNS float(24) AS
$$
DECLARE
value float(24);
BEGIN
	SELECT rel_al_of_grade INTO value
	FROM b22_rel_al_of
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2 AND rel_al_nusp = $3 AND rel_al_of_year = $4 AND rel_al_of_semester = $5;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b22_rel_al_of_attendance(prim_key varchar(9), sec_key varchar(7), tec_key varchar(9), qua_key integer, pen_key integer)
RETURNS float(24) AS
$$
DECLARE
value float(24);
BEGIN
	SELECT rel_al_of_attendance INTO value
	FROM b22_rel_al_of
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2 AND rel_al_nusp = $3 AND rel_al_of_year = $4 AND rel_al_of_semester = $5;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b23_time_out(prim_key varchar(9), sec_key varchar(7), tec_key integer, qua_key integer, pen_key TIME, sex_key integer)
RETURNS TIME AS
$$
DECLARE
value TIME;
BEGIN
	SELECT time_out INTO value
	FROM b23_of_times
	WHERE prof_nusp = $1 AND dis_code = $2 AND year = $3 AND semester = $4 AND time_in = $5 AND day = $6;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

--DML Exemplos
/* rel prof disciplina */
INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('1', 'MAC0100', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('2', 'MAC0101', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('3', 'MAC0102', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('4', 'MAC0103', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('5', 'MAC0104', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('6', 'MAC0105', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('7', 'MAC0106', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('8', 'MAC0107', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('9', 'MAC0108', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('10', 'MAC0109', 1, 2019);

/* rel aluno disc */
INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('11', 'MAC0100', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('12', 'MAC0101', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('13', 'MAC0102', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('14', 'MAC0103', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('15', 'MAC0104', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('16', 'MAC0105', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('17', 'MAC0106', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('18', 'MAC0107', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('19', 'MAC0108', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('20', 'MAC0109', 1, 2019);

/* Oferecimento */
INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('1', 'MAC0100', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('2', 'MAC0101', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('3', 'MAC0102', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('4', 'MAC0103', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('5', 'MAC0104', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('6', 'MAC0105', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('7', 'MAC0106', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('8', 'MAC0107', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('9', 'MAC0108', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('10', 'MAC0109', 2019, 1, 45);

/* rel aluno oferecimento */
INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('1', 'MAC0100', '11', 2019, 1, 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('2', 'MAC0101', '12', 2019, 1, 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('3', 'MAC0102', '13', 2019, 1, 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('4', 'MAC0103', '14', 2019, 1, 9.0, 8.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('5', 'MAC0104', '15', 2019, 1, 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('6', 'MAC0105', '16', 2019, 1, 8.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('7', 'MAC0106', '17', 2019, 1, 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('8', 'MAC0107', '18', 2019, 1, 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('9', 'MAC0108', '19', 2019, 1, 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_year, rel_al_of_semester, rel_al_of_grade, rel_al_of_attendance)
	VALUES ('10', 'MAC0109', '20', 2019, 1, 5.0, 0.0);


/* horarios do oferecimento */
INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('1', 'MAC0100', 2019, 1, '01:02:03', '05:02:03', 2);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('2', 'MAC0101', 2019, 1, '01:02:03', '05:02:03', 3);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('3', 'MAC0102', 2019, 1, '01:02:03', '05:02:03', 4);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('4', 'MAC0103', 2019, 1, '01:02:03', '05:02:03', 5);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('5', 'MAC0104', 2019, 1, '01:02:03', '05:02:03', 6);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('6', 'MAC0105', 2019, 1, '01:02:03', '05:02:03', 7);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('7', 'MAC0106', 2019, 1, '01:02:03', '05:02:03', 1);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('8', 'MAC0107', 2019, 1, '01:02:03', '05:02:03', 2);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('9', 'MAC0108', 2019, 1, '01:02:03', '05:02:03', 3);

INSERT INTO  b23_of_times (prof_nusp, dis_code, year, semester, time_in, time_out, day)
	VALUES ('10', 'MAC0109', 2019, 1, '01:02:03', '05:02:03', 4);
