# PROJECT_ID
# SERVICE_ACCOUNT

gcloud projects add-iam-policy-binding $1 \
  --member="serviceAccount:$2" \
  --role="roles/cloudsql.admin"

gcloud projects add-iam-policy-binding $1 \
  --member="serviceAccount:$2" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $1 \
  --member="serviceAccount:$2" \
  --role="roles/iam.serviceAccountUser"