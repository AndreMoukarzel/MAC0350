BEGIN;
CREATE OR REPLACE FUNCTION delete_Pessoa_(key varchar(11))
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