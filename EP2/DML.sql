/* Pessoa */
INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('1','Jão1');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('2','Jão2');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('3','Jão3');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('4','Jão4');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('5','Jão5');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('6','Jão6');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('7','Jão7');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('8','Jão8');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('9','Jão9');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('10','Jão10');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('11','Jão11');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('12','Jão12');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('13','Jão13');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('14','Jão14');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('15','Jão15');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('16','Mai16');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('17','Mai17');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('18','Mai18');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('19','Mai19');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('20','Mai20');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('21','Mai21');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('22','Mai22');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('23','Mai23');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('24','Mai24');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('25','Mai25');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('26','Mai26');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('27','Mai27');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('28','Mai28');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('29','Mai29');

INSERT INTO b01_Pessoa (pes_cpf, pes_name)
	VALUES ('30','Mai30');

/* Insercao em Professor */
INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('1', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão1'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('2', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão2'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('3', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão3'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('4', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão4'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('5', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão5'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('6', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão6'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('7', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão7'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('8', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão8'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('9', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão9'));

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('10', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão10'));

/* Insercao em Aluno */
INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('11', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão11'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('12', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão12'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('13', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão13'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('14', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão14'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('15', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão15'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('16', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai16'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('17', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai17'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('18', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai18'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('19', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai19'));

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('20', (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai20'));

/* Insercao em Administrador */
INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai21'), '21email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai22'), '22email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai23'), '23email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai24'), '24email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai25'), '25email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai26'), '26email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai27'), '27email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai28'), '28email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai29'), '29email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (adm_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai30'), '30email@gmail', '2008-01-01 00:00:01', '3008-01-01 00:00:01');

/* Disciplinas */
INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 0', 'MAC0100', 1, 1);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 1', 'MAC0101', 2, 2);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 2', 'MAC0102', 3, 3);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 3', 'MAC0103', 4, 4);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 4', 'MAC0104', 5, 5);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 5', 'MAC0105', 6, 6);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 6', 'MAC0106', 7, 7);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 7', 'MAC0107', 8, 8);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 8', 'MAC0108', 9, 9);

INSERT INTO b05_Disciplina (dis_name, dis_code, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 9', 'MAC0109', 10, 10);

/* Curso */
INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (0, 'Bacharelado Generico 0', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '21email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (1, 'Bacharelado Generico 1', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '22email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (2, 'Bacharelado Generico 2', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '23email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (3, 'Bacharelado Generico 3', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '24email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (4, 'Bacharelado Generico 4', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '25email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (5, 'Bacharelado Generico 5', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '26email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (6, 'Bacharelado Generico 6', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '27email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (7, 'Bacharelado Generico 7', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '28email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (8, 'Bacharelado Generico 8', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '29email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES (9, 'Bacharelado Generico 9', (SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '30email@gmail'), '2009-01-01 00:00:01', '2018-01-01 00:00:01');

/* Trilha */
INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 0');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 1');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 2');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 3');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 4');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 5');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 6');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 7');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 8');

INSERT INTO b07_Trilha (tr_name)
	VALUES ('Especializacao Generica 9');

/* Modulo */
INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (1, 'Modulo Legal 0', 2);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (2, 'Modulo Legal 1', 4);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (3, 'Modulo Legal 2', 6);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (4, 'Modulo Legal 3', 8);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (5, 'Modulo Legal 4', 10);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (6, 'Modulo Legal 5', 12);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (7, 'Modulo Legal 6', 14);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (8, 'Modulo Legal 7', 16);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (9, 'Modulo Legal 8', 18);

INSERT INTO b08_Modulo (mod_code, mod_name, mod_cred_min)
	VALUES (10, 'Modulo Legal 9', 20);

/* Usuario */
INSERT INTO users (us_email, us_password)
	VALUES ('1_user@gmail.com', crypt('123456780', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('2_user@gmail.com', crypt('123456781', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('3_user@gmail.com', crypt('123456782', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('4_user@gmail.com', crypt('123456783', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('5_user@gmail.com', crypt('123456784', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('6_user@gmail.com', crypt('123456785', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('7_user@gmail.com', crypt('123456786', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('8_user@gmail.com', crypt('123456787', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('9_user@gmail.com', crypt('123456788', gen_salt('bf')));

INSERT INTO users (us_email, us_password)
	VALUES ('10_user@gmail.com', crypt('123456789', gen_salt('bf')));

/* Perfil */
INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 1', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 2', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 3', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 4', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 5', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 6', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 7', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 8', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 9', 'Perfil usado por usuarios que inovam');

INSERT INTO b10_Perfil (perf_name, perf_desc)
	VALUES ('Perfil Inovador 10', 'Perfil usado por usuarios que inovam');

/* Servicos */
INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0000, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0001, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0002, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0003, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0004, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0005, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0006, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0007, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0008, 'Servico que permite tudo', true, true, true, true);

INSERT INTO b11_Servico (serv_code, serv_desc, serv_per_create, serv_per_read, serv_per_update, serv_per_delete)
	VALUES (0009, 'Servico que permite tudo', true, true, true, true);

/* rel trilha modulo */
INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 0', 1, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 1', 2, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 2', 3, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 3', 4, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 4', 5, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 5', 6, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 6', 7, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 7', 8, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 8', 9, true);

INSERT INTO b12_rel_tr_mod (rel_tr_name, rel_mod_code, rel_tr_mod_mandatory)
	VALUES ('Especializacao Generica 8', 10, false);

/* rel trilha curso */
INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 0', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 0'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 1', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 1'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 2', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 2'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 3', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 3'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 4', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 4'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 5', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 5'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 6', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 6'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 7', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 7'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 8', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 8'));

INSERT INTO b13_rel_tr_cur (rel_tr_name, rel_cur_code)
	VALUES ('Especializacao Generica 9', (SELECT cur_code FROM b06_Curso WHERE cur_name = 'Bacharelado Generico 9'));

/* rel user perfil*/
INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('1_user@gmail.com', 'Perfil Inovador 1', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('2_user@gmail.com', 'Perfil Inovador 2', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('3_user@gmail.com', 'Perfil Inovador 3', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('4_user@gmail.com', 'Perfil Inovador 4', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('5_user@gmail.com', 'Perfil Inovador 5', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('6_user@gmail.com', 'Perfil Inovador 6', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('7_user@gmail.com', 'Perfil Inovador 7', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('8_user@gmail.com', 'Perfil Inovador 8', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('9_user@gmail.com', 'Perfil Inovador 9', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b14_rel_us_pf (rel_us_email, rel_perf_name, rel_us_pf_date_in, rel_us_pf_date_out)
	VALUES ('9_user@gmail.com', 'Perfil Inovador 10', '2018-01-01 00:00:01', '2020-01-01 00:00:01');

/* rel perfil servico */
INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 1', 0000);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 2', 0001);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 3', 0002);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 4', 0003);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 5', 0004);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 6', 0005);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 7', 0006);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 8', 0007);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 9', 0008);

INSERT INTO  b15_rel_pf_se (rel_perf_name, rel_serv_code)
	VALUES ('Perfil Inovador 10', 0009);

/* rel prof disciplina */
INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('1', 'MAC0100', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('2', 'MAC0101', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('3', 'MAC0102', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('4', 'MAC0103', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('5', 'MAC0104', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('6', 'MAC0105', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('7', 'MAC0106', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('8', 'MAC0107', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('9', 'MAC0108', 1, 2019);

INSERT INTO  b16_rel_prof_dis (rel_prof_nusp, rel_dis_code, rel_prof_disc_semester, rel_prof_disc_year)
	VALUES ('10', 'MAC0109', 1, 2019);

/* rel aluno disc */
INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('11', 'MAC0100', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('12', 'MAC0101', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('13', 'MAC0102', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('14', 'MAC0103', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('15', 'MAC0104', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('16', 'MAC0105', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('17', 'MAC0106', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('18', 'MAC0107', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('19', 'MAC0108', 1, 2019);

INSERT INTO  b17_rel_al_dis (rel_al_nusp, rel_dis_code, plan_semester, plan_year)
	VALUES ('20', 'MAC0109', 1, 2019);

/* rel modulo disciplina */
INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0100', 1);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0101', 2);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0102', 3);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0103', 4);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0104', 5);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0105', 6);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0106', 7);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0107', 8);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0108', 9);

INSERT INTO  b18_rel_dis_mod (rel_dis_code, rel_mod_code)
	VALUES ('MAC0109', 10);

/* rel modulo curso */
INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (1, 1);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (2, 2);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (3, 3);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (4, 4);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (5, 5);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (6, 6);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (7, 7);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (8, 8);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (9, 9);

INSERT INTO  b19_rel_mod_cur (rel_mod_code, rel_cur_code)
	VALUES (10, 0);

/* rel pessoa usuario */
INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão1'), '1_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão2'), '2_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão3'), '3_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão4'), '4_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão5'), '5_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão6'), '6_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão7'), '7_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão8'), '8_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão9'), '9_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

INSERT INTO  b20_rel_pes_us (rel_pes_cpf, rel_us_email, rel_pes_us_date_in, rel_pes_us_date_out)
	VALUES ((SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão10'), '10_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');

/* Oferecimento */
INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('1', 'MAC0100', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('2', 'MAC0101', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('3', 'MAC0102', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('4', 'MAC0103', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('5', 'MAC0104', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('6', 'MAC0105', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('7', 'MAC0106', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('8', 'MAC0107', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('9', 'MAC0108', 2019, 1, 45);

INSERT INTO  b21_Oferecimento (rel_prof_nusp, rel_dis_code, rel_rel_oferecimento_year, rel_oferecimento_semester, rel_oferecimento_class)
	VALUES ('10', 'MAC0109', 2019, 1, 45);

/* rel aluno oferecimento */
INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('1', 'MAC0100', '11', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('2', 'MAC0101', '12', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('3', 'MAC0102', '13', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('4', 'MAC0103', '14', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('5', 'MAC0104', '15', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('6', 'MAC0105', '16', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('7', 'MAC0106', '17', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('8', 'MAC0107', '18', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('9', 'MAC0108', '19', 0.0, 0.0);

INSERT INTO  b22_rel_al_of (rel_prof_nusp, rel_dis_code, rel_al_nusp, rel_al_of_grade, rel_al_of_presence)
	VALUES ('10', 'MAC0109', '20', 0.0, 0.0);

/* tabelas de serviços */
INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0000, 'b02_Professor');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0001, 'b02_Professor');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0002, 'b02_Professor');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0003, 'b02_Professor');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0004, 'b03_Aluno');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0005, 'b03_Aluno');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0006, 'b03_Aluno');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0007, 'b04_Administrador');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0008, 'b04_Administrador');

INSERT INTO  b23_serv_tables (serv_code, serv_table)
	VALUES (0009, 'b04_Administrador');

/* horarios do oferecimento */
INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('1', 'MAC0100', '01:02:03', '05:02:03', 2);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('2', 'MAC0101', '01:02:03', '05:02:03', 3);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('3', 'MAC0102', '01:02:03', '05:02:03', 4);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('4', 'MAC0103', '01:02:03', '05:02:03', 5);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('5', 'MAC0104', '01:02:03', '05:02:03', 6);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('6', 'MAC0105', '01:02:03', '05:02:03', 7);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('7', 'MAC0106', '01:02:03', '05:02:03', 1);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('8', 'MAC0107', '01:02:03', '05:02:03', 2);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('9', 'MAC0108', '01:02:03', '05:02:03', 3);

INSERT INTO  b24_of_times (prof_nusp, dis_code, time_in, time_out, day)
	VALUES ('10', 'MAC0109', '01:02:03', '05:02:03', 4);