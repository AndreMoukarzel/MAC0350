import config
from models import *
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func

app = Flask(__name__)

app.config.from_object(config.DevelopmentConfig)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

def get_name_from_email(email):
	assert(email is not None)
	#A linha abaixo muda o database que estamos conectados
	#para 'acc_peo' (na verdade ele pega de um hash no config.py)
	db.session.bind = db.get_engine(app, 'acc_peo')
	#manda o database realizar a função get_pes (do database)
	#e pegar a primeira entrada (só deveria ter uma)
	data = db.session.query(func.public.get_pes(email)).first()

	if data is None:
		return None

	#Por algum motivo, funcs que retoram tables retorna 
	#uma string do tipo (valor1,valor2,valor3,...)
	#A linha abaixo tira os parenteses e separa pela virgula
	name = data[0][1:len(data[0])-1].split(',')[1]

	return name

def get_servs_from_email(email):
	assert(email is not None)
	db.session.bind = db.get_engine(app, 'access')
	data = db.session.query(func.public.get_servs_from_email(email))

	results = []
	for serv in data:
		for row in serv:
			#A func get_servs_from_email retorna um int
			#então não precisa do role acima
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
		#commita se não deu erro
		db.session.commit()
		return "Pessoa criada com id = {}. <br> <a href=\"/\"> Voltar </a>".format(data[0])

	except Exception as e:
		#se deu erro, volta atrás (só precisa no caso de escrita/update)
		db.session.rollback()
		return (str(e)+" <br> <a href=\"/\"> Voltar </a>")

def get_p(p_id):
	assert(p_id is not None)
	try:
		#Esse é outro jeito de pegar coisas, chamando pelo model
		#No model está definido o bind, então não precisa se preocupar com ele
		entry = B01Pessoa.query.filter_by(pes_id=p_id).first()
		return (entry.pes_id, entry.pes_name, entry.pes_cpf)

	except Exception as e:
		return(str(e))

def get_all_p():
	try:
		data = B01Pessoa.query.all()
		results = [] 
		for entry in data:
			results.append((entry.pes_id, entry.pes_name, entry.pes_cpf))

		return results

	except Exception as e:
		return(str(e))

def update_p(p_id, p_name, p_cpf):
	try:
		db.session.bind = db.get_engine(app, 'pessoas')
		data = db.session.query(func.public.update_Full_Pessoa(p_id, p_name, p_cpf)).first()
		db.session.commit()

	except Exception as e:
		return(str(e))

def delete_p(p_cpf):
	try:
		db.session.bind = db.get_engine(app, 'pessoas')
		data_p = db.session.query(func.public.delete_Pessoa(p_cpf)).first()

		#Deletar a rel também
		db.session.bind = db.get_engine(app, 'acc_peo')
		data_a = db.session.query(func.public.delete_pes_us_from_cpf(p_cpf)).first()

		print(data_a[0])

		db.session.commit()
		return "Pessoa deletada com id = {}. <br> <a href=\"/getall_p\"> Voltar </a>".format(data_p[0])

	except Exception as e:
		db.session.rollback()
		return(str(e))


def add_curso(codigo, nome, cpf, date_in, date_out):
	assert(codigo is not None)
	assert(cpf is not None)

	try:
		db.session.bind = db.get_engine(app, 'curr')
		data = db.session.query(func.public.create_Curso(codigo, nome, cpf, date_in, date_out)).first()
		#commita se não deu erro
		db.session.commit()
		return "Curso criado com id = {}. <br> <a href=\"/\"> Voltar </a>".format(data[0])

	except Exception as e:
		#se deu erro, volta atrás (só precisa no caso de escrita/update)
		db.session.rollback()
		return (str(e)+" <br> <a href=\"/\"> Voltar </a>")

def get_curso(curso_id):
	assert(curso_id is not None)
	try:
		#Esse é outro jeito de pegar coisas, chamando pelo model
		#No model está definido o bind, então não precisa se preocupar com ele
		entry = B06Curso.query.filter_by(cur_id=p_id).first()
		return (entry.cur_id, entry.cur_code, entry.cur_name, entry.adm_cpf, entry.ad_cur_date_in, entry.ad_cur_date_out)

	except Exception as e:
		return(str(e))

def get_all_curso():
	try:
		data = B06Curso.query.all()
		results = [] 
		for entry in data:
			results.append((entry.cur_id, entry.cur_code, entry.cur_name, entry.adm_cpf, entry.ad_cur_date_in, entry.ad_cur_date_out))

		return results

	except Exception as e:
		return(str(e))

def update_curso(codigo, nome, cpf, date_in, date_out):
	try:
		db.session.bind = db.get_engine(app, 'curr')
		data = db.session.query(func.public.update_Full_Curso(codigo, nome, cpf, date_in, date_out)).first()
		db.session.commit()

	except Exception as e:
		return(str(e))

def delete_curso(code):
	try:
		db.session.bind = db.get_engine(app, 'curr')
		data_c = db.session.query(func.public.delete_Curso(code)).first()

		#Deletar a rel também
		#db.session.bind = db.get_engine(app, 'peo_cur')
		#data_a = db.session.query(func.public.delete_pes_us_from_cpf(p_cpf)).first()

		print(data_c[0])

		db.session.commit()
		return "Pessoa deletada com id = {}. <br> <a href=\"/getall_p\"> Voltar </a>".format(data_c[0])

	except Exception as e:
		db.session.rollback()
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