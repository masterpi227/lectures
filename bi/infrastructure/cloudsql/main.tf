provider "google" {
  region  = "us-central1"  # e.g., us-central1
}

resource "google_sql_database_instance" "sandbox_postgres" {
  name             = "sandbox-postgres-instance"
  database_version = "POSTGRES_16"  # Adjust the version as needed
  region           = var.region

  settings {
    tier                        = "db-custom-2-7680" # Customize machine type (2 vCPUs, 7.5 GB RAM)
    availability_type           = "REGIONAL"        # High availability setup
    disk_autoresize             = true
    disk_size                   = 100               # Initial disk size in GB
    disk_type                   = "PD_SSD"          # Enterprise-level SSD

    ip_configuration {
        ipv4_enabled = true

        authorized_networks {
            name  = "allow-local-access"
            value = "0.0.0.0/0"
        }
    }
    
    maintenance_window {
        day         = 1  # Maintenance on Monday
        hour        = 3  # Maintenance window start time (UTC)
        update_track = "stable"
    }
  }

  

  deletion_protection = false # Allow deletion for sandbox environments
}

resource "google_sql_database" "sandbox_db" {
  name     = "sandbox_db"
  instance = google_sql_database_instance.sandbox_postgres.name
}

resource "google_sql_user" "sandbox_user" {
  name     = "postgres"
  password = "postgres2025!" # Replace with a strong password or use a secret manager
  instance = google_sql_database_instance.sandbox_postgres.name
}

resource "google_storage_bucket_iam_member" "grant_sql_access" {
  bucket = "iu-db-data-airlines"  # Replace with your bucket name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:service-{PROJECT_NUMBER}@cloudsql.gserviceaccount.com"
}

resource "null_resource" "import_sql" {
  provisioner "local-exec" {
    command = <<EOT
    gcloud sql import sql ${google_sql_database_instance.sandbox_postgres.name} \
      gs://iu-db-data-airlines/Datensatz_Airlines.sql \
      --database=${google_sql_database.sandbox_db.name} \
      --project=${var.project_id}
    EOT
  }

  depends_on = [
    google_sql_database.sandbox_db,
    google_storage_bucket_iam_member.grant_sql_access
  ]
}

