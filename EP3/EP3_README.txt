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
	2) python3 api/app.py