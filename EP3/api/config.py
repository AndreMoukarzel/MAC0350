import os
basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = 'this-really-needs-to-be-changed'
    SQLALCHEMY_DATABASE_URI = "postgresql://localhost/pessoas"
    SQLALCHEMY_BINDS = {
        'pessoas': 'postgresql://localhost/pessoas',
        'access': 'postgresql://localhost/access',
        'curr': 'postgresql://localhost/curriculum',
        'acc_peo': 'postgresql://localhost/inter_acc_peo',
        'peo_cur': 'postgresql://localhost/inter_peo_cur'
    }


class ProductionConfig(Config):
    DEBUG = False


class StagingConfig(Config):
    DEVELOPMENT = True
    DEBUG = True


class DevelopmentConfig(Config):
    DEVELOPMENT = True
    DEBUG = True


class TestingConfig(Config):
    TESTING = True