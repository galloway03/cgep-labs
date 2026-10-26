# terraform/primitives/policy-fixture/main.tf
terraform {
  required_version = ">= 1.6"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}

provider "google" {
  project = var.gcp_project
  region  = "us-central1"
}

variable "gcp_project" { type = string }

# A KMS key for the compliant buckets.
resource "google_kms_key_ring" "ring" {
  name     = "lab33-ring"
  location = "us-central1"
}

resource "google_kms_crypto_key" "key" {
  name     = "lab33-key"
  key_ring = google_kms_key_ring.ring.id
  rotation_period = 7776000s # 90 days
}

# Compliant: CMEK, uniform access, all labels.
resource "google_storage_bucket" "good" {
  name                        = "${var.gcp_project}-lab33-good"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  encryption { default_kms_key_name = google_kms_crypto_key.key.id }

  labels = {
    project          = "lab33"
    environment      = "dev"
    managed_by       = "terraform"
    compliance_scope = "cge-p-lab"
  }
}

# Non-compliant: no encryption block (trips SC-28).
resource "google_storage_bucket" "bad_no_cmek" {
  name                        = "${var.gcp_project}-lab33-bad-no-cmek"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  encryption {
    default_kms_key_name = google_kms_crypto_key.bucket.id
  }
  depends_on = [google_kms_crypto_key_iam_member.gcs_cmek]

  labels = {
    project = "lab33", environment = "dev"
    managed_by = "terraform", compliance_scope = "cge-p-lab"
  }
}

resource "google_kms_crypto_key_iam_member" "gcs_cmek" {
  crypto_key_id = google_kms_crypto_key.bucket.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_storage_project_service_account.gcs.email_address}"
}

# Non-compliant: public access not locked down (trips AC-3).
resource "google_storage_bucket" "bad_public" {
  name                        = "${var.gcp_project}-lab33-bad-public"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  encryption { default_kms_key_name = google_kms_crypto_key.key.id }
  labels = {
    project = "lab33", environment = "dev"
    managed_by = "terraform", compliance_scope = "cge-p-lab"
  }
}

# Non-compliant: no labels (trips CM-6).
resource "google_storage_bucket" "bad_no_labels" {
  name                        = "${var.gcp_project}-lab33-bad-no-labels"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  encryption { default_kms_key_name = google_kms_crypto_key.key.id }
}

resource "google_compute_network" "demo" {
  name                    = "lab33-demo"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "open_ssh" {
  name          = "lab33-open-ssh"
  network       = google_compute_network.demo.name
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"] # choose your range
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}