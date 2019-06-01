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

/* Selectiona todos os professores e disciplinas oferecidas nesse ano e semestre*/
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

/* Selectiona todos os alunos de determinado oferecimento */
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

/* nota de um aluno */
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

/* presença de um aluno */
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

/* se um aluno passou */
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
			and rel_al_of_year = $5;
END;
$$
LANGUAGE plpgsql;
COMMIT;

/* todos alunos com nota maior que X */
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
			and rel.rel_al_of_grade >= $5;
END;
$$
LANGUAGE plpgsql;
COMMIT;