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