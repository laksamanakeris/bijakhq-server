# Clean up docker containers
https://linuxize.com/post/how-to-remove-docker-images-containers-volumes-and-networks/

# http://bijaktrivia.xyz/command-center-alpha-tango-create-tokens/users

# Follow this
https://github.com/liamgriffiths/distributed-elixir-demo
https://github.com/jeanpsv/kubernetes-elixir-example

https://github.com/kubernetes/ingress-gce/tree/master/examples/websocket

# to consider create separate service for database
https://github.com/GoogleCloudPlatform/cloudsql-proxy/blob/master/Kubernetes.md

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
kubectl get pods -o=wide -n=bijakhq
kubectl attach bijakhq-web-7d99bd65c6-hgk2z -c bijakhq-web

kubectl logs <podname> -c cloudsql-proxy


# https://cloud.google.com/compute/pricing

gcloud config set compute/zone asia-southeast1-a

gcloud container clusters create bijakhq-cluster --zone asia-southeast1-a \
--machine-type=n1-standard-4  --enable-autorepair \
--enable-autoscaling --max-nodes=1000 --min-nodes=1

gcloud container clusters update bijakhq-cluster --zone asia-southeast1-a \
--machine-type=n1-standard-4 \
--enable-autoscaling --max-nodes=100 --min-nodes=1

gcloud container clusters create bijakhq-cluster --num-nodes=5

# high CPU
gcloud container node-pools create larger-pool --cluster=bijakhq-cluster \
  --machine-type=n1-standard-4  --enable-autorepair \
--enable-autoscaling --max-nodes=50 --min-nodes=1

# high memory
gcloud container node-pools create high-memory --cluster=bijakhq-cluster \
  --machine-type=n1-highmem-2  --enable-autorepair \
--enable-autoscaling --max-nodes=9 --min-nodes=1

gcloud container node-pools list --cluster bijakhq-cluster

# delete pool
gcloud container node-pools delete default-pool --cluster bijakhq-cluster
gcloud container node-pools delete large-pool --cluster bijakhq-cluster
gcloud container node-pools delete high-memory --cluster bijakhq-cluster

kubectl autoscale deployment bijakhq --max 500 --min 1 --cpu-percent 50 --namespace=bijakhq
kubectl autoscale deployment bijakhq --cpu-percent=50 --min=1 --max=10
kubectl autoscale deployment bijakhq --max 1000 --min 1 --cpu-percent 50 --namespace=bijakhq

kubectl delete hpa

#  autoscale
https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
https://github.com/kubernetes/ingress-gce/tree/e72479ba461fedae5fc5bf64999f28ba3125004d/examples/websocket



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

# build container
$ gcloud builds submit --tag=gcr.io/bijakhq-dev/bijakhq:v15 .


$ kubectl apply -f ./k8s/deployment.yaml
$ kubectl get secrets --namespace=bijakhq
$ kubectl get pods --namespace=bijakhq
$ kubectl expose deployment bijakhq --type=LoadBalancer --port 80 --target-port 8080 --namespace=bijakhq
$ kubectl describe services web --namespace=bijakhq  

kubectl get hpa --namespace=bijakhq
kubectl get pods --namespace=bijakhq

kubectl get pods -o=wide -n=bijakhq

kubectl logs <podname> -c cloudsql-proxy


# Domain & SSL setup
https://github.com/ahmetb/gke-letsencrypt/blob/master/10-install-helm.md
https://cloud.google.com/kubernetes-engine/docs/tutorials/configuring-domain-name-static-ip
https://akomljen.com/get-automatic-https-with-lets-encrypt-and-kubernetes-ingress/
https://kubernetes.io/docs/reference/kubectl/cheatsheet/



Install the Helm client on your development machine:
- https://docs.helm.sh/using_helm/#installing-helm-client

kubectl create serviceaccount -n {namespace} tiller
kubectl create serviceaccount -n bijakhq tiller

kubectl create clusterrolebinding tiller-binding \
    --clusterrole=cluster-admin \
    --serviceaccount bijakhq:tiller

helm install --name cert-manager --version v0.5.2 \
    --namespace bijakhq stable/cert-manager

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


# connect to pod

kubectl get pods -n=bijakhq
kubectl -n=bijakhq exec -it bijakhq-749c5bc8d4-7zj8l -c bijakhq sh

$ vi releases/0.0.1/vm.args
or
$ sed -i.bak "s/bijakhq/console/g" releases/0.0.1/vm.args

PORT=5555 ./bin/start_server console --name debugging@127.0.0.1 --remsh console@127.0.0.1 --cookie bijakhqcookie

kubectl -n bijakhq port-forward bijakhq-746db8c55d-k2nlf 4369 9001 9002 9003 9004

kubectl -n bijakhq exec -t bijakhq-746db8c55d-k2nlf -c bijakhq -- env | grep MY_POD_IP

sudo iptables -t nat -A OUTPUT -d 10.40.22.15 -j DNAT --to-destination 127.0.0.1
sudo iptables -t nat -A OUTPUT -d 10.40.22.15 -j DNAT --to-destination 127.0.0.1

# https://www.mendrugory.com/post/remote-elixir-node-kubernetes/
# https://stackoverflow.com/questions/41998083/running-observer-for-a-remote-erlang-node-making-it-simpler


kubectl exec -n=bijakhq bijakhq-9d87d966-2krss -i -t -- iex --name debugging@127.0.0.1 --remsh console@127.0.0.1 --cookie bijakhqcookie 
kubectl exec -n=bijakhq bijakhq-9d87d966-2krss -i -t -- env PORT=5555 && iex --name debugging@127.0.0.1 --remsh console@10.40.22.15 --cookie bijakhqcookie
kubectl exec -n=bijakhq bijakhq-9d87d966-2krss -i -t -- env PORT=5555 && iex --name debugging@127.0.0.1 --remsh console@10.40.22.15 --cookie bijakhqcookie

kubectl exec -n=bijakhq bijakhq-9d87d966-2krss -- bash -c "cd /opt/app; env PORT=5555 && ./bin/start_server console --name debugging@127.0.0.1 --remsh console@127.0.0.1 --cookie bijakhqcookie"
kubectl exec -n=bijakhq bijakhq-9d87d966-2krss -- bash -c "cd /opt/app; "

# https://www.mendrugory.com/post/remote-elixir-node-kubernetes/
kubectl port-forward --namespace=bijakhq bijakhq-9d87d966-2krss 4369 &

iex --cookie bijakhqcookie --name bijakhq@127.0.0.1 \
    -e "Node.connect(:'bijakhq@10.40.22.16')" \
    -S mix run --no-start


# This is working
echo "rdr on en0 inet proto tcp from any to 10.40.22.18 -> 127.0.0.1" | sudo pfctl -ef -
sudo sysctl -w net.inet.ip.forwarding=1
sudo pfctl -s nat


kubectl port-forward myapp-2431125679-cwqvt 35609 4369

iex --name console@10.40.22.16 --cookie bijakhqcookie

Node.connect(:"bijakhq@10.40.22.16")

iex --name console@10.40.22.18 --cookie bijakhqcookie --remsh "bijakhq@10.40.22.18"
epmd -names