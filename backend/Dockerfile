FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    python3-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the app
COPY . .

# Make scripts executable
RUN chmod +x entrypoint.sh wait-for-postgres.sh

# Fix logging directory
RUN mkdir -p /var/log/django && \
    touch /var/log/django/dividis.log && \
    chmod -R 777 /var/log/django

# Collect static files
RUN python manage.py collectstatic --noinput

EXPOSE 8002

ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]