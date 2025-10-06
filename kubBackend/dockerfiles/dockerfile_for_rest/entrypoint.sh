#!/bin/sh
#!/bin/bash
# wait-for-postgres.sh

set -e

host="$DATABASE_HOST"
port=5432

until pg_isready -h "$host" -p "$port"; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

python manage.py migrate --noinput

python manage.py shell <<EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username="vk").exists():
    User.objects.create_superuser("vk", "vk@example.com", "1")
EOF

gunicorn kubBackend.wsgi:application --bind 0.0.0.0:8000 --workers 3 
# daphne -b 0.0.0.0 -p 8001 kubBackend.asgi:application

