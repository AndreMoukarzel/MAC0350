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

@app.route("/")
def index():
	email = session.get('user_id')
	if email is None:
		return redirect(url_for('login'))

	name = db_operations.get_name_from_email(email)
	results = db_operations.get_servs_from_email(email)

	return render_template('index.html', name=name, servs=results)

@app.route("/login", methods=('GET', 'POST'))
def login():
	error = None

	if request.method == 'POST':
		email = request.form['email']
		password = request.form['password']

		data = db_operations.check_login(email, password)

		if data is None:
			error = 'Incorrect username/password.'

		if error is None:
			session.clear()
			session['user_id'] = email
			return redirect(url_for('index'))

	return render_template('login.html', error=error)

@app.route("/logout")
def logout():
	if session.get('user_id') is not None:
		session.clear()

	return redirect(url_for('index'))


@app.route("/add_p")
def add_p():
	name=request.args.get('name')
	cpf=request.args.get('cpf')

	if name == '' or cpf == '':
		return "Parametros de inserção invalidos. <br> <a href=\"/\"> Voltar </a>"

	return db_operations.add_p(name, cpf)

@app.route("/getall_p")
def getall_p():
	results = db_operations.get_all_p()

	if type(results) == str:
		return results + "<br> <a href=\"/\"> Voltar </a>"

	return render_template('Pessoa/getall_p.html', results=results)

@app.route("/update_p", methods=('GET', 'POST'))
def update_p():
	email = session.get('user_id')
	if email is None:
		return redirect(url_for('login'))

	servs = db_operations.get_servs_from_email(email)

	if type(servs) == str:
			return servs + "<br> <a href=\"/\"> Voltar </a>"

	if not 1 in servs:
		return redirect(url_for('index')) 

	pes_id = request.args.get('id')
	if pes_id is None:
		return "No ID Specified <br> <a href=\"/\"> Voltar </a>"

	if request.method == 'POST':
		name = request.form['name']
		cpf= request.form['cpf']

		result = db_operations.update_p(pes_id, name, cpf)

		if type(result) == str:
			return result + "<br> <a href=\"/\"> Voltar </a>"

		return redirect(url_for('getall_p'))

	else:
		pes_info = db_operations.get_p(pes_id)

		if type(pes_info) == str:
			return pes_info + "<br> <a href=\"/\"> Voltar </a>"

		return render_template('Pessoa/update_p.html', info=pes_info)


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