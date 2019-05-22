/*
Next lines checks if you have permission to create extensions
and:
	*create two extensions: pgcrypto for password and citext for email check
	*create a role dba and a schema admins
	*grant permissions to dba over admins
*/

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
-- For security create admin schema as well
CREATE ROLE dba
	WITH SUPERUSER CREATEDB CREATEROLE
	LOGIN ENCRYPTED PASSWORD 'dba1234'
	VALID UNTIL '2019-07-01';
CREATE SCHEMA IF NOT EXISTS admins;
GRANT admins TO dba;

DROP DOMAIN IF EXISTS email CASCADE;
CREATE DOMAIN email AS citext
	CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

CREATE TABLE b01_Pessoa (
	pes_id SERIAL,
	pes_cpf varchar(11) NOT NULL,
	pes_name varchar(200),
	CONSTRAINT pk_pessoa PRIMARY KEY (pes_id),
	CONSTRAINT sk_pessoa UNIQUE (pes_cpf)
);

CREATE TABLE b02_Professor (
	prof_id SERIAL,
	prof_nusp varchar(9) NOT NULL,
	prof_cpf varchar(11),
	CONSTRAINT pk_professor PRIMARY KEY (prof_id),
	CONSTRAINT sk_professor UNIQUE (prof_nusp),
	CONSTRAINT fk_pessoa FOREIGN KEY (prof_cpf)
		REFERENCES b01_Pessoa(pes_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE
); 

CREATE TABLE b03_Aluno (
	al_id SERIAL,
	al_nusp varchar(9) NOT NULL,
	al_cpf varchar(11),
	CONSTRAINT pk_aluno PRIMARY KEY (al_id),
	CONSTRAINT sk_aluno UNIQUE (al_nusp),
	CONSTRAINT fk_pessoa FOREIGN KEY (al_cpf)
		REFERENCES b01_Pessoa(pes_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b04_Administrador (
	adm_id SERIAL,
	adm_cpf varchar(11),
	adm_email email NOT NULL,
	adm_dat_in TIMESTAMP NOT NULL,
	adm_dat_out TIMESTAMP,
	CONSTRAINT pk_administrador PRIMARY KEY (adm_id),
	CONSTRAINT sk_administrador UNIQUE (adm_email),
	CONSTRAINT adm_cpf UNIQUE (adm_cpf),
	CONSTRAINT fk_pessoa FOREIGN KEY (adm_cpf)
		REFERENCES b01_Pessoa(pes_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b05_Disciplina (
	dis_id SERIAL,
	dis_code varchar(7) NOT NULL,
	dis_name varchar(80),
	dis_class_creds integer,
	dis_work_creds integer,
	CONSTRAINT pk_disciplina PRIMARY KEY (dis_id),
		CONSTRAINT sk_disciplina UNIQUE (dis_code)

);

CREATE TABLE b06_Curso (
	cur_id SERIAL,
	cur_code integer NOT NULL,
	cur_name varchar(60),
	adm_cpf varchar(11),
	ad_cur_date_in TIMESTAMP,
	ad_cur_date_out TIMESTAMP,
	CONSTRAINT pk_curso PRIMARY KEY (cur_id),
	CONSTRAINT sk_curso UNIQUE (cur_code),
	CONSTRAINT fk_adm FOREIGN KEY (adm_cpf)
		REFERENCES b04_Administrador(adm_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b07_Trilha (
	tr_id SERIAL,
	tr_name varchar(80) NOT NULL,
	CONSTRAINT pk_trilha PRIMARY KEY (tr_id),
	CONSTRAINT sk_trilha UNIQUE (tr_name)
);

CREATE TABLE b08_Modulo (
	mod_id SERIAL,
	mod_code integer NOT NULL,
	mod_name varchar(40),
	mod_cred_min integer,
	CONSTRAINT pk_modulo PRIMARY KEY (mod_id),
	CONSTRAINT sk_modulo UNIQUE (mod_code),
	CONSTRAINT cred_check CHECK (mod_cred_min > 0)
);

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	us_id       SERIAL,
	us_email    email,
	us_password TEXT NOT NULL,
	CONSTRAINT pk_user PRIMARY KEY (us_id),
	CONSTRAINT sk_user UNIQUE (us_email)
);

CREATE TABLE b10_Perfil (
	perf_id SERIAL,
	perf_name varchar(20) NOT NULL, 
	perf_desc varchar(100),
	CONSTRAINT pk_perfil PRIMARY KEY (perf_id),
	CONSTRAINT sk_perfil UNIQUE (perf_name)
);

CREATE TABLE b11_Servico (
	serv_id SERIAL,
	serv_code integer NOT NULL,
	serv_name varchar(50) NOT NULL,
	serv_desc varchar(280),
	CONSTRAINT pk_servico PRIMARY KEY (serv_id),
	CONSTRAINT sk_servico UNIQUE (serv_code)
);

CREATE TABLE b12_rel_tr_mod (
	rel_tr_name varchar(80) NOT NULL,
	rel_mod_code integer NOT NULL,
	rel_tr_mod_mandatory boolean,
	CONSTRAINT pk_rel_tr_mod PRIMARY KEY (rel_tr_name, rel_mod_code),
	CONSTRAINT fk_tr_name FOREIGN KEY (rel_tr_name)
		REFERENCES b07_Trilha(tr_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_mod_code FOREIGN KEY (rel_mod_code)
		REFERENCES b08_Modulo(mod_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b13_rel_tr_cur (
	rel_tr_name varchar(80) NOT NULL,
	rel_cur_code integer NOT NULL,
	CONSTRAINT pk_rel_tr_cur PRIMARY KEY (rel_tr_name, rel_cur_code),
	CONSTRAINT fk_tr_name FOREIGN KEY (rel_tr_name)
		REFERENCES b07_Trilha(tr_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_cur_code FOREIGN KEY (rel_cur_code)
		REFERENCES b06_Curso(cur_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b14_rel_us_pf (
	rel_us_email email NOT NULL,
	rel_perf_name varchar(20) NOT NULL,
	rel_us_pf_date_in TIMESTAMP,
	rel_us_pf_date_out TIMESTAMP,
	CONSTRAINT pk_rel_us_pf PRIMARY KEY (rel_us_email, rel_perf_name),
	CONSTRAINT fk_us_email FOREIGN KEY (rel_us_email)
		REFERENCES users(us_email)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_perf_name FOREIGN KEY (rel_perf_name)
		REFERENCES b10_Perfil(perf_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b15_rel_pf_se (
	rel_perf_name varchar(20) NOT NULL,
	rel_serv_code integer NOT NULL,
	CONSTRAINT pk_rel_pf_se PRIMARY KEY (rel_perf_name, rel_serv_code),
	CONSTRAINT fk_perf_name FOREIGN KEY (rel_perf_name)
		REFERENCES b10_Perfil(perf_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_serv_code FOREIGN KEY (rel_serv_code)
		REFERENCES b11_Servico(serv_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b16_rel_prof_dis (
	rel_prof_nusp varchar(9) NOT NULL,
	rel_dis_code varchar(7) NOT NULL,
	rel_prof_disc_semester integer,
	rel_prof_disc_year integer,
	CONSTRAINT pk_rel_prof_dis PRIMARY KEY (rel_prof_nusp, rel_dis_code),
	CONSTRAINT fk_prof_nusp FOREIGN KEY (rel_prof_nusp)
		REFERENCES b02_Professor(prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b17_rel_al_dis (
	rel_al_nusp varchar(9) NOT NULL,
	rel_dis_code varchar(7) NOT NULL,
	plan_semester integer,
	plan_year integer,
	CONSTRAINT pk_rel_al_dis PRIMARY KEY (rel_al_nusp, rel_dis_code),
	CONSTRAINT fk_al_nusp FOREIGN KEY (rel_al_nusp)
		REFERENCES b03_Aluno(al_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES  b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b18_rel_dis_mod (
	rel_dis_code varchar(7) NOT NULL,
	rel_mod_code integer NOT NULL,
	CONSTRAINT pk_rel_dis_mod PRIMARY KEY (rel_dis_code, rel_mod_code),
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_mod_code FOREIGN KEY (rel_mod_code)
		REFERENCES b08_Modulo(mod_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b19_rel_mod_cur (
	rel_mod_code integer NOT NULL,
	rel_cur_code integer NOT NULL,
	CONSTRAINT pk_rel_mod_cur PRIMARY KEY (rel_mod_code, rel_cur_code),
	CONSTRAINT fk_mod_code FOREIGN KEY (rel_mod_code)
		REFERENCES b08_Modulo(mod_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_cur_code FOREIGN KEY (rel_cur_code)
		REFERENCES b06_Curso(cur_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b20_rel_pes_us (
	rel_pes_cpf varchar(11) NOT NULL,
	rel_us_email email NOT NULL,
	rel_pes_us_date_in TIMESTAMP NOT NULL,
	rel_pes_us_date_out TIMESTAMP,
	CONSTRAINT pk_rel_pes_us PRIMARY KEY (rel_pes_cpf, rel_us_email),
	CONSTRAINT fk_pes_cpf FOREIGN KEY (rel_pes_cpf)
		REFERENCES b01_Pessoa(pes_cpf)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_us_email FOREIGN KEY (rel_us_email)
		REFERENCES users(us_email)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b21_Oferecimento (
	rel_prof_nusp varchar(9) NOT NULL,
	rel_dis_code varchar(7) NOT NULL,
	rel_oferecimento_year integer,
	rel_oferecimento_semester integer,
	rel_oferecimento_class integer,
	CONSTRAINT pk_oferecimento PRIMARY KEY (rel_prof_nusp, rel_dis_code),
	CONSTRAINT fk_prof_nusp FOREIGN KEY (rel_prof_nusp)
		REFERENCES b02_Professor(prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b22_rel_al_of (
	rel_prof_nusp varchar(9) NOT NULL,
	rel_dis_code varchar(7) NOT NULL,
	rel_al_nusp varchar(9) NOT NULL,
	rel_al_of_grade float(24),
	rel_al_of_presence float(24),
	CONSTRAINT pk_rel_al_of PRIMARY KEY (rel_prof_nusp, rel_dis_code, rel_al_nusp),
	CONSTRAINT fk_prof_nusp FOREIGN KEY (rel_prof_nusp)
		REFERENCES b02_Professor(prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis_code FOREIGN KEY (rel_dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_al_nusp FOREIGN KEY (rel_al_nusp)
		REFERENCES b03_Aluno(al_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE b23_of_times (
	prof_nusp varchar(9) NOT NULL,
	dis_code varchar(7) NOT NULL,
	time_in TIME NOT NULL,
	time_out TIME NOT NULL,
	day integer,
	CONSTRAINT pk_of_times PRIMARY KEY (prof_nusp, dis_code, time_in, day),
	CONSTRAINT fk_prof FOREIGN KEY (prof_nusp)
		REFERENCES b02_Professor(prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_dis FOREIGN KEY (dis_code)
		REFERENCES b05_Disciplina(dis_code)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);
