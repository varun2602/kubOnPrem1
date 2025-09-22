from .base import *

DEBUG = False
ALLOWED_HOSTS = ["yourdomain.com"]

DATABASES = {
"default": {
'ENGINE': 'django.db.backends.postgresql',
'NAME': os.getenv("DB_NAME"),
'USER': os.getenv("DB_USER"),
'PASSWORD': os.getenv("DB_PASSWORD"),
'HOST': os.getenv("DB_HOST"),
'PORT': os.getenv("DB_PORT"),
}
}
ROOT_URLCONF = 'kubBackend.urls'
CORS_ALLOWED_ORIGINS = ["https://yourdomain.com"]

print("Using production settings")