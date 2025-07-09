FROM python:3.11-slim

# Install system dependencies first (includes PostgreSQL dev tools)
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    python3-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for better layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Make scripts executable
RUN chmod +x entrypoint.sh wait-for-postgres.sh

# Collect static files
RUN python manage.py collectstatic --noinput

EXPOSE 8002

ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]