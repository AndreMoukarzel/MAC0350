import config
from models import *
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func

app = Flask(__name__)

app.config.from_object(config.DevelopmentConfig)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

def get_servs_from_email(email):
	assert(email is not None)
	db.session.bind = db.get_engine(app, 'access')
	data = db.session.query(func.public.get_servs_from_email(email))

	results = []
	for serv in data:
		for row in serv:
			results.append(row)

	return results

def check_login(email, password):
	assert(email is not None)
	assert(password is not None)

	db.session.bind = db.get_engine(app, 'access')
	data = db.session.query(func.public.check_login(email, password)).first()

	return data

def add_p(name, cpf):
	assert(name is not None)
	assert(cpf is not None)

	try:
		db.session.bind = db.get_engine(app, 'pessoas')
		data = db.session.query(func.public.create_Pessoa(cpf, name)).first()
		db.session.commit()
		return "Pessoa criada com id = {}. <br> <a href=\"/\"> Voltar </a>".format(data[0])

	except Exception as e:
		db.session.rollback()
		return(str(e)+" <br> <a href=\"/\"> Voltar </a>")

def get_all_p():
	try:
		data = B01Pessoa.query.all()
		results = [] 
		for entry in data:
			results.append((entry.pes_id, entry.pes_name, entry.pes_cpf))

		return results

	except Exception as e:
		return(str(e))

def work_profs(semestre, ano):
	assert(semestre is not None)
	assert(ano is not None)

	try:
		#db.session.bind = db.get_engine(app, 'rel_pessoas_curriculo')
		data = db.session.query(func.public.working_profs(semestre, ano))

		results = [] 
		for entry in data:
			for info in entry:
				results.append(info[1:len(info)-1].split(','))

		return results

	except Exception as e:
		return(str(e))

if __name__ == '__main__':
	app.run()