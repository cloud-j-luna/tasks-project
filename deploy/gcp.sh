#!/usr/bin/env bash

PROJECT_ID=track-those-tasks
K8s_CLUSTER=ttt-development-cluster
ZONE=europe-west1-b

IMAGE_NAME=ttt-tasks
IMAGE_VERSION=v1

if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then
  rm -rf "$HOME/google-cloud-sdk"
  curl https://sdk.cloud.google.com | bash > /dev/null
fi

source $HOME/google-cloud-sdk/path.bash.inc

echo $GKE_SERVICE_KEY | base64 -d > service-account.json
gcloud components update kubectl
gcloud auth activate-service-account --key-file service-account.json

gcloud config set project $PROJECT_ID
gcloud container clusters \
		get-credentials $K8s_CLUSTER \
		--zone $ZONE \
		--project $PROJECT_ID
gcloud auth configure-docker

docker build -f ./deploy/tasks.Dockerfile -t gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_VERSION ./backend
docker push gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_VERSION

kubectl apply -f deploy/tasks.yaml
kubectl patch deployment $IMAGE_NAME -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"