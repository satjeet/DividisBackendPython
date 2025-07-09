FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    python3-dev \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=dividis.settings \
    PYTHONPATH=/app \
    PORT=8008

# Create directory structure and set permissions
RUN mkdir -p /var/log/django && \
    touch /var/log/django/dividis.log && \
    chown -R www-data:www-data /var/log/django && \
    chmod -R 755 /var/log/django

# Copy requirements first for layer caching
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install gunicorn whitenoise

# Copy application code
COPY . .

# Make wait-for-postgres script executable
RUN chmod +x wait-for-postgres.sh

# Collect static files
RUN python manage.py collectstatic --noinput

EXPOSE 8008

# Production entrypoint
CMD ["sh", "-c", \
    "./wait-for-postgres.sh $DB_HOST && \
     python manage.py migrate --noinput && \
     python manage.py load_level_titles || true && \
     python manage.py loaddata api/fixtures/initial_modules.json || true && \
     python manage.py load_initial_missions || true && \
     gunicorn --bind 0.0.0.0:8008 \
              --workers 4 \
              --timeout 120 \
              --access-logfile - \
              --error-logfile - \
              dividis.wsgi"]