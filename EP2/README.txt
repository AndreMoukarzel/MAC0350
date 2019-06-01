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