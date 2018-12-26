# Clean up docker containers
https://linuxize.com/post/how-to-remove-docker-images-containers-volumes-and-networks/



# Follow this
https://github.com/liamgriffiths/distributed-elixir-demo
https://github.com/jeanpsv/kubernetes-elixir-example


# setup for secret

echo -n "MjnsZX3ZOayH6ouA0p10BUyIkXQpF8C0NU4MBhsfx2q5wLdVdXtc43c4of0Z+ksy" | base64
echo -n "7dxx0HsMjlk9EAsD" | base64

kubectl create -f ./k8s/secrets.yaml

# Run application
MIX_ENV=prod PORT=4000 REPLACE_OS_VARS=true _build/prod/rel/bijakhq/bin/bijakhq foreground

MIX_ENV=prod \
REPLACE_OS_VARS=true \
PORT=4000 \
HOST=example.com \
SECRET_KEY_BASE=MjnsZX3ZOayH6ouA0p10BUyIkXQpF8C0NU4MBhsfx2q5wLdVdXtc43c4of0Z+ksy \
DB_USERNAME=postgres \
DB_PASSWORD=7dxx0HsMjlk9EAsD \
DB_NAME=bijakhq_prod \
DB_HOSTNAME=35.240.164.92 \
_build/prod/rel/bijakhq/bin/bijakhq foreground


# Run application with Docker

docker build --no-cache -t bijakhq .

docker run -it --rm -p 8080:8080 bijakhq

docker run -it -p 8080:8080 \
-e "HOST=example.com" \
-e "SECRET_KEY_BASE=MjnsZX3ZOayH6ouA0p10BUyIkXQpF8C0NU4MBhsfx2q5wLdVdXtc43c4of0Z+ksy" \
-e "DB_USERNAME=postgres" \
-e "DB_PASSWORD=7dxx0HsMjlk9EAsD" \
-e "DB_NAME=bijakhq_prod" \
-e "DB_HOSTNAME=35.240.164.92" \
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
$ kubectl create -f ./k8s/secrets.yaml
$ kubectl apply -f ./k8s/secrets.yaml

$ kubectl apply -f ./k8s/deployment.yaml

# Checkout this awesome built-in dashboard to inspect it (see namespace "hello")
$ minikube dashboard

# Open the our kubernetes "service" in a web browser
$ minikube service web --namespace=bijakhq

# Trash our Minikube cluster (if you don't want it anymore)
$ minikube delete

#=================================================================================

gcloud config set project phoenix-test-226101

# To connect to GKE cluster
gcloud container clusters get-credentials bijakhq-cluster --zone=asia-southeast1-a

# Deploy to GKE

gcloud builds submit --tag=gcr.io/${project-name-id}/bijakhq:v1 .
gcloud builds submit --tag=gcr.io/phoenix-test-226101/bijakhq:v1 .

gcloud container images list

gcloud container clusters create bijakhq-cluster --num-nodes=2 --zone=asia-southeast1-a

gcloud config set container/cluster bijakhq-cluster

kubectl run bijakhq-web --image=gcr.io/phoenix-test-226101/bijakhq:v1 --port 8080

kubectl expose deployment bijakhq --type=LoadBalancer --port 80 --target-port 8080

kubectl get service

kubectl scale deployment bijakhq-web --replicas=3

gcloud builds submit --tag=gcr.io/phoenix-test-226101/bijakhq:v3 .
gcloud builds submit --tag=gcr.io/phoenix-test-226101/bijakhq:v5 .

kubectl set image deployment/bijakhq-web bijakhq-web=gcr.io/phoenix-test-226101/bijakhq:v2
kubectl set image deployment/bijakhq-web bijakhq-web=gcr.io/phoenix-test-226101/bijakhq:v1
kubectl set image deployment/bijakhq-web bijakhq-web=gcr.io/phoenix-test-226101/bijakhq:v4


kubectl get pods
kubectl attach bijakhq-web-7d99bd65c6-hgk2z -c bijakhq-web



gcloud container clusters create my-cluster --zone us-central1-f \
--machine-type=n1-standard-2  --enable-autorepair \
--enable-autoscaling --max-nodes=10 --min-nodes=1



#=================================================================================

# https://cloud.google.com/kubernetes-engine/docs/how-to/stateless-apps
# https://medium.com/google-cloud/kubernetes-110-your-first-deployment-bf123c1d3f8
# https://codelabs.developers.google.com/codelabs/cloud-postgresql-gke-memegen/#7


# Setup
gcloud config set project phoenix-test-226101

gcloud container clusters create bijakhq-cluster --zone=asia-southeast1-a

gcloud container clusters bijakhq-cluster --zone asia-southeast1-a
gcloud container clusters get-credentials bijakhq-cluster --zone=asia-southeast1-a

- setelkan db dulu

kubectl apply -f ./k8s/deployment.yaml

# Deploy

$ gcloud builds submit --tag=gcr.io/phoenix-test-226101/bijakhq:v7 .
$ kubectl apply -f ./k8s/deployment.yaml
$ kubectl get pods
$ kubectl expose deployment bijakhq --type=LoadBalancer --port 80 --target-port 8080