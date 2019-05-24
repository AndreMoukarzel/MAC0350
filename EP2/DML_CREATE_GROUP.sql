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


DROP TYPE IF EXISTS tr_mod_key CASCADE;
CREATE TYPE tr_mod_key AS (c1 varchar(80), c2 integer);

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
RETURNS tr_mod_key AS
$$
DECLARE
id tr_mod_key; /* A chave tem os mesmos tipos */
BEGIN
	INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ($1, $2)
	RETURNING rel_tr_name, rel_cur_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

DROP TYPE IF EXISTS us_pf_key CASCADE;
CREATE TYPE us_pf_key AS (c1 email, c2 varchar(20));

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

DROP TYPE IF EXISTS pf_se_key CASCADE;
CREATE TYPE pf_se_key AS (c1 varchar(20), c2 integer);

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

DROP TYPE IF EXISTS prof_dis_key CASCADE;
CREATE TYPE prof_dis_key AS (c1 varchar(9), c2 varchar(7));

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_prof_dis(arg0 varchar(9), arg1 varchar(7), arg2 integer, arg3 integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key;
BEGIN
	INSERT INTO b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ($1, $2, $3, $4)
	RETURNING rel_prof_nusp, rel_dis_code into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_al_dis(arg0 varchar(9), arg1 varchar(7), arg2 integer, arg3 integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key; /* mesmos valores*/
BEGIN
	INSERT INTO b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ($1, $2, $3, $4)
	RETURNING rel_al_nusp, rel_dis_code into id.
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

DROP TYPE IF EXISTS dis_mod_key CASCADE;
CREATE TYPE dis_mod_key AS (c1 varchar(7), c2 integer);

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_dis_mod(arg0 varchar(7), arg1 integer)
RETURNS dis_mod_key AS
$$
DECLARE
id dis_mod_key;
BEGIN
	INSERT INTO b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ($1, $2)
	RETURNING rel_dis_code, rel_mod_code into id.
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

DROP TYPE IF EXISTS mod_cur_key CASCADE;
CREATE TYPE mod_cur_key AS (c1 integer, c2 integer);

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_mod_cur(arg0 integer, arg1 integer)
RETURNS mod_cur_key AS
$$
DECLARE
id mod_cur_key;
BEGIN
	INSERT INTO b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES ($1, $2)
	RETURNING rel_mod_code, rel_cur_code into id.
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

DROP TYPE IF EXISTS pes_us_key CASCADE;
CREATE TYPE pes_us_key AS (c1 varchar(11), c2 email);

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_pes_us(arg0 varchar(11), arg1 email, arg2 TIMESTAMP, arg3 TIMESTAMP)
RETURNS pes_us_key AS
$$
DECLARE
id pes_us_key;
BEGIN
	INSERT INTO b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ($1, $2, $3, $4)
	RETURNING rel_pes_cpf, rel_us_email into id.
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION create_Oferecimento(arg0 varchar(9), arg1 varchar(7), arg2 integer, arg3 integer, arg4 integer)
RETURNS prof_dis_key AS
$$
DECLARE
id prof_dis_key; /*mesmos valores*/
BEGIN
	INSERT INTO b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ($1, $2, $3, $4, $5)
	RETURNING rel_prof_nusp, rel_dis_code into id.
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

DROP TYPE IF EXISTS al_of_key CASCADE;
CREATE TYPE al_of_key AS (c1 varchar(9), c2 varchar(7), c3 varchar(9));

BEGIN;
CREATE OR REPLACE FUNCTION create_rel_al_of(arg0 varchar(9), arg1 varchar(7), arg2 varchar(9), arg3 float(24), arg4 float(24))
RETURNS al_of_key AS
$$
DECLARE
id al_of_key;
BEGIN
	INSERT INTO b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ($1, $2, $3, $4, $5)
	RETURNING rel_prof_nusp, rel_dis_code, rel_al_nusp into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;

DROP TYPE IF EXISTS of_times_key CASCADE;
CREATE TYPE of_times_key AS (c1 varchar(9), c2 varchar(7), c3 TIME, c4 integer);

BEGIN;
CREATE OR REPLACE FUNCTION create_of_times(arg0 varchar(9), arg1 varchar(7), arg2 TIME, arg3 TIME, arg4 integer)
RETURNS of_times_key AS
$$
DECLARE
id of_times_key;
BEGIN
	INSERT INTO b23_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ($1, $2, $3, $4, $5)
	RETURNING prof_nusp, dis_code, time_in, day into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;
