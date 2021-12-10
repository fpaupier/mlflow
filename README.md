# ML Flow for prod

![](https://badgen.net/badge/mlflow/10140/blue?label=MLflow%20UI%20port)

A dockerized [ML Flow](https://mlflow.org/) server using a S3 server for artifacts (see [minio-s3-server](https://github.com/fpaupier/minio-s3-server)) 
and [PostgreSQL](https://www.postgresql.org/) for backend storage.

## Getting started

## Server side
1. Copy the provided example environment file and update it with your values, especially the
 `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD`. Those values will serve as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
```shell
cp .env.example .env
```

2. Start the service with docker-compose:
```shell
docker-compose -d
```

3. Log in to your minio console and create a bucket that will be th root of the mlflow runs
- go to http://your-minio-host:9001
- identify using `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD`
- create a `mlflow` bucket, its name must match the `ARTIFACT_ROOT_URI` in the `.env`

Your Mlflow server is up!
I recommend testing you can load metrics & artefacts from a simple client before going into 
advanced artefact logging scenarios. The `test_client/` offers just this, see the client side part below.

## Client side

Now that your ML Flow server is running, you might test that a client can effectively write 
metrics to the metrics store and artifacts to the artifacts store. Some configuration is required on the client 
willing to log info to the ML Flow server. The ``test_client/`` folder proposes a minimal example for a python
sklearn code logging its training to ML Flow.

To push your training results to an ML Flow server with an S3-like interface for artifact server, your client needs to:
- have mlflow installed (`pip install mlflow`)
- have `aws` local settings configured to interact with the S3 bucket. 
 > :info: When pushing artefacts from the client (e.g. saving a model),
the **artifacts are pushed directly to the S3 interface bucket, not proxyed through the ML Flow server**, Thus your client
needs to be aware of teh S3 endpoint to push the artifcat to and have the credentials to be allowed to do so. See 
architecture below. 

![See this doc](./doc/mlflow-archi.png)
_Source: MLflow.org, https://mlflow.org/docs/latest/tracking.html#concepts_

### Setting up your `aws` credentials on a MLflow client

_Note_: We use `aws` cli because s3 is a standard for object storage interface, but you can interact with a self-hosted
minio server just the same as you'd with aws simple object storage service (s3).

1. Install `aws-cli` and `awscli-plugin` using `pip`.
````shell
python3 -m pip install awscli awscli-plugin-endpoint
````

2. Create the file `~/.aws/config` by running the following command:
```shell
aws configure set plugins.endpoint awscli_plugin_endpoint
```

3. Open `~/.aws/config` in a text editor and edit it as follows:
```editorconfig
[plugins]
endpoint = awscli_plugin_endpoint

[default]
region = fr-par
s3 =
  endpoint_url = https://your-minio-host:your-minio-port
  signature_version = s3v4
  max_concurrent_requests = 100
  max_queue_size = 1000
  multipart_threshold = 50MB
  # Edit the multipart_chunksize value according to the file sizes that you want to upload. The present configuration allows to upload files up to 10 GB (1000 requests * 10MB). For example setting it to 5GB allows you to upload files up to 5TB.
  multipart_chunksize = 10MB
s3api =
  endpoint_url = https://your-minio-host:your-minio-port
```
4. Generate a credentials file using
```shell
aws configure
```

5. Open the `~/.aws/credentials` file and configure your API key as follows:
```editorconfig
[default]
aws_access_key_id=<ACCESS_KEY_THE VALUE_CAN_BE_YOUR_MINIO_ROOT_USER>
aws_secret_access_key=<SECRET_KEY_CAN_BE_YOUR_MINIO_ROOT_PASSWORD>
```

6. Test your cluster
```shell
aws s3 ls
```

Kudos to the [scaleway doc](https://www.scaleway.com/en/docs/storage/object/api-cli/object-storage-aws-cli/) for this aws configuration setup. 