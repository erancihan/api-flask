# syntax=docker/dockerfile:1
FROM python:3.11-slim AS base
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

FROM base AS builder
RUN pip install pipenv
COPY Pipfile Pipfile.lock ./
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy
RUN pipenv install gunicorn --skip-lock

FROM base AS runtime
COPY --from=builder /.venv /.venv
ENV PATH="/.venv/bin:$PATH"

WORKDIR /code
COPY ./server /code/server

EXPOSE 8080
CMD ["gunicorn", "-b", ":8080", "server:app"]
