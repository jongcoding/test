output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.primary.name
}

output "cluster_location" {
  description = "GKE cluster region"
  value       = google_container_cluster.primary.location
}

output "cluster_endpoint" {
  description = "GKE API endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository ID"
  value       = google_artifact_registry_repository.docker_repo.repository_id
}

output "artifact_registry_hostname" {
  description = "Artifact Registry hostname"
  value       = "${var.region}-docker.pkg.dev"
}

output "artifact_registry_image_base" {
  description = "Base image path to push from CI/CD"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}/${var.image_name}"
}

output "get_credentials_command" {
  description = "Command to fetch kubeconfig locally"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}
