# Clean up docker containers
https://linuxize.com/post/how-to-remove-docker-images-containers-volumes-and-networks/



# Follow this
https://github.com/liamgriffiths/distributed-elixir-demo
https://github.com/jeanpsv/kubernetes-elixir-example


# setup for secret

echo -n "LeDwWTFLj9xqw2EmcjgIQx3LOWLp3qVOEeo9QQb8uNmDyfyM3OvRAd4WG+HFb3/a" | base64
echo -n "E9obyl6Bm3OiuExw" | base64

kubectl create -f ./k8s/secrets.yaml

# Run application

# Build all the frontend assets, then create a manifest file for them
$ (cd assets && npm i && npm run deploy)
$ mix phx.digest

# Create a release with distillery
$ MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm mix release --env=prod --verbose

MIX_ENV=prod PORT=4000 REPLACE_OS_VARS=true _build/prod/rel/bijakhq/bin/bijakhq foreground

MIX_ENV=prod \
REPLACE_OS_VARS=true \
PORT=4000 \
HOST=example.com \
SECRET_KEY_BASE=LeDwWTFLj9xqw2EmcjgIQx3LOWLp3qVOEeo9QQb8uNmDyfyM3OvRAd4WG+HFb3/a \
DB_USERNAME=postgres \
DB_PASSWORD=E9obyl6Bm3OiuExw \
DB_NAME=bijakhq_prod \
DB_HOSTNAME=35.198.248.218 \
_build/prod/rel/bijakhq/bin/bijakhq foreground


# Run application with Docker

docker build --no-cache -t bijakhq .

docker run -it --rm -p 8080:8080 bijakhq

docker run -it -p 8080:8080 \
-e "HOST=example.com" \
-e "SECRET_KEY_BASE=LeDwWTFLj9xqw2EmcjgIQx3LOWLp3qVOEeo9QQb8uNmDyfyM3OvRAd4WG+HFb3/a" \
-e "DB_USERNAME=postgres" \
-e "DB_PASSWORD=E9obyl6Bm3OiuExw" \
-e "DB_NAME=bijakhq_prod" \
-e "DB_HOSTNAME=35.198.248.218" \
-e "PAYPAL_CLIENT_ID=AbdL0pqJgcqd5cKzzHJEsJ-qE6fUHq1IOYBrjnoWPzHlZUoivEZdnUP9ttie0Zzp1Fcv4Ic1VKD-qhrG" \
-e "PAYPAL_CLIENT_SECRET=EFqoDG-hQHswDzmjyWrNhTCBONRK3Ybdn_QWba5IddOG7WRMHkj72UU_dcTYYJ1HwVOCX8PLUmzGISaL" \
--rm bijakhq

$ docker ps
$ docker kill {container-id}

#=================================================================================

# Running the container in Minikube

# Start up Minikube (takes a minute or two)
$ minikube start

# See that we're up and running the cluster
$ minikube status

# Let Minikube talk to our local Docker daemon
$ eval $(minikube docker-env)

# Build another image for our app (like we did before)
$ docker build --no-cache -t bijakhq .

# Tag the image with a name we can use in our Kubernetes config
docker tag bijakhq:latest laksamanakeris/bijakhq:1

# Edit ./k8s/deployment.yaml and change the "image" entry to be the new tag we just used
# (in this example it is "laksamanakeris/bijakhq:1")

# Apply our kubernetes config to the cluster (more on this later)
<!-- $ kubectl create -f ./k8s/secrets.yaml -->
$ kubectl apply -f ./k8s/secrets.yaml

$ kubectl apply -f ./k8s/deployment.yaml

# Checkout this awesome built-in dashboard to inspect it (see namespace "hello")
$ minikube dashboard

# Open the our kubernetes "service" in a web browser
$ minikube service web --namespace=bijakhq

# Trash our Minikube cluster (if you don't want it anymore)
$ minikube delete

#=================================================================================

gcloud config set project bijakhq-dev

# To connect to GKE cluster
gcloud container clusters get-credentials bijakhq-cluster --zone=asia-southeast1-a

# Deploy to GKE

gcloud builds submit --tag=gcr.io/${project-name-id}/bijakhq:v1 .
gcloud builds submit --tag=gcr.io/bijakhq-dev/bijakhq:v1 .

gcloud container images list

gcloud container clusters create bijakhq-cluster --num-nodes=2 --zone=asia-southeast1-a

gcloud config set container/cluster bijakhq-cluster

kubectl run bijakhq-web --image=gcr.io/bijakhq-dev/bijakhq:v1 --port 8080

kubectl expose deployment bijakhq --type=LoadBalancer --port 80 --target-port 8080

kubectl get service

kubectl scale deployment bijakhq-web --replicas=3

gcloud builds submit --tag=gcr.io/bijakhq-dev/bijakhq:v3 .
gcloud builds submit --tag=gcr.io/bijakhq-dev/bijakhq:v5 .

kubectl set image deployment/bijakhq-web bijakhq-web=gcr.io/bijakhq-dev/bijakhq:v2
kubectl set image deployment/bijakhq-web bijakhq-web=gcr.io/bijakhq-dev/bijakhq:v1
kubectl set image deployment/bijakhq-web bijakhq-web=gcr.io/bijakhq-dev/bijakhq:v4


kubectl get pods
kubectl attach bijakhq-web-7d99bd65c6-hgk2z -c bijakhq-web


# https://cloud.google.com/compute/pricing

gcloud container clusters create bijakhq-cluster --zone asia-southeast1-a \
--machine-type=n1-standard-2  --enable-autorepair \
--enable-autoscaling --max-nodes=100 --min-nodes=1



#=================================================================================

# https://cloud.google.com/kubernetes-engine/docs/how-to/stateless-apps
# https://medium.com/google-cloud/kubernetes-110-your-first-deployment-bf123c1d3f8
# https://codelabs.developers.google.com/codelabs/cloud-postgresql-gke-memegen/#7


# Setup
gcloud config set project bijakhq-dev

gcloud container clusters create bijakhq-cluster --zone asia-southeast1-a \
--machine-type=n1-standard-2  --enable-autorepair \
--enable-autoscaling --max-nodes=100 --min-nodes=1

gcloud container clusters list

gcloud container clusters bijakhq-cluster --zone asia-southeast1-a
gcloud container clusters get-credentials bijakhq-cluster --zone=asia-southeast1-a

- setelkan db dulu

kubectl apply -f ./k8s/namespace.yaml
kubectl apply -f ./k8s/secrets.yaml
kubectl apply -f ./k8s/deployment.yaml

# Deploy
# reminder - if we use namespace, dont forget to put namespace when call kubectl

$ gcloud builds submit --tag=gcr.io/bijakhq-dev/bijakhq:v1 .
$ kubectl apply -f ./k8s/deployment.yaml
$ kubectl get secrets --namespace=bijakhq
$ kubectl get pods --namespace=bijakhq
$ kubectl expose deployment bijakhq --type=LoadBalancer --port 80 --target-port 8080 --namespace=bijakhq
$ kubectl describe services web --namespace=bijakhq  


# Domain & SSL setup
https://github.com/ahmetb/gke-letsencrypt/blob/master/10-install-helm.md


# ===================================================================================================================


# Setup GCP Ingress
https://cloud.google.com/kubernetes-engine/docs/tutorials/configuring-domain-name-static-ip

gcloud compute addresses create bijakhq-ip --global
gcloud compute addresses describe bijakhq-ip --global
# ===
address: 35.244.247.18
creationTimestamp: '2018-12-26T17:57:41.066-08:00'
description: ''
id: '4617697858140344186'
ipVersion: IPV4
kind: compute#address
name: bijakhq-ip
networkTier: PREMIUM
selfLink: https://www.googleapis.com/compute/v1/projects/bijakhq-dev/global/addresses/bijakhq-ip
status: RESERVED
# ===

# apply deployment.yaml
kubectl get ingress --namespace=bijakhq