/* Selectiona todos os professores que oferecem materia nesse ano e semestre*/
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
