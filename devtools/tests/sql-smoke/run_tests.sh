#!/usr/bin/env bash
set -euo pipefail

if ! command -v psql >/dev/null 2>&1; then
  echo "psql not found in PATH. Skipping smoke tests. To run tests locally, install psql or run via CI/docker."
  exit 0
fi

echo "Waiting for Postgres to accept connections..."
for i in {1..20}; do
  if pg_isready -h localhost -p 5432 -U sqluser >/dev/null 2>&1; then
    echo "Postgres is ready"
    break
  fi
  sleep 1
done

export PGPASSWORD=sqlpass

echo "Running smoke queries..."
psql -h localhost -U sqluser -d sqldb -c "SELECT COUNT(*) FROM products;"
psql -h localhost -U sqluser -d sqldb -c "SELECT p.name, c.name AS category FROM products p JOIN categories c ON p.category_id = c.id;"

echo "Smoke tests completed."
