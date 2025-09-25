SHELL := /bin/bash

.PHONY: help docs serve docker-up docker-down smoke

help:
	@echo "Available targets: docs serve docker-up docker-down smoke"

docs:
	../.venv/bin/mkdocs build -f mkdocs.yml

serve:
	mkdocs serve -a 0.0.0.0:8000

docker-up:
	sudo docker compose -f docker/docker-compose.yml up -d --build

docker-down:
	sudo docker compose -f docker/docker-compose.yml down -v

smoke:
	./tests/sql-smoke/run_tests.sh
