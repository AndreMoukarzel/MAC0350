BEGIN;
CREATE OR REPLACE FUNCTION create_pessoa(cpf varchar(11), nome varchar(200))
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