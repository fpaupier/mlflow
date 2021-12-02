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

mlflow server \
      --backend-store-uri "postgresql://"$${POSTGRES_USER:?err}":"$${POSTGRES_PASSWORD:?err}"@backend_store:"$${POSTGRES_PORT:?err}"/"$${POSTGRES_DB:?err}"" \
      --default-artifact-root "$${ARTIFACT_ROOT_URI:?err}" \
      --host 0.0.0.0 \
      --port 5000