variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for GKE and Artifact Registry"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "edu-gke-cluster"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "edu-gke-vpc"
}

variable "subnetwork_name" {
  description = "Subnetwork name"
  type        = string
  default     = "edu-gke-subnet"
}

variable "subnetwork_cidr" {
  description = "Primary CIDR for subnetwork"
  type        = string
  default     = "10.20.0.0/20"
}

variable "pods_secondary_range_name" {
  description = "Secondary IP range name for Pods"
  type        = string
  default     = "gke-pods"
}

variable "pods_secondary_range_cidr" {
  description = "Secondary CIDR for Pods"
  type        = string
  default     = "10.21.0.0/16"
}

variable "services_secondary_range_name" {
  description = "Secondary IP range name for Services"
  type        = string
  default     = "gke-services"
}

variable "services_secondary_range_cidr" {
  description = "Secondary CIDR for Services"
  type        = string
  default     = "10.22.0.0/20"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "GCE machine type for nodes"
  type        = string
  default     = "e2-medium"
}

variable "release_channel" {
  description = "GKE release channel"
  type        = string
  default     = "REGULAR"

  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE"], var.release_channel)
    error_message = "release_channel must be one of RAPID, REGULAR, STABLE."
  }
}

variable "deletion_protection" {
  description = "Protect cluster from accidental deletion"
  type        = bool
  default     = false
}

variable "artifact_registry_repository" {
  description = "Artifact Registry repository ID"
  type        = string
  default     = "edu-flask-repo"
}

variable "image_name" {
  description = "Container image name used by CI/CD"
  type        = string
  default     = "flask-app"
}

variable "labels" {
  description = "Extra labels to attach to supported resources"
  type        = map(string)
  default     = {}
}
