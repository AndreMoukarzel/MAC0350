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

BEGIN;
CREATE OR REPLACE FUNCTION delete_dis_dis(key1 varchar(7), key2 varchar(7))
RETURNS dis_dis_key AS
$$
DECLARE
id dis_dis_key;
BEGIN
	DELETE FROM b24_rel_dis_dis
	WHERE dis_code = key1 AND dis_req_code = key2
	RETURNING key1, key2 into id;
	RETURN id;
END;
$$
LANGUAGE plpgsql;
COMMIT;
