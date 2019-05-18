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
	VALUES ('1', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão1');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('2', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão2');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('3', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão3');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('4', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão4');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('5', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão5');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('6', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão6');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('7', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão7');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('8', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão8');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('9', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão9');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('10', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão10');

/* Insercao em Aluno */
INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('11', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão11');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('12', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão12');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('13', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão13');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('14', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão14');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('15', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Jão15');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('16', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai16');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('17', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai17');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('18', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai18');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('19', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai19');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('20', SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai20');

/* Insercao em Administrador */
INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai21', "21email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai22', "22email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai23', "23email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai24', "24email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai25', "25email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai26', "26email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai27', "27email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai28', "28email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai29', "29email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT pes_cpf FROM b01_Pessoa WHERE pes_name = 'Mai30', "30email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

/* Disciplinas */
INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 0', 'MAC0100', 1, 1);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 1', 'MAC0101', 2, 2);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 2', 'MAC0102', 3, 3);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 3', 'MAC0103', 4, 4);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 4', 'MAC0104', 5, 5);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 5', 'MAC0105', 6, 6);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 6', 'MAC0106', 7, 7);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 7', 'MAC0107', 8, 8);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 8', 'MAC0108', 9, 9);

INSERT INTO b05_Disciplina (dis_code, dis_name, dis_class_creds, dis_work_creds)
	VALUES ('Disciplina 9', 'MAC0109', 10, 10);

/* Curso */
INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('000', 'Bacharelado Generico 0', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '21email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('001', 'Bacharelado Generico 1', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '22email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('002', 'Bacharelado Generico 2', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '23email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('003', 'Bacharelado Generico 3', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '24email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('004', 'Bacharelado Generico 4', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '25email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('005', 'Bacharelado Generico 5', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '26email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('006', 'Bacharelado Generico 6', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '27email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('007', 'Bacharelado Generico 7', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '28email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('008', 'Bacharelado Generico 8', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '29email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

INSERT INTO b06_ Curso (cur_code, cur_name, adm_cpf, ad_cur_date_in, ad_cur_date_out)
	VALUES ('009', 'Bacharelado Generico 9', SELECT adm_cpf FROM b04_Administrador WHERE adm_email = '30email@gmail', '2009-01-01 00:00:01', '2018-01-01 00:00:01');

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
INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('1_user@gmail.com', '123456780');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('2_user@gmail.com', '123456781');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('3_user@gmail.com', '123456782');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('4_user@gmail.com', '123456783');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('5_user@gmail.com', '123456784');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('6_user@gmail.com', '123456785');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('7_user@gmail.com', '123456786');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('8_user@gmail.com', '123456787');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('9_user@gmail.com', '123456788');

INSERT INTO b09_Usuario (us_email, us_password)
	VALUES ('10_user@gmail.com', '123456789');

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