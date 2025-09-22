from pathlib import Path
from datetime import timedelta
from dotenv import load_dotenv
import os
from redis.sentinel import Sentinel
from django_redis.client import DefaultClient


load_dotenv()
# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent
# Pull the SECRET_KEY from the environment
SECRET_KEY = os.getenv("SECRET_KEY")
ALLOWED_HOSTS = os.getenv("ALLOWED_HOSTS", "localhost,127.0.0.1").split(',')
CSRF_TRUSTED_ORIGINS = os.getenv("CSRF_TRUSTED_ORIGINS", "http://localhost").split(',')
LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True

STATIC_URL = 'static/'
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
    # 'django_sentinel',
    'django_redis',
    'api'
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'corsheaders.middleware.CorsMiddleware'
]
# CORS_ALLOW_ALL_ORIGINS = True
# LANGUAGE_CODE = 'en-us'
# TIME_ZONE = 'Asia/Dhaka'
# USE_I18N = True
# USE_TZ = True
# STATIC_URL = 'static/'
# MEDIA_URL = '/media/'
# MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
# ROOT_URLCONF = 'kubBackend.urls'
# REST_FRAMEWORK = {
#     'DEFAULT_AUTHENTICATION_CLASSES': ['rest_framework_simplejwt.authentication.JWTAuthentication'],
# }
SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(days=7),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=15),
    "SIGNING_KEY": os.getenv("SECRET_KEY"),
}
# CELERY_BROKER_URL = 'redis://127.0.0.1:6379'
# CELERY_RESULT_BACKEND = 'django-db'
# EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
# EMAIL_HOST = 'smtp.gmail.com'
# EMAIL_USE_TLS = True
# EMAIL_PORT = 587
# EMAIL_HOST_USER = os.getenv("EMAIL_HOST_USER")
# EMAIL_HOST_PASSWORD = os.getenv("EMAIL_HOST_PASSWORD")


TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]


SENTINELS = [
    ('sentinel1', 26379),
    ('sentinel2', 26379),
]

sentinel = Sentinel(SENTINELS, socket_timeout=0.1)
# redis_master = sentinel.master_for('cluster1', socket_timeout=0.1)
DJANGO_REDIS_CONNECTION_FACTORY = 'django_redis.pool.SentinelConnectionFactory'

# The correct way to configure Redis Sentinel with django-redis.
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://cluster1/0",  # Placeholder for Sentinel connection. It's not a real address.
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.SentinelClient",
            "MASTER_NAME": "cluster1",  # This must match your sentinel.conf
            "SENTINELS": SENTINELS,
            # If your master is password-protected, add the password here.
            "SENTINEL_PASSWORD": None,
        }
    }
}

ROOT_URLCONF = 'kubBackend.urls'