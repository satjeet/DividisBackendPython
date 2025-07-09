#!/bin/bash
set -e

# Ensure log directory exists with correct permissions
mkdir -p /var/log/django
touch /var/log/django/dividis.log
chown -R www-data:www-data /var/log/django
chmod -R 755 /var/log/django

echo "==> Esperando a que Postgres esté listo..."
./wait-for-postgres.sh "$DB_HOST"

echo "==> Ejecutando migraciones de Django..."
python manage.py migrate --noinput

echo "==> Estado de migraciones Django:"
python manage.py showmigrations

# Cargar títulos de nivel
echo " - Cargando títulos de nivel..."
python manage.py load_level_titles || echo " [WARNING] Falló cargar títulos (puede ser normal si ya existen)"

# Cargar fixtures
echo "==> Cargando fixtures iniciales en orden..."
echo " - Cargando módulos..."
python manage.py loaddata api/fixtures/initial_modules.json || echo " [WARNING] Falló cargar módulos (puede ser normal si ya existen)"
echo " - Cargando misiones..."
python manage.py load_initial_missions || echo " [WARNING] Falló cargar misiones (puede ser normal si ya existen)"

echo "==> Iniciando servidor Django..."
exec python manage.py runserver 0.0.0.0:8008