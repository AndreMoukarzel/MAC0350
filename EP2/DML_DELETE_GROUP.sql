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
CREATE OR REPLACE FUNCTION delete_users(key email)
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
