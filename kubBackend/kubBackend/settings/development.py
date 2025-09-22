from .base import * 

DEBUG = True
ALLOWED_HOSTS = ["*"]

CORS_ORIGIN_ALLOW_ALL = True
SESSION_COOKIE_SECURE = False
CSRF_COOKIE_SECURE = False


ALLOWED_HOSTS = ['127.0.0.1', 'localhost']

# ROOT_URLCONF = 'kubBackend.urls'
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'kubdb',     
        'USER': 'postgres',     
        'PASSWORD': '1', 
        'HOST': 'postgres', 
        'PORT': '5432', 
    }
}



print("Using development settings")