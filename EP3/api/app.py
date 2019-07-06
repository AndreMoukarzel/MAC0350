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

@app.route("/add_curso")
def add_curso():
	block = check_permission(3)

	if block is not None:
		return block

	#request.args pega args do url: /algo?name=coisa
	code=request.args.get('code')
	name=request.args.get('name')
	cpf=request.args.get('cpf')
	timein=request.args.get('timein')
	timeout=request.args.get('timeout')

	if code == '' or cpf == '':
		return "Parametros de inserção invalidos. <br> <a href=\"/\"> Voltar </a>"

	return db_operations.add_curso(code, name, cpf, timein, timeout)

@app.route("/getall_curso")
def getall_curso():
	block = check_permission(3)

	if block is not None:
		return block

	results = db_operations.get_all_curso()

	#No caso, se a função retornar uma string,
	#é uma mensagem de erro
	if type(results) == str:
		return results + "<br> <a href=\"/\"> Voltar </a>"

	return render_template('Curso/getall_curso.html', results=results)

@app.route("/update_curso", methods=('GET', 'POST'))
def update_curso():
	block = check_permission(3)

	if block is not None:
		return block

	cur_id = request.args.get('id')
	if cur_id is None:
		return "No ID Specified <br> <a href=\"/\"> Voltar </a>"

	#Se a pessoa preencheu o formulario, atualize
	if request.method == 'POST':
		code = request.form['code']
		name = request.form['name']
		cpf = request.form['cpf']
		date_in = request.form['datein']
		date_out = request.form['dateout']

		result = db_operations.update_curso(cur_id, code, name, cpf, date_in, date_out)

		if type(result) == str:
			return result + "<br> <a href=\"/\"> Voltar </a>"

		return redirect(url_for('getall_curso'))

	#Se não, só preencha e espere modificações
	else:
		cur_info = db_operations.get_curso(cur_id)

		if type(cur_info) == str:
			return cur_info + "<br> <a href=\"/\"> Voltar </a>"

		cur_info = list(cur_info)
		#Datatime em html é YYYY-MM-DDTHH:MM:SS
		cur_info[4] = str(cur_info[4]).replace(" ","T")
		cur_info[5] = str(cur_info[5]).replace(" ","T")
		print(cur_info[4])

		return render_template('Curso/update_curso.html', info=cur_info)

@app.route("/delete_curso")
def delete_curso():
	block = check_permission(3)

	if block is not None:
		return block

	cur_code = request.args.get('code')
	if cur_code is None:
		return "No ID Specified <br> <a href=\"/\"> Voltar </a>"

	result = db_operations.delete_curso(cur_code)

	return result

@app.route("/add_rel_pes_us")
def add_rel_pes_us():
	block = check_permission(5)

	if block is not None:
		return block

	#request.args pega args do url: /algo?name=coisa
	cpf=request.args.get('cpf')
	email=request.args.get('email')
	date_in=request.args.get('datein')
	date_out=request.args.get('dateout')

	if cpf == '' or email == '' or date_in == '':
		return "Parametros de inserção invalidos. <br> <a href=\"/\"> Voltar </a>"

	return db_operations.add_rel_pes_us(cpf, email, date_in, date_out)

@app.route("/getall_rel_pes_us")
def getall_rel_pes_us():
	block = check_permission(5)

	if block is not None:
		return block

	results = db_operations.get_all_rel_pes_us()

	#No caso, se a função retornar uma string,
	#é uma mensagem de erro
	if type(results) == str:
		return results + "<br> <a href=\"/\"> Voltar </a>"

	return render_template('Rel/getall_rel_pes_us.html', results=results)

@app.route("/update_rel_pes_us", methods=('GET', 'POST'))
def update_rel_pes_us():
	block = check_permission(5)

	if block is not None:
		return block

	rel_id = request.args.get('id')
	if pes_id is None:
		return "No ID Specified <br> <a href=\"/\"> Voltar </a>"

	#Se a pessoa preencheu o formulario, atualize
	if request.method == 'POST':
		cpf= request.form['cpf']
		email = request.form['email']
		date_in = request.form['datein']
		date_out = request.form['dateout']

		result = db_operations.update_rel_pes_us(rel_id, cpf, email, date_in, date_out)

		if type(result) == str:
			return result + "<br> <a href=\"/\"> Voltar </a>"

		return redirect(url_for('getall_rel_pes_us'))

	#Se não, só preencha e espere modificações
	else:
		rel_info = db_operations.get_p(rel_id)

		if type(rel_info) == str:
			return rel_info + "<br> <a href=\"/\"> Voltar </a>"

		return render_template('Rel/update_rel_pes_us.html', info=rel_info)

@app.route("/delete_rel_pes_us")
def delete_rel_pes_us():
	block = check_permission(5)

	if block is not None:
		return block

	cpf=request.args.get('cpf')
	email=request.args.get('email')
	date_in=request.args.get('datein')
	date_out=request.args.get('dateout')
	if cpf is None:
		return "No ID Specified <br> <a href=\"/\"> Voltar </a>"

	result = db_operations.delete_rel_pes_us(cpf)

	return result

if __name__ == '__main__':
	app.run()