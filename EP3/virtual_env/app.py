import os
import config
from models import *
from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config.from_object(config.DevelopmentConfig)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

@app.route("/")
def hello():
	return "Hello World!"

@app.route("/name/<name>")
def get_book_name(name):
	return "name : {}".format(name)

@app.route("/details")
def get_book_details():
	author=request.args.get('author')
	published=request.args.get('published')
	return "Author : {}, Published: {}".format(author,published)

@app.route("/getall")
def get_all():
    try:
        pessoas=B01Pessoa.query.all()
        lista = ""
        for p in pessoas:
        	lista = lista + " " + p.pes_name
        return lista
    except Exception as e:
	    return(str(e))

if __name__ == '__main__':
	app.run()