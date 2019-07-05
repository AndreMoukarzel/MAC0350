André Ferrari Moukarzel, NUSP 9298166
Arthur Vieira Barbosa, NUSP 6482041
Matheus Lima Cunha, NUSP 10297755
Gabriel Sarti Massukado, NUSP 10284177



/***************************** REQUERIMENTOS *****************************/

	É necessário ter os pacotes 
		sqlalchemy 
		e 
		flask_sqlalchemy 
	instalados.

	Também é necessário ter direitos de superuser no psql antes da
  execução do programa.


 /******************************* EXECUÇÃO *******************************/

	Para a execução da API, rode os seguintes comandos na linha de comando
enquanto na pasta raíz do projeto:
	0) psql
	1) CREATE DATABASE pessoas;
	2) \c pessoas
	3) \i MODULE_PEOPLE.sql
	4) CREATE DATABASE access;
	5) \c access
	6) \i MODULE_ACCESS.sql
	7) python3 api/app.py