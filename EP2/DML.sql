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
	VALUES ('1', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão1');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('2', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão2');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('3', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão3');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('4', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão4');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('5', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão5');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('6', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão6');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('7', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão7');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('8', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão8');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('9', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão9');

INSERT INTO b02_Professor (prof_nusp, prof_cpf)
	VALUES ('10', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão10');

/* Insercao em Aluno */
INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('11', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão11');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('12', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão12');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('13', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão13');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('14', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão14');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('15', SELECT id FROM b01_Pessoa WHERE pes_name = 'Jão15');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('16', SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai16');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('17', SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai17');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('18', SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai18');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('19', SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai19');

INSERT INTO b03_Aluno (al_nusp, al_cpf)
	VALUES ('20', SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai20');

/* Insercao em Administrador */
INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai21', "21email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai22', "22email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai23', "23email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai24', "24email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai25', "25email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai26', "26email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai27', "27email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai28', "28email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai29', "29email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');

INSERT INTO b04_Administrador (al_cpf, adm_email, adm_dat_in, adm_dat_out)
	VALUES (SELECT id FROM b01_Pessoa WHERE pes_name = 'Mai30', "30email@gmail", '2008-01-01 00:00:01', '3008-01-01 00:00:01');