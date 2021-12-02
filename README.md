# ML Flow for prod

![](https://badgen.net/badge/mlflow/10140/blue?label=MLflow%20UI%20port)
![](https://badgen.net/badge/minio/9001/blue?label=minio%20console%20port)

A dockerized [ML Flow](https://mlflow.org/) server with [minio](https://min.io/) as artefact server and [PostgreSQL](https://www.postgresql.org/)
for backend storage.

## Getting started

1. Copy the provided example environment file and update it with your values, especially the
 `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD`.
```shell
cp .env.example .env
```

2. Start the service with docker-compose:
```shell
docker-compose -d
```

