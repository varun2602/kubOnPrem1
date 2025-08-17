#!/bin/sh

# Run migrations
python manage.py makemigrations --noinput
python manage.py migrate --noinput

# Create superuser if it doesn't exist
echo "from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='vk').exists():
    User.objects.create_superuser('vk', 'vk@example.com', '1')
" | python manage.py shell

# Start Django with Gunicorn
gunicorn kubBackend.wsgi:application --bind 0.0.0.0:8000 --workers 3

