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
RETURNS varchar(40) AS
$$
DECLARE
value varchar(40);
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
CREATE OR REPLACE FUNCTION select_b12_rel_tr_mod_mandatory(prim_key varchar(80), sec_key integer)
RETURNS boolean AS
$$
DECLARE
value boolean;
BEGIN
	SELECT rel_tr_mod_mandatory INTO value
	FROM b12_rel_tr_mod
	WHERE rel_tr_name = $1 AND rel_mod_code = $2;
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

BEGIN;
CREATE OR REPLACE FUNCTION select_b21_rel_dis_code(prim_key varchar(9))
RETURNS varchar(7) AS
$$
DECLARE
value varchar(7);
BEGIN
	SELECT rel_dis_code INTO value
	FROM b21_Oferecimento
	WHERE rel_prof_nusp = $1;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b21_rel_oferecimento_year(prim_key varchar(9), sec_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT rel_oferecimento_year INTO value
	FROM b21_Oferecimento
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b21_rel_oferecimento_semester(prim_key varchar(9), sec_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT rel_oferecimento_semester INTO value
	FROM b21_Oferecimento
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b21_rel_oferecimento_class(prim_key varchar(9), sec_key varchar(7))
RETURNS integer AS
$$
DECLARE
value integer;
BEGIN
	SELECT rel_oferecimento_class INTO value
	FROM b21_Oferecimento
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b22_rel_al_of_grade(prim_key varchar(9), sec_key varchar(7), tec_key varchar(9))
RETURNS float(24) AS
$$
DECLARE
value float(24);
BEGIN
	SELECT rel_al_of_grade INTO value
	FROM b22_rel_al_of
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2 AND rel_al_nusp = $3;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b22_rel_al_of_presence(prim_key varchar(9), sec_key varchar(7), tec_key varchar(9))
RETURNS float(24) AS
$$
DECLARE
value float(24);
BEGIN
	SELECT rel_al_of_presence INTO value
	FROM b22_rel_al_of
	WHERE rel_prof_nusp = $1 AND rel_dis_code = $2 AND rel_al_nusp = $3;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION select_b23_time_out(prim_key varchar(9), sec_key varchar(7), tec_key TIME, qua_key integer)
RETURNS TIME AS
$$
DECLARE
value TIME;
BEGIN
	SELECT time_out INTO value
	FROM b23_of_times
	WHERE prof_nusp = $1 AND dis_code = $2 AND time_in = $3 AND day = $4;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;
