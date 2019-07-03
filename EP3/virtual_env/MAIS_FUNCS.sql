BEGIN;
CREATE OR REPLACE FUNCTION check_login(user_email email, user_pass TEXT)
RETURNS TABLE(Email email) AS
$$
BEGIN

	RETURN QUERY
	SELECT us_email
	FROM public.users
	WHERE us_email = $1 AND us_password = public.crypt($2, us_password);

END;
$$
LANGUAGE plpgsql;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION get_servs_from_email(user_email email)
RETURNS TABLE(codigo integer) AS
$$
BEGIN

	RETURN QUERY
		SELECT serv_code
		FROM b11_servico
		INNER JOIN b15_rel_pf_se as b15
			ON serv_code = b15.rel_serv_code
		INNER JOIN b10_perfil
			ON perf_name = b15.rel_perf_name
		INNER JOIN b14_rel_us_pf as b14
			ON perf_name = b14.rel_perf_name
		WHERE b14.rel_us_email = $1;
END;
$$
LANGUAGE plpgsql;
COMMIT;