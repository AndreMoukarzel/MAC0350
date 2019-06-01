/* FUNÇÃO BASE
BEGIN;
CREATE OR REPLACE FUNCTION func()
RETURNS TABLE() AS
$$
BEGIN
	RETURN QUERY
		SELECT 
		FROM 
		WHERE;
END;
$$
LANGUAGE plpgsql;
COMMIT;
*/

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
		SELECT dis.dis_code, dis_name, al_nusp, 
		CASE WHEN rel_al_of_grade >= 5 THEN true
			ELSE false
			END as aproved
		FROM b22_rel_al_of
		INNER JOIN b05_disciplina as dis on rel_dis_code = dis.dis_code
		WHERE rel_al_nusp = $1 and rel_prof_nusp = $2 
			and rel_dis_code = $3
			and rel_al_of_semester = $4
			and rel_al_of_year = $5
			and rel_al_of_grade >= 5
			and rel_al_of_attendance >= 0.7;
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


/* Os argumentos são a chave de um Curso */
/* Retorna os administradores que administram tal Curso */
BEGIN;
CREATE OR REPLACE FUNCTION get_admin(cur_code integer)
RETURNS TABLE(CPF varchar(11), Email email) AS
$$
BEGIN
	RETURN QUERY
		SELECT b04.adm_cpf, b04.adm_email
		FROM b04_Administrador as b04
		INNER JOIN b06_Curso as b06 ON b04.adm_cpf = b06.adm_cpf
		WHERE b06.cur_code = $1;
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
		INNER JOIN b05_Disciplina as b05 ON b22.dis_code = b05.dis_code
		INNER JOIN b21_Oferecimento as b21 ON b21.dis_code = b22.dis_code
		INNER JOIN b02_Professor as b02 ON b22.prof_nusp = b02.prof_nusp
		INNER JOIN b01_Pessoa as b01 ON b02.prof_cpf = b01.pes_cpf
		WHERE  al_nusp = $1 AND rel_oferecimento_year = $2 AND rel_oferecimento_semester = $3
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
		FROM b18_rel_tr_cur
		WHERE rel_mod_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;
			   
/* Os argumentos são a chave de uma Disciplina */
/* Retorna os Modulos relacionados a tal Disciplina */
BEGIN;
CREATE OR REPLACE FUNCTION get_Disciplina(dis varchar(7))
RETURNS TABLE(Codigo integer) AS
$$
BEGIN
	RETURN QUERY
		SELECT rel_mod_code
		FROM b18_rel_tr_cur
		WHERE rel_dis_code = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;
			 
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
	WHERE prof_nusp = $1 AND dis_code = $2 AND rel_al_of_year = $3 AND rel_al_of_semester = $4 AND time_in = $5 AND day = $6;
	RETURN value;
END;
$$
LANGUAGE plpgsql;
COMMIT;
