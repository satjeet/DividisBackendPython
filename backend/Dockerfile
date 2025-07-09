FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    python3-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create logs directory with correct permissions
RUN mkdir -p /var/log/django && \
    chown -R www-data:www-data /var/log/django && \
    chmod -R 755 /var/log/django

# Copy requirements first for caching
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the app
COPY . .

# Make scripts executable
RUN chmod +x entrypoint.sh wait-for-postgres.sh

# Collect static files (with temporary logging disabled)
#RUN python manage.py collectstatic --noinput --settings=dividis.settings

EXPOSE 8002

ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]