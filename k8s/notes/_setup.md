Links
- http://ipv4.whatismyv6.com


project: bijakhq-dev

Cloud SQL
instance-id : bijaktrivia-postgres
user: postgres
password: E9obyl6Bm3OiuExw


gcloud sql databases create bijakhq_prod --instance=bijaktrivia-postgres

curl -o cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.386
chmod +x cloud_sql_proxy

PROJECT_ID = bijakhq-dev
SERVICE_ACCOUNT_EMAIL = proxy-user@bijakhq-dev.iam.gserviceaccount.com
CONNECTION_NAME = bijakhq-dev:asia-southeast1:bijaktrivia-postgres

gcloud projects add-iam-policy-binding bijakhq-dev --member \
serviceAccount:proxy-user@bijakhq-dev.iam.gserviceaccount.com --role roles/cloudsql.client

gcloud iam service-accounts keys create key.json --iam-account proxy-user@bijakhq-dev.iam.gserviceaccount.com

gcloud sql instances list
gcloud sql instances describe bijaktrivia-postgres | grep connectionName

./cloud_sql_proxy -instances=bijakhq-dev:asia-southeast1:bijaktrivia-postgres=tcp:5432 -credential_file=keys/proxy-user.json &

killall cloud_sql_proxy


# https://medium.com/platformer-blog/using-kubernetes-secrets-5e7530e0378a

kubectl create secret generic cloudsql-instance-credentials \
--namespace=bijakhq --from-file=credentials.json=./keys/proxy-user.json

# https://medium.com/@nithinmallya4/using-the-cloudsql-proxy-to-talk-to-mysql-from-your-gke-rails-application-aa53f2611b78
# https://ihaveabackup.net/article/kubernetes-on-gke-with-cloudsql-proxy

#================================================================================================================================
