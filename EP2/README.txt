André Ferrari Moukarzel, NUSP 9298166
Arthur Vieira Barbosa, NUSP 6482041
Matheus Lima Cunha, NUSP 10297755
Gabriel Sarti Massukado, NUSP 10284177

####### EXEMPLOS DE CHAMADAS DE FUNÇÕES #######

CREATE

select * from create_Pessoa('98179721000', 'João');
select * from create_Professor('1', '98179721000');
select * from create_Aluno('11', '98179721000');
select * from create_Administrador('98179721000', '21email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');
select * from create_new_Professor('98179721000', 'João', '1');
select * from create_new_Aluno('98179721000', 'João', '11');
select * from create_new_Administrador('98179721000', 'João', '21email@gmail.com', '2008-01-01 00:00:01', '3008-01-01 00:00:01');
select * from create_Disciplina('Disciplina 0', 'MAC0100', 1, 1);
select * from create_Curso(0, 'Bacharelado Generico 0', '98179721000', '2009-01-01 00:00:01', '2018-01-01 00:00:01');
select * from create_Trilha('Especializacao Generica 0');
select * from create_Modulo(1, 'Modulo Legal 0', 2);
select * from create_users('1_user@gmail.com', crypt('123456780', gen_salt('bf')));
select * from create_Perfil('Perfil Inovador 1', 'Perfil usado por usuarios que inovam');
select * from create_Servico(0001, 'create_Pessoa()', 'cria uma pessoa');
select * from create_rel_tr_mod('Especializacao Generica 0', 1, true);
select * from create_rel_tr_cur('Especializacao Generica 0', 0);
select * from create_rel_us_pf('1_user@gmail.com', 'Perfil Inovador 1', '2018-01-01 00:00:01', '2020-01-01 00:00:01');
select * from create_rel_pf_se('Perfil Inovador 1', 0001);
select * from create_rel_prof_dis('1', 'MAC0100', 1, 2019);
select * from create_rel_al_dis('11', 'MAC0100', 1, 2019);
select * from create_rel_dis_mod('MAC0100', 1);
select * from create_rel_mod_cur(1, 1);
select * from create_rel_pes_us('98179721000', '1_user@gmail.com', '2010-01-01 00:00:01', '2020-01-01 00:00:01');
select * from create_Oferecimento('1', 'MAC0100', 2019, 1, 45);
select * from create_rel_al_of('1', 'MAC0100', '11', 2019, 1, 0.0, 0.0);
select * from create_of_times('1', 'MAC0100', 2019, 1, '01:02:03', '05:02:03', 2);
select * from create_rel_dis_dis('MAC0102', 'MAC0100');

RETRIEVE

select * from working_profs(1, 2019);
select * from assigned_students('1', 'MAC0100', 1, 2019);
select * from aluno_grade('11', '1', 'MAC0100', 1, 2019);
select * from aluno_attendance('11', '1', 'MAC0100', 1, 2019);
select * from aluno_aproved('11', '1', 'MAC0100', 1, 2019);
select * from aproved_students('4', 'MAC0103', 1, 2019, 5.0);
select * from check_trilhas('11');
select * from check_disc('11', 'MAC0102');
select * from get_servs('Perfil Inovador 1');
select * from get_perfs('1_user@gmail.com');
select * from get_user('1');
select * from get_pes('1_user@gmail.com');
select * from get_perfs(1);
select * from get_users('Perfil Inovador 1');
select * from get_admin(1);
select * from get_Curso('21');
select * from get_Oferecimentos('11', 2019, 1);
select * from get_Disciplinas('11', 2019, 1);
select * from get_Curso_from_Trilha('Especializacao Generica 0');
select * from get_Trilha(1);
select * from get_Trilha_from_modulo(1);
select * from get_Modulo('Especializacao Generica 0');
select * from get_Modulos_from_Curso(1);
select * from get_Cursos_with_Modulo(1);
select * from get_requisitos('MAC0102');
select * from get_Disciplina(1);
select * from get_Modulo_Disciplina('MAC0102');
select * from select_b01_pes_name('1');
select * from select_b02_prof_cpf('1');
select * from select_b03_al_cpf('11');
select * from select_b04_adm_email('21');
select * from select_b04_adm_dat_in('21');
select * from select_b04_adm_dat_out('21');
select * from select_b05_dis_name('MAC0102');
select * from select_b05_dis_class_creds('MAC0102');
select * from select_b05_dis_work_creds('MAC0102');
select * from select_b06_cur_name(1);
select * from select_b06_adm_cpf(1);
select * from select_b06_ad_cur_date_in(1);
select * from select_b06_ad_cur_date_out(1);
select * from select_b08_mod_name(1);
select * from select_b08_mod_cred_min(1);
select * from select_b10_perf_desc('Perfil Inovador 1');
select * from select_b11_serv_name(1);
select * from select_b11_serv_desc(1);
select * from select_b12_rel_tr_mod_mandatory('Especializacao Generica 0', 1);
select * from select_b14_rel_us_pf_date_in('1_user@gmail.com', 'Perfil Inovador 1');
select * from select_b14_rel_us_pf_date_out('1_user@gmail.com', 'Perfil Inovador 1');
select * from select_b16_rel_prof_disc_semester('1', 'MAC0100');
select * from select_b16_rel_prof_disc_year('1', 'MAC0100');
select * from select_b17_plan_semester('11', 'MAC0100');
select * from select_b17_plan_year('11', 'MAC0100');
select * from select_b20_rel_pes_us_date_in('1', '1_user@gmail.com');
select * from select_b20_rel_pes_us_date_out('1', '1_user@gmail.com');
select * from select_b21_rel_oferecimento_class('1', 'MAC0100', 2019, 1);
select * from select_b22_rel_al_of_grade('1', 'MAC0100', '11', 2019, 1);
select * from select_b22_rel_al_of_attendance('1', 'MAC0100', '11', 2019, 1);
select * from select_b23_time_out('1', 'MAC0100', 2019, 1, '01:02:03', 2);

DELETE

select * from delete_Pessoa('98179721000');
select * from delete_Professor('1');
select * from delete_Aluno('11');
select * from delete_Administrador('98179721000');
select * from delete_Disciplina('MAC0100');
select * from delete_Curso(0);
select * from delete_Trilha('Especializacao Generica 0');
select * from delete_Modulo(1);
select * from delete_user('1_user@gmail.com');
select * from delete_Perfil('Perfil Inovador 1');
select * from delete_Servico(0001);
select * from delete_tr_mod('Especializacao Generica 0', 1);
select * from delete_tr_cur('Especializacao Generica 0', 0);
select * from delete_us_pf('1_user@gmail.com', 'Perfil Inovador 1');
select * from delete_pf_se('Perfil Inovador 1', 0001);
select * from delete_prof_dis('1', 'MAC0100', 1, 2019);
select * from delete_al_dis('11', 'MAC0100', 1, 2019);
select * from delete_dis_mod('MAC0100', 1);
select * from delete_mod_cur(1, 1);
select * from delete_pes_us('98179721000', '1_user@gmail.com');
select * from delete_Oferecimento('1', 'MAC0100', 2019, 1);
select * from delete_al_of('1', 'MAC0100', '11');
select * from delete_of_times('1', 'MAC0100', 2019, 1, '01:02:03', 2);
select * from delete_dis_dis('MAC0102', 'MAC0100');