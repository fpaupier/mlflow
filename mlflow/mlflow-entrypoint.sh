#!/bin/bash

set -e

if [ -z "$MLFLOW_S3_ENDPOINT_URL" ]; then
  echo >&2 "MLFLOW_S3_ENDPOINT_URL must be set"
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo >&2 "AWS_ACCESS_KEY_ID must be set (same as MINIO_ROOT_USER)"
  exit 1
fi

# shellcheck disable=SC2086
if [ -z $AWS_SECRET_ACCESS_KEY ]; then
  echo >&2 "AWS_SECRET_ACCESS_KEY must be set (same as MINIO_ROOT_PASSWORD)"
  exit 1
fi

if [ -z "$POSTGRES_USER" ]; then
  echo >&2 "POSTGRES_USER must be set"
  exit 1
fi

if [ -z "$POSTGRES_PASSWORD" ]; then
  echo >&2 "POSTGRES_PASSWORD must be set"
  exit 1
fi

if [ -z "$POSTGRES_PORT" ]; then
  echo >&2 "POSTGRES_PORT must be set"
  exit 1
fi

if [ -z "$POSTGRES_DB" ]; then
  echo >&2 "POSTGRES_DB must be set"
  exit 1
fi

if [ -z "$ARTIFACT_ROOT_URI" ]; then
  echo >&2 "ARTIFACT_ROOT_URI must be set"
  exit 1
fi

mlflow server \
      --backend-store-uri "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@backend_store:$POSTGRES_PORT/$POSTGRES_DB" \
      --default-artifact-root "$ARTIFACT_ROOT_URI" \
      --host 0.0.0.0 \
      --port 5000