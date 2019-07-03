import config
from models import *
from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func

app = Flask(__name__)

app.config.from_object(config.DevelopmentConfig)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

@app.route("/")
def hello():
	return "Hello World!"

@app.route("/add_p")
def add_p():
	name=request.args.get('name')
	cpf=request.args.get('cpf')
	try:
		data = db.session.query(func.public.create_Pessoa(cpf, name)).first()
		db.session.commit()
		return "Pessoa added. id = {}".format(data[0])
	except Exception as e:
		db.session.rollback()
		return(str(e))

@app.route("/getall")
def get_all():
	try:
		pessoas=B01Pessoa.query.all()
		lista = ""
		for p in pessoas:
			lista = lista + p.pes_name + " "
		return lista
	except Exception as e:
		return(str(e))

if __name__ == '__main__':
	app.run()