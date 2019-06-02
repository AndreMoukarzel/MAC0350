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

UPDATE

select * from update_Pessoa_cpf('98179721000', '98179721001')
select * from update_Pessoa_name('98179721001', 'Jose')
select * from update_Professor_nusp('1', '2')
select * from update_Professor_cpf('2', '12345678912')
select * from update_Aluno_nusp('11', '111')
select * from update_Aluno_cpf('111', '12345678913')
select * from update_Administrador_cpf('21email@gmail.com', '19876432119')
select * from update_Administrador_email('21email@gmail.com', '22email@gmail.com')
select * from update_Administrador_dat_in('22email@gmail.com', '2008-01-01 00:00:02')
select * from update_Administrador_dat_out('22email@gmail.com', '2008-01-01 00:00:03')
select * from update_Disciplina_code('MAC0100', 'MAC0101')
select * from update_Disciplina_name('MAC0101', 'Disciplina 00')
select * from update_Disciplina_class_creds('MAC0101', 3)
select * from update_Disciplina_work_creds('MAC0101', 3)
select * from update_Curso_code(0, 1)
select * from update_Curso_name(1, 'Bacharelado Generico 00')
select * from update_Curso_adm(1, '98179721001')
select * from update_Trilha_name('Especializacao Generica 0', 'Especializacao Generica 00')
select * from update_Modulo_code(1, 2)
select * from update_Modulo_name(2, 'Modulo Legal 00')
select * from update_Modulo_cred_min(2, 4)
select * from update_users_email('1_user@gmail.com', '01_user@gmail.com')
select * from update_users_password('01_user@gmail.com', crypt('123456782', gen_salt('bf')))
select * from update_Perfil_name('Perfil Inovador 1', 'Perfil Inovador 01')
select * from update_Perfil_description('Perfil Inovador 01', 'Perfil usado por usuarios que tambem inovam')
select * from update_Servico_code(0001,0002)
select * from update_Servico_name(0002, 'create_Aluno()')
select * from update_Servico_desc(0003, 'Cria um novo aluno')
select * from update_rel_Trilha_Modulo_tr_name('Especializacao Generica 0', 1, 'Especializacao Generica 00')
select * from update_rel_Trilha_Modulo_mod_code('Especializacao Generica 00', 1, 2)
select * from update_rel_Trilha_Modulo_mandatory('Especializacao Generica 00', 2, false)
select * from update_rel_Trilha_Curso_name('Especializacao Generica 0', 0, 'Especializacao Generica 00') 
select * from update_rel_Trilha_Curso_code('Especializacao Generica 00', 0, 1)
select * from update_rel_Usuario_Perfil_email('1_user@gmail.com', 'Perfil Inovador 1', '01_user@gmail.com')
select * from update_rel_Usuario_Perfil_name('01_user@gmail.com', 'Perfil Inovador 1', 'Perfil Inovador 01')
select * from update_rel_Usuario_Perfil_date_in('01_user@gmail.com', 'Perfil Inovador 01', '2018-01-01 00:00:02')
select * from update_rel_Usuario_Perfil_date_out('01_user@gmail.com', 'Perfil Inovador 01', '2020-01-01 00:00:02')
select * from update_rel_Perfil_Servico_name('Perfil Inovador 1', 0001, 'Perfil Inovador 01')
select * from update_rel_Perfil_Servico_code('Perfil Inovador 01', 0001, 0002)
select * from update_rel_Professor_Disciplina_prof_nusp('1', 'MAC0100', '01')
select * from update_rel_Professor_Disciplina_dis_code('01', 'MAC0100', 'MAC0101')
select * from update_rel_Professor_Disciplina_prof_disc_semester('01', 'MAC0101', 2)
select * from update_rel_Professor_Disciplina_prof_disc_year('01', 'MAC0101', 2020)
select * from update_rel_Aluno_Disciplina_al_nusp('11', 'MAC0100', '12')
select * from update_rel_Aluno_Disciplina_dis_code('12', 'MAC0100', 'MAC0101')
select * from update_rel_Aluno_Disciplina_plan_semester('12', 'MAC0101', 2)
select * from update_rel_Aluno_Disciplina_plan_year('12', 'MAC0101', 2020)
select * from update_rel_Disciplina_Modulo_dis_code('MAC0100', 1, 'MAC0101')
select * from update_rel_Disciplina_Modulo_dis_code('MAC0101', 1, 2)
select * from update_rel_Modulo_Curso_mod_code(1, 1, 2)
select * from update_rel_Modulo_Curso_cur_code(2, 1, 2)
select * from update_rel_Pessoa_Usuario_pes_cpf('98179721000', '1_user@gmail.com', '98179721001')
select * from update_rel_Pessoa_Usuario_us_email('98179721001', '1_user@gmail.com', '01_user@gmail.com')
select * from update_rel_Pessoa_Usuario_date_in('98179721001', '01_user@gmail.com', '2010-01-01 00:00:02')
select * from update_rel_Pessoa_Usuario_date_out('98179721001','01_user@gmail.com', '2020-01-01 00:00:02')
select * from update_Oferecimento_prof_nusp('1', 'MAC0100', 2019, 1, '01')
select * from update_Oferecimento_dis_code('01', 'MAC0100', 2019, 1, 'MAC0101')
select * from update_Oferecimento_year('01', 'MAC0101', 2019, 1, 2020)
select * from update_Oferecimento_semester('01', 'MAC0101', 2020, 1, 2)
select * from update_Oferecimento_class('01', 'MAC0101', 2020, 2,  46)
select * from update_Aluno_Oferecimento_prof_nusp('1', 'MAC0100', '11', '01')
select * from update_Aluno_Oferecimento_dis_code('01', 'MAC0100', '11', 'MAC0101')
select * from update_Aluno_Oferecimento_al_nusp('01', 'MAC0101', '11', '12')
select * from update_Aluno_Oferecimento_grade('01', 'MAC0101', '12', 10.0)
select * from update_Aluno_Oferecimento_attendance('01', 'MAC0101','12', 0.7)
select * from update_Oferecimento_Times_prof_nusp('1', 'MAC0100', '01:02:03', 2, '01')
select * from update_Oferecimento_Times_dis_code('01', 'MAC0100', '01:02:03', 2, 'MAC0101')
select * from update_Oferecimento_Times_time_in('01', 'MAC0101', '01:02:03', 2, '01:02:04')
select * from update_Oferecimento_Times_time_out('01', 'MAC0101', '01:02:04', 2, '05:02:03')
select * from update_Oferecimento_Times_day('01', 'MAC0101', '01:02:04', 2, 3)
select * from update_Disciplina_Disciplina_dis_code('MAC0102', 'MAC0100', 'MAC0103')
select * from update_Disciplina_Disciplina_dis_req_code('MAC0103','MAC0100', 'MAC0101')

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