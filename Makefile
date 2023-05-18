fresh:
	rm -rf .venv
	python3 -m venv .venv
	source .venv/bin/activate; pip install pipenv
	source .venv/bin/activate; PIPENV_VENV_IN_PROJECT=1 pipenv install --dev
	@echo "Setting up pre-commit..."
	source .venv/bin/activate; pre-commit install

.PHONY: fresh

test:
	@echo "Running tests..."

dev:
	source .venv/bin/activate; flask --app server run

docker: docker-build docker-run
docker-build:
	docker build . -t server

docker-run:
	docker run -p 8080:8080 server

.PHONY: docker
