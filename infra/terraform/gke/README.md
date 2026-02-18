# Terraform: GKE + Artifact Registry

이 디렉터리는 교육용으로 아래 리소스를 만듭니다.

- VPC/Subnet (GKE 전용)
- GKE Standard Cluster + Node Pool
- Artifact Registry (Docker)

## 1) 사전 준비

- `gcloud auth application-default login`
- `gcloud config set project <PROJECT_ID>`
- Terraform 1.6+

## 2) 변수 파일 준비

```bash
cd infra/terraform/gke
cp terraform.tfvars.example terraform.tfvars
```

`terraform.tfvars`에서 `project_id`를 반드시 수정하세요.

## 3) 실행

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## 4) 출력 확인

```bash
terraform output artifact_registry_image_base
terraform output get_credentials_command
```

출력된 `get_credentials_command`를 실행하면 로컬 `kubectl`이 클러스터에 연결됩니다.
