# uv path - can be overridden if uv is not in PATH
UV ?= uv

install:
	$(UV) sync

build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

lint:
	$(UV) run ruff check . --fix
	$(UV) run ruff format .

test:
	$(UV) run pytest -v -s

run:
	$(UV) run uvicorn app.main:app --reload --host 0.0.0.0 --port 8001

# Note: 'clean' might fail on native Windows CMD without find/rm utilities. 
# Recommended to use WSL or Git Bash on Windows.
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

.PHONY: docs
docs:
	$(UV) run python scripts/export_openapi.py
	npx @redocly/cli build-docs openapi.json --output api_docs.html
