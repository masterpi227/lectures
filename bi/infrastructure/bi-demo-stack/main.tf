provider "google" {
  region = "us-central1"
}


resource "google_compute_instance" "instance-airflow" {
  name                      = "instance-airflow"
  zone                      = "us-central1-a"
  tags                      = ["airflow"]
  machine_type              = "n2-standard-4"
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "true"

    initialize_params {
      image = "debian-cloud/debian-12"
      size  = "20"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<SCRIPT
    apt update
    apt install -y git
    git clone https://github.com/masterpi227/lectures.git
    cd lectures/bi
    bash docker.sh
    bash airflow.sh
    bash theia.sh
    SCRIPT

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "instance-nifi" {
  name                      = "instance-nifi"
  zone                      = "us-central1-a"
  tags                      = ["nifi"]
  machine_type              = "n2-standard-4"
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "true"

    initialize_params {
      image = "debian-cloud/debian-12"
      size  = "50"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<SCRIPT
    apt update
    apt install -y git
    git clone https://github.com/masterpi227/lectures.git
    cd lectures/bi
    bash docker.sh
    bash nifi.sh
    SCRIPT

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "instance-clickhouse" {
  name                      = "instance-clickhouse"
  zone                      = "us-central1-a"
  tags                      = ["clickhouse"]
  machine_type              = "n2-standard-4"
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "true"

    initialize_params {
      image = "debian-cloud/debian-12"
      size  = "50"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<SCRIPT
    apt update
    apt install -y git
    git clone https://github.com/masterpi227/lectures.git
    cd lectures/bi
    bash docker.sh
    bash clickhouse.sh
    SCRIPT

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "instance-metabase" {
  name                      = "instance-metabase"
  zone                      = "us-central1-a"
  tags                      = ["metabase"]
  machine_type              = "e2-medium"
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "true"

    initialize_params {
      image = "debian-cloud/debian-12"
      size  = "20"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<SCRIPT
    apt update
    apt install -y git
    git clone https://github.com/masterpi227/lectures.git
    cd lectures/bi
    bash docker.sh
    bash metabase.sh
    SCRIPT

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "instance-cubejs" {
  name                      = "instance-cubejs"
  zone                      = "us-central1-a"
  tags                      = ["cubejs"]
  machine_type              = "e2-medium"
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "true"

    initialize_params {
      image = "debian-cloud/debian-12"
      size  = "20"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<SCRIPT
    apt update
    apt install -y git
    git clone https://github.com/masterpi227/lectures.git
    cd lectures/bi
    bash docker.sh
    bash cubejs.sh
    bash theia.sh
    SCRIPT

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "default-allow-airflow" {
  project     = var.project_id
  name        = "default-allow-airflow"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["8080", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["airflow"]
}

resource "google_compute_firewall" "default-allow-clickhouse" {
  project     = var.project_id
  name        = "default-allow-clickhouse"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["8123", "8443", "9000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["clickhouse"]
}

resource "google_compute_firewall" "default-allow-nifi" {
  project     = var.project_id
  name        = "default-allow-nifi"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["8080", "8443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["nifi"]
}

resource "google_compute_firewall" "default-allow-metabase" {
  project     = var.project_id
  name        = "default-allow-metabase"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["metabase"]
}

resource "google_compute_firewall" "default-allow-cubejs" {
  project     = var.project_id
  name        = "default-allow-cubejs"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["4000", "15432", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["cubejs"]
}