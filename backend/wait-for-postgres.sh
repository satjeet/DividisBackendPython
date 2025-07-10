#!/bin/sh
# wait-for-postgres.sh

set -e

host="$1"
shift
cmd="$@"

#Productivo
until PGPASSWORD=$DB_PASSWORD psql "host=$host user=$DB_USER dbname=$DB_NAME port=$DB_PORT sslmode=require" -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd