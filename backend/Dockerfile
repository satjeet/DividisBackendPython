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
    DJANGO_SETTINGS_MODULE=dividis.settings

# Create directory structure and set permissions
RUN mkdir -p /var/log/django && \
    touch /var/log/django/dividis.log && \
    chown -R www-data:www-data /var/log/django && \
    chmod -R 755 /var/log/django

# Copy requirements first for layer caching
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy application code
COPY . .

# Make wait-for-postgres script executable
RUN chmod +x wait-for-postgres.sh

# Database initialization and application setup
RUN echo "==> Waiting for PostgreSQL..." && \
    ./wait-for-postgres.sh "$DB_HOST" && \
    echo "==> Running migrations..." && \
    python manage.py migrate --noinput && \
    echo "==> Migration status:" && \
    python manage.py showmigrations && \
    echo "==> Loading initial data..." && \
    (python manage.py load_level_titles || echo "[WARNING] Failed to load level titles (may be normal if existing)") && \
    (python manage.py loaddata api/fixtures/initial_modules.json || echo "[WARNING] Failed to load modules (may be normal if existing)") && \
    (python manage.py load_initial_missions || echo "[WARNING] Failed to load missions (may be normal if existing)")

# Collect static files (uncomment if needed)
# RUN python manage.py collectstatic --noinput

EXPOSE 8008

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8008/health/ || exit 1

# Start Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8008"]