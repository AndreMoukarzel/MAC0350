André Ferrari Moukarzel, NUSP 9298166
Arthur Vieira Barbosa, NUSP 6482041
Matheus Lima Cunha, NUSP 10297755
Gabriel Sarti Massukado, NUSP 10284177



/***************************** REQUERIMENTOS *****************************/

	É necessário ter os seguintes pacotes instalados:
		sqlalchemy 
		flask_sqlalchemy
		psycopg2 (necessário ter libpq-dev e python3-dev para instalar)

	Também é necessário ter direitos de superuser no psql antes da
  execução do programa.


/******************************* EXECUÇÃO *******************************/

	Para a execução da API, rode os seguintes comandos na linha de comando
enquanto na pasta raíz do projeto:
	0) psql
	1) \i CREATE_ALL.sql
	2) \q

 
Atenção: o arquivo CREATE_ALL irá criar e popular as databases com o nome pessoas, access, curriculum,
inter_acc_peo e inter_peo_cur. Caso existe alguma database com esses nomes, o programa pode não funcionar.

/******************************* TESTANDO *******************************/

	1) python3 api/app.py
	2) Abra um browser de internet no endereço localhost:5000
	3) Faça login com um dos usuários disponíveis

Usuarios:
admin@gmail.com, senha admin: possui acesso a todos os serviços
webmaster@gmail.com, senha web: possui acesso a relação de professor e disciplina, como também perfis.
aluno@gmail.com, senha aluno: possui acesso aos oferecimentos em determinado ano e semestre.

/******************************* LIMPANDO *******************************/

	0) psql
	1) \i DELETE_ALL.sql
	2) \q

Atenção: Para o DELETE_ALL funcionar, você não pode estar conectado em uma database criada pelo CREATE_ALL.sql
	