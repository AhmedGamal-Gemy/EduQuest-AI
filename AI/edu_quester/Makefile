# uv path - can be overridden if uv is not in PATH
UV ?= uv

install:
	$(UV) sync

up:
	docker-compose up -d

down:
	docker-compose down

lint:
	$(UV) run ruff check . --fix
	$(UV) run ruff format .

test:
	$(UV) run pytest

run:
	$(UV) run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Note: 'clean' might fail on native Windows CMD without find/rm utilities. 
# Recommended to use WSL or Git Bash on Windows.
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
