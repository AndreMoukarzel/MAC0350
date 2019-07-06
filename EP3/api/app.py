import config
import db_operations
from models import *
from flask import Flask, request, redirect, render_template, session, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func

app = Flask(__name__)

app.config.from_object(config.DevelopmentConfig)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

#app.route diz que função deve ser chamada
#quando entramos nessa url no servidor
@app.route("/")
def index():
	#session é um hash global
	email = session.get('user_id')
	if email is None:
		#url_for(algo) da um url para a ação algo
		return redirect(url_for('login'))

	name = db_operations.get_name_from_email(email)

	if name is None:
		error = "User not associated with any Person. Ask the Admin to fix this."
		session.clear()
		return error + "<br> <a href=\"/\"> Voltar </a>"

	results = db_operations.get_servs_from_email(email)

	#Render_Template pega um html da pasta templates
	#os outros args servem para preencher as coisas dentro do html 
	return render_template('index.html', name=name, servs=results)

@app.route("/login", methods=('GET', 'POST'))
def login():
	error = None

	#POST é chamado quando mandamos o form de login
	if request.method == 'POST':
		email = request.form['email']
		password = request.form['password']

		data = db_operations.check_login(email, password)

		if data is None:
			error = 'Incorrect username/password.'

		if error is None:
			#clear limpa a session (garantia)
			session.clear()
			#É um hash, lembra?
			session['user_id'] = email
			return redirect(url_for('index'))

	return render_template('login.html', error=error)

@app.route("/logout")
def logout():
	if session.get('user_id') is not None:
		session.clear()

	return redirect(url_for('index'))

#Verifica se a pessoa tem permissão para acessar a pagina em questão
def check_permission(serv_num):
	#verifica se está logada
	email = session.get('user_id')
	if email is None:
		return redirect(url_for('login'))

	servs = db_operations.get_servs_from_email(email)

	if type(servs) == str:
			return servs + "<br> <a href=\"/\"> Voltar </a>"

	#se tem o serviço associado
	if not serv_num in servs:
		return redirect(url_for('index'))

	return None

@app.route("/add_p")
def add_p():
	block = check_permission(1)

	if block is not None:
		return block

	#request.args pega args do url: /algo?name=coisa
	name=request.args.get('name')
	cpf=request.args.get('cpf')

	if name == '' or cpf == '':
		return "Parametros de inserção invalidos. <br> <a href=\"/\"> Voltar </a>"

	return db_operations.add_p(name, cpf)

@app.route("/getall_p")
def getall_p():
	block = check_permission(1)

	if block is not None:
		return block

	results = db_operations.get_all_p()

	#No caso, se a função retornar uma string,
	#é uma mensagem de erro
	if type(results) == str:
		return results + "<br> <a href=\"/\"> Voltar </a>"

	return render_template('Pessoa/getall_p.html', results=results)

@app.route("/update_p", methods=('GET', 'POST'))
def update_p():
	block = check_permission(1)

	if block is not None:
		return block

	pes_id = request.args.get('id')
	if pes_id is None:
		return "No ID Specified <br> <a href=\"/\"> Voltar </a>"

	#Se a pessoa preencheu o formulario, atualize
	if request.method == 'POST':
		name = request.form['name']
		cpf= request.form['cpf']

		result = db_operations.update_p(pes_id, name, cpf)

		if type(result) == str:
			return result + "<br> <a href=\"/\"> Voltar </a>"

		return redirect(url_for('getall_p'))

	#Se não, só preencha e espere modificações
	else:
		pes_info = db_operations.get_p(pes_id)

		if type(pes_info) == str:
			return pes_info + "<br> <a href=\"/\"> Voltar </a>"

		return render_template('Pessoa/update_p.html', info=pes_info)

@app.route("/delete_p")
def delete_p():
	block = check_permission(1)

	if block is not None:
		return block

	pes_cpf = request.args.get('cpf')
	if pes_cpf is None:
		return "No ID Specified <br> <a href=\"/\"> Voltar </a>"

	result = db_operations.delete_p(pes_cpf)

	return result

@app.route("/work_profs")
def work_profs():
	semestre=request.args.get('semestre')
	ano=request.args.get('ano')

	if semestre == '' or ano == '':
		return "Parametros de pesquisa invalidos. <br> <a href=\"/\"> Voltar </a>"

	results = db_operations.work_profs(semestre, ano)

	if type(results) == str:
		return results + "<br> <a href=\"/\"> Voltar </a>"

	return render_template('work_profs.html', results=results)

if __name__ == '__main__':
	app.run()