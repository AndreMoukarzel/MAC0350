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

BEGIN;
CREATE OR REPLACE FUNCTION update_Disciplina_Disciplina_disc_code(key1 varchar(7), key2 varchar(7), new varchar(7))
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
CREATE OR REPLACE FUNCTION update_Disciplina_Disciplina_disc_code(key1 varchar(7), key2 varchar(7), new varchar(7))
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