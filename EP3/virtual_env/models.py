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
        return '<id {}>'.format(self.pes_id)
    
    def serialize(self):
        return {
            'id': self.pes_id,
            'cpf': self.pes_cpf,
            'name': self.pes_name
        }

class Professor(db.Model):
    __tablename__ = 'b02_professor'

    prof_id = db.Column(db.Integer, primary_key=True)
    prof_nusp = db.Column(db.String(), nullable=False)
    prof_cpf = db.Column(db.String(), db.ForeignKey('Pessoa.pes_id'), nullable=False)

    def __init__(self, nusp, cpf):
        self.prof_nusp = nusp
        self.prof_cpf = cpf

    def __repr__(self):
        return '<id {}>'.format(self.prof_id)
    
    def serialize(self):
        return {
            'id': self.prof_id,
            'cpf': self.prof_cpf,
            'nusp': self.prof_nusp
        }

class Aluno(db.Model):
    __tablename__ = 'b03_aluno'

    al_id = db.Column(db.Integer, primary_key=True)
    al_nusp = db.Column(db.String(), nullable=False)
    al_cpf = db.Column(db.String(), db.ForeignKey('Pessoa.pes_cpf'), nullable=False)  

    def __init__(self, nusp, cpf):
        self.al_nusp = nusp
        self.al_cpf = cpf

    def __repr__(self):
        return '<id {}>'.format(self.al_id)
    
    def serialize(self):
        return {
            'id': self.al_id,
            'cpf': self.al_cpf,
            'nusp': self.al_nusp
        }

class Administrador(db.Model):
    __tablename__ = 'b04_administrador'

    adm_id = db.Column(db.Integer, primary_key=True)
    adm_cpf = db.Column(db.String(), db.ForeignKey('Pessoa.pes_cpf'), nullable=False)
    adm_email = db.Column(db.String(), nullable=False)
    adm_dat_in = db.Column(db.DateTime(), nullable=False)
    adm_dat_out = db.Column(db.DateTime()) 

    def __init__(self, nusp, email, dat_in, dat_out):
        self.adm_cpf = cpf
        self.adm_email = email
        self.adm_dat_in = dat_in
        self.adm_dat_out = dat_out

    def __repr__(self):
        return '<id {}>'.format(self.adm_id)
    
    def serialize(self):
        return {
            'id': self.adm_id,
            'cpf': self.adm_cpf,
            'email': self.adm_email,
            'adm_dat_in': self.adm_dat_in,
            'adm_dat_out': self.adm_dat_out
        }

class Disciplina(db.Model):
    __tablename__ = 'b05_disciplina'

    dis_id = db.Column(db.Integer, primary_key=True)
    dis_code = db.Column(db.String(), nullable=False)
    dis_name = db.Column(db.String())
    dis_class_creds = db.Column(db.Integer)
    dis_work_creds = db.Column(db.Integer)

    def __init__(self, code, name, class_creds, work_creds):
        self.dis_code = code
        self.dis_name = name
        self.dis_class_creds = class_creds
        self.dis_work_creds = work_creds

    def __repr__(self):
        return '<id {}>'.format(self.dis_id)

    def serialize(self):
        return{
            'id': self.dis_id,
            'code': self.dis_code,
            'name': self.dis_name,
            'class_creds': self.dis_class_creds,
            'work_creds': self.dis_work_creds
        }

class Curso(db.Model):
    __tablename__ = 'b06_curso'

    cur_id = db.Column(db.Integer, primary_key=True)
    cur_code = db.Column(db.Integer, nullable=False)
    cur_name = db.Column(db.String())
    adm_cpf = db.Column(db.String(), db.ForeignKey('Administrador.adm_cpf'), nullable=False)
    ad_cur_date_in = db.Column(db.DateTime())
    ad_cur_date_out = db.Column(db.DateTime())

    def __init__(self, code, name, adm_cpf, date_in, date_out):
        self.cur_code = code
        self.cur_name = name
        self.adm_cpf = adm_cpf
        self.ad_cur_date_in = date_in
        self.ad_cur_date_out = date_out

    def __repr__(self):
        return '<id {}>'.format(self.cur_id)

    def serialize(self):
        return{
            'id': self.cur_id,
            'code': self.cur_code,
            'name': self.cur_name,
            'adm_cpf': self.adm_cpf,
            'ad_cur_date_in': self.ad_cur_date_in,
            'ad_cur_date_out': self.ad_cur_date_out
        }

class Trilha(db.Model):
    __tablename__ = 'b07_trilha'

    tr_id = db.Column(db.Integer, primary_key=True)
    tr_name = db.Column(db.String(), nullable=False)

    def __init__(self, name):
        self.tr_name = name

    def __repr__(self):
        return '<id {}>'.format(self.tr_id)

    def serialize(self):
        return{
            'id': self.tr_id,
            'name': self.tr_name
        }

class Modulo(db.Model):
    __tablename__ = 'b08_modulo'

    mod_id = db.Column(db.Integer, primary_key=True)
    mod_code = db.Column(db.Integer, nullable=False)
    mod_name = db.Column(db.String())
    mod_cred_min = db.Column(db.Integer)

    def __init__(self, code, name, cred_min):
        self.mod_code = code
        self.mod_name = name
        self.mod_cred_min = cred_min

    def __repr__(self):
        return '<id {}>'.format(self.mod_id)

class Users(db.Model):
    __tablename__ = 'users'

    us_id = db.Column(db.Integer, primary_key=True)
    us_email = db.Column(db.String())
    us_password = db.Column(db.String(), nullable=False)

    def __init__(self, email, password):
        self.us_email = email
        self.us_password = password

    def __repr__(self):
        return '<id {}>'.format(self.us_id)

class Perfil(db.Model):
    __tablename__ = 'b10_perfil'

    perf_id = db.Column(db.Integer, primary_key=True)
    perf_name = db.Column(db.String(), nullable=False)
    perf_desc = db.Column(db.String())

    def __init__(self, name, desc):
        self.perf_name = name
        self.perf_desc = desc

    def __repr__(self):
        return '<id {}>'.format(self.perf_id)

class Servico(db.Model):
    __tablename__ = 'b11_servico'

    serv_id = db.Column(db.Integer, primary_key=True)
    serv_code = db.Column(db.Integer, nullable=False)
    serv_name = db.Column(db.String(), nullable=False)
    serv_desc = db.Column(db.String())

    def __init__(self, code, name, desc):
        self.serv_code = code
        self.serv_name = name
        self.serv_desc = desc

    def __repr__(self):
        return '<id {}>'.format(self.serv_id)

class Rel_Tr_Mod(db.Model):
    __tablename__ = 'b12_rel_tr_mod'

    rel_tr_name = db.Column(db.String(), db.ForeignKey('Trilha.tr_name'), primary_key=True)
    rel_mod_code = db.Column(db.Integer, db.ForeignKey('Modulo.mod_code'), primary_key=True)
    rel_tr_mod_mandatory = db.Column(db.Boolean())

    def __init__(self, tr_name, mod_code, mandatory):
        self.rel_tr_name = tr_name
        self.rel_mod_code = mod_code
        self.rel_tr_mod_mandatory = mandatory

    def __repr__(self):
        return '<id {} {}>'.format(self.rel_tr_name, self.rel_mod_code)