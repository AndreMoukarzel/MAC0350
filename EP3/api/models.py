# coding: utf-8
from sqlalchemy import Boolean, CheckConstraint, Column, DateTime, Float, ForeignKey, Integer, String, Table, Text, Time
from sqlalchemy.schema import FetchedValue
from sqlalchemy.orm import relationship
from sqlalchemy.sql.sqltypes import NullType
from flask_sqlalchemy import SQLAlchemy


db = SQLAlchemy()


class B01Pessoa(db.Model):
    __tablename__ = 'b01_pessoa'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'pessoas'

    pes_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    pes_cpf = db.Column(db.String(11), nullable=False, unique=True)
    pes_name = db.Column(db.String(200))


class B02Professor(db.Model):
    __tablename__ = 'b02_professor'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'pessoas'

    prof_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    prof_nusp = db.Column(db.String(9), nullable=False, unique=True)
    prof_cpf = db.Column(db.ForeignKey('public.b01_pessoa.pes_cpf', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)

    b01_pessoa = db.relationship('B01Pessoa', primaryjoin='B02Professor.prof_cpf == B01Pessoa.pes_cpf', backref='b02_professors')


class B03Aluno(db.Model):
    __tablename__ = 'b03_aluno'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'pessoas'

    al_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    al_nusp = db.Column(db.String(9), nullable=False, unique=True)
    al_cpf = db.Column(db.ForeignKey('public.b01_pessoa.pes_cpf', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)

    b01_pessoa = db.relationship('B01Pessoa', primaryjoin='B03Aluno.al_cpf == B01Pessoa.pes_cpf', backref='b03_alunoes')


class B04Administrador(db.Model):
    __tablename__ = 'b04_administrador'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'pessoas'

    adm_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    adm_cpf = db.Column(db.ForeignKey('public.b01_pessoa.pes_cpf', ondelete='CASCADE', onupdate='CASCADE'), nullable=False, unique=True)
    adm_email = db.Column(db.String(99), unique=True)
    adm_dat_in = db.Column(db.DateTime, nullable=False)
    adm_dat_out = db.Column(db.DateTime)

    b01_pessoa = db.relationship('B01Pessoa', uselist=False, primaryjoin='B04Administrador.adm_cpf == B01Pessoa.pes_cpf', backref='b04_administradors')


class B05Disciplina(db.Model):
    __tablename__ = 'b05_disciplina'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'curr'

    dis_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    dis_code = db.Column(db.String(7), nullable=False, unique=True)
    dis_name = db.Column(db.String(80))
    dis_class_creds = db.Column(db.Integer)
    dis_work_creds = db.Column(db.Integer)

    b08_modulo = db.relationship('B08Modulo', secondary='public.b18_rel_dis_mod', backref='b05_disciplinas')
    # parents = db.relationship(
    #     'B05Disciplina',
    #     secondary='public.b24_rel_dis_dis',
    #     primaryjoin='B05Disciplina.dis_code == b24_rel_dis_dis.c.dis_code',
    #     secondaryjoin='B05Disciplina.dis_code == b24_rel_dis_dis.c.dis_req_code',
    #     backref='b05_disciplinas'
    # )


class B06Curso(db.Model):
    __tablename__ = 'b06_curso'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'curr'

    cur_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    cur_code = db.Column(db.Integer, nullable=False, unique=True)
    cur_name = db.Column(db.String(60))
    adm_cpf = db.Column(db.ForeignKey('public.b04_administrador.adm_cpf', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    ad_cur_date_in = db.Column(db.DateTime)
    ad_cur_date_out = db.Column(db.DateTime)

    b04_administrador = db.relationship('B04Administrador', primaryjoin='B06Curso.adm_cpf == B04Administrador.adm_cpf', backref='b06_cursoes')
    b07_trilha = db.relationship('B07Trilha', secondary='public.b13_rel_tr_cur', backref='b06_cursoes')
    b08_modulo = db.relationship('B08Modulo', secondary='public.b19_rel_mod_cur', backref='b06_cursoes')


class B07Trilha(db.Model):
    __tablename__ = 'b07_trilha'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'curr'

    tr_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    tr_name = db.Column(db.String(80), nullable=False, unique=True)


class B08Modulo(db.Model):
    __tablename__ = 'b08_modulo'
    __table_args__ = (
        db.CheckConstraint('mod_cred_min > 0'),
        {'schema': 'public'}
    )
    __bind_key__ = 'curr'

    mod_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    mod_code = db.Column(db.Integer, nullable=False, unique=True)
    mod_name = db.Column(db.String(40))
    mod_cred_min = db.Column(db.Integer)


class B10Perfil(db.Model):
    __tablename__ = 'b10_perfil'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'access'

    perf_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    perf_name = db.Column(db.String(20), nullable=False, unique=True)
    perf_desc = db.Column(db.String(100))

    b11_servico = db.relationship('B11Servico', secondary='public.b15_rel_pf_se', backref='b10_perfils')


class B11Servico(db.Model):
    __tablename__ = 'b11_servico'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'access'

    serv_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    serv_code = db.Column(db.Integer, nullable=False, unique=True)
    serv_name = db.Column(db.String(50), nullable=False)
    serv_desc = db.Column(db.String(280))


class B12RelTrMod(db.Model):
    __tablename__ = 'b12_rel_tr_mod'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'curr'

    rel_tr_name = db.Column(db.ForeignKey('public.b07_trilha.tr_name', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_mod_code = db.Column(db.ForeignKey('public.b08_modulo.mod_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_tr_mod_mandatory = db.Column(db.Boolean)

    b08_modulo = db.relationship('B08Modulo', primaryjoin='B12RelTrMod.rel_mod_code == B08Modulo.mod_code', backref='b12_rel_tr_mods')
    b07_trilha = db.relationship('B07Trilha', primaryjoin='B12RelTrMod.rel_tr_name == B07Trilha.tr_name', backref='b12_rel_tr_mods')


t_b13_rel_tr_cur = db.Table(
    'b13_rel_tr_cur',
    db.Column('rel_tr_name', db.ForeignKey('public.b07_trilha.tr_name', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    db.Column('rel_cur_code', db.ForeignKey('public.b06_curso.cur_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    schema='public',
    info={'bind_key': 'curr'}
)


class B14RelUsPf(db.Model):
    __tablename__ = 'b14_rel_us_pf'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'access'

    rel_us_email = db.Column(db.ForeignKey('public.users.us_email', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_perf_name = db.Column(db.ForeignKey('public.b10_perfil.perf_name', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_us_pf_date_in = db.Column(db.DateTime)
    rel_us_pf_date_out = db.Column(db.DateTime)

    b10_perfil = db.relationship('B10Perfil', primaryjoin='B14RelUsPf.rel_perf_name == B10Perfil.perf_name', backref='b14_rel_us_pfs')
    user = db.relationship('User', primaryjoin='B14RelUsPf.rel_us_email == User.us_email', backref='b14_rel_us_pfs')


t_b15_rel_pf_se = db.Table(
    'b15_rel_pf_se',
    db.Column('rel_perf_name', db.ForeignKey('public.b10_perfil.perf_name', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    db.Column('rel_serv_code', db.ForeignKey('public.b11_servico.serv_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    info={'bind_key': 'access'},
    schema='public'
)


class B16RelProfDi(db.Model):
    __tablename__ = 'b16_rel_prof_dis'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'peo_cur'

    rel_prof_nusp = db.Column(db.ForeignKey('public.b02_professor.prof_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_dis_code = db.Column(db.ForeignKey('public.b05_disciplina.dis_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_prof_disc_semester = db.Column(db.Integer)
    rel_prof_disc_year = db.Column(db.Integer)

    b05_disciplina = db.relationship('B05Disciplina', primaryjoin='B16RelProfDi.rel_dis_code == B05Disciplina.dis_code', backref='b16_rel_prof_dis')
    b02_professor = db.relationship('B02Professor', primaryjoin='B16RelProfDi.rel_prof_nusp == B02Professor.prof_nusp', backref='b16_rel_prof_dis')


class B17RelAlDi(db.Model):
    __tablename__ = 'b17_rel_al_dis'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'peo_cur'

    rel_al_nusp = db.Column(db.ForeignKey('public.b03_aluno.al_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_dis_code = db.Column(db.ForeignKey('public.b05_disciplina.dis_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    plan_semester = db.Column(db.Integer)
    plan_year = db.Column(db.Integer)

    b03_aluno = db.relationship('B03Aluno', primaryjoin='B17RelAlDi.rel_al_nusp == B03Aluno.al_nusp', backref='b17_rel_al_dis')
    b05_disciplina = db.relationship('B05Disciplina', primaryjoin='B17RelAlDi.rel_dis_code == B05Disciplina.dis_code', backref='b17_rel_al_dis')


t_b18_rel_dis_mod = db.Table(
    'b18_rel_dis_mod',
    db.Column('rel_dis_code', db.ForeignKey('public.b05_disciplina.dis_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    db.Column('rel_mod_code', db.ForeignKey('public.b08_modulo.mod_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    schema='public',
    info={'bind_key': 'curr'}
)


t_b19_rel_mod_cur = db.Table(
    'b19_rel_mod_cur',
    db.Column('rel_mod_code', db.ForeignKey('public.b08_modulo.mod_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    db.Column('rel_cur_code', db.ForeignKey('public.b06_curso.cur_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    schema='public',
    info={'bind_key': 'curr'}
)


class B20RelPesU(db.Model):
    __tablename__ = 'b20_rel_pes_us'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'acc_peo'

    rel_pes_cpf = db.Column(db.ForeignKey('public.b01_pessoa.pes_cpf', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_us_email = db.Column(db.ForeignKey('public.users.us_email', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_pes_us_date_in = db.Column(db.DateTime, nullable=False)
    rel_pes_us_date_out = db.Column(db.DateTime)

    b01_pessoa = db.relationship('B01Pessoa', primaryjoin='B20RelPesU.rel_pes_cpf == B01Pessoa.pes_cpf', backref='b20_rel_pes_us')
    user = db.relationship('User', primaryjoin='B20RelPesU.rel_us_email == User.us_email', backref='b20_rel_pes_us')


class B21Oferecimento(db.Model):
    __tablename__ = 'b21_oferecimento'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'peo_cur'

    rel_prof_nusp = db.Column(db.ForeignKey('public.b02_professor.prof_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_dis_code = db.Column(db.ForeignKey('public.b05_disciplina.dis_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_oferecimento_year = db.Column(db.Integer, primary_key=True, nullable=False)
    rel_oferecimento_semester = db.Column(db.Integer, primary_key=True, nullable=False)
    rel_oferecimento_class = db.Column(db.Integer)

    b05_disciplina = db.relationship('B05Disciplina', primaryjoin='B21Oferecimento.rel_dis_code == B05Disciplina.dis_code', backref='b21_oferecimentoes')
    b02_professor = db.relationship('B02Professor', primaryjoin='B21Oferecimento.rel_prof_nusp == B02Professor.prof_nusp', backref='b21_oferecimentoes')


class B22RelAlOf(db.Model):
    __tablename__ = 'b22_rel_al_of'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'peo_cur'

    rel_prof_nusp = db.Column(db.ForeignKey('public.b02_professor.prof_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_dis_code = db.Column(db.ForeignKey('public.b05_disciplina.dis_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_al_nusp = db.Column(db.ForeignKey('public.b03_aluno.al_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    rel_al_of_year = db.Column(db.Integer, primary_key=True, nullable=False)
    rel_al_of_semester = db.Column(db.Integer, primary_key=True, nullable=False)
    rel_al_of_grade = db.Column(db.Float)
    rel_al_of_attendance = db.Column(db.Float)

    b03_aluno = db.relationship('B03Aluno', primaryjoin='B22RelAlOf.rel_al_nusp == B03Aluno.al_nusp', backref='b22_rel_al_ofs')
    b05_disciplina = db.relationship('B05Disciplina', primaryjoin='B22RelAlOf.rel_dis_code == B05Disciplina.dis_code', backref='b22_rel_al_ofs')
    b02_professor = db.relationship('B02Professor', primaryjoin='B22RelAlOf.rel_prof_nusp == B02Professor.prof_nusp', backref='b22_rel_al_ofs')


class B23OfTime(db.Model):
    __tablename__ = 'b23_of_times'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'peo_cur'

    prof_nusp = db.Column(db.ForeignKey('public.b02_professor.prof_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    dis_code = db.Column(db.ForeignKey('public.b05_disciplina.dis_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    year = db.Column(db.Integer, primary_key=True, nullable=False)
    semester = db.Column(db.Integer, primary_key=True, nullable=False)
    time_in = db.Column(db.Time, primary_key=True, nullable=False)
    time_out = db.Column(db.Time, nullable=False)
    day = db.Column(db.Integer, primary_key=True, nullable=False)

    b05_disciplina = db.relationship('B05Disciplina', primaryjoin='B23OfTime.dis_code == B05Disciplina.dis_code', backref='b23_of_times')
    b02_professor = db.relationship('B02Professor', primaryjoin='B23OfTime.prof_nusp == B02Professor.prof_nusp', backref='b23_of_times')


t_b24_rel_dis_dis = db.Table(
    'b24_rel_dis_dis',
    db.Column('dis_code', db.ForeignKey('public.b05_disciplina.dis_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    db.Column('dis_req_code', db.ForeignKey('public.b05_disciplina.dis_code', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    schema='public',
    info={'bind_key': 'curr'}
)

class User(db.Model):
    __tablename__ = 'users'
    __table_args__ = {'schema': 'public'}
    __bind_key__ = 'access'

    us_id = db.Column(db.Integer, primary_key=True, server_default=db.FetchedValue())
    us_email = db.Column(db.String(99), unique=True)
    us_password = db.Column(db.Text, nullable=False)
