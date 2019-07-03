import config
from models import *
from flask import Flask, request, redirect, render_template, session, url_for
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

	data = db.session.query(func.public.get_servs_from_email(email))

	results = []
	for serv in data:
		for row in serv:
			results.append(row)

	return render_template('index.html', email=email, servs=results)

@app.route("/login", methods=('GET', 'POST'))
def login():
	if request.method == 'POST':
		email = request.form['email']
		password = request.form['password']
		error = None
		data = db.session.query(func.public.check_login(email, password)).first()

		if data is None:
			error = 'Incorrect username/password.'

		if error is None:
			session.clear()
			session['user_id'] = email
			return redirect(url_for('index'))

		flash(error)

	return render_template('login.html')

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

	try:
		data = db.session.query(func.public.create_Pessoa(cpf, name)).first()
		db.session.commit()
		return "Pessoa criada com id = {}. <br> <a href=\"/\"> Voltar </a>".format(data[0])
	except Exception as e:
		db.session.rollback()
		return(str(e))

@app.route("/getall_p")
def get_all():
	try:
		data = B01Pessoa.query.all()
		results = [] 
		for entry in data:
			results.append((entry.pes_id, entry.pes_name, entry.pes_cpf))

		return render_template('getall_p.html', results=results)
	except Exception as e:
		return(str(e))

@app.route("/work_profs")
def work_profs():
	semestre=request.args.get('semestre')
	ano=request.args.get('ano')

	if semestre == '' or ano == '':
		return "Parametros de pesquisa invalidos. <br> <a href=\"/\"> Voltar </a>"

	try:
		data = db.session.query(func.public.working_profs(semestre, ano))

		results = [] 
		for entry in data:
			for info in entry:
				results.append(info[1:len(info)-1].split(','))

		return render_template('work_profs.html', results=results)

	except Exception as e:
		return(str(e))

if __name__ == '__main__':
	app.run()