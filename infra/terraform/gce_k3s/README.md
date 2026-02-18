# Terraform: GCE VM for k3s

이 디렉터리는 교육용으로 아래 리소스를 만듭니다.

- VPC/Subnet
- Firewall (SSH + HTTP/HTTPS + NodePort 30000-32767)
- Static External IP
- Ubuntu VM 1대 (k3s 설치 대상)

## 1) 사전 준비

- `gcloud auth application-default login`
- `gcloud config set project <PROJECT_ID>`
- Terraform 1.6+
- SSH 공개키 1개

## 2) 변수 파일 준비

```bash
cd infra/terraform/gce_k3s
cp terraform.tfvars.example terraform.tfvars
```

`terraform.tfvars`에서 최소 `project_id`, `ssh_public_key`를 수정하세요.

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
terraform output external_ip
terraform output ssh_command
terraform output ansible_inventory_line
```

출력된 `ansible_inventory_line`을 `ansible/inventory/gce_k3s.ini`에 넣어 Ansible 배포에 사용합니다.
