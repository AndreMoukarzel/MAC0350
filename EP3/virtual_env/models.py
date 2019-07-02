from app import db

class Pessoa(db.Model):
    __tablename__ = 'b01_pessoa'

    pes_id = db.Column(db.Integer, primary_key=True)
    pes_cpf = db.Column(db.String(), nullable=False)
    pes_name = db.Column(db.String())

    def __init__(self, cpf, name):
        self.pes_cpf = cpf
        self.pes_name = name

    def __repr__(self):
        return '<id {}>'.format(self.id)
    
    def serialize(self):
        return {
            'id': self.pes_id,
            'cpf': self.pes_cpf,
            'name': self.pes_name
        }