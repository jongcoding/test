# DevOps 교육용 실습 레포 (Terraform + Ansible + GKE + GitHub Actions)

이 레포는 Flask 앱을 대상으로, 아래 4가지를 한 번에 실습하도록 구성했습니다.

- Terraform으로 GKE/Artifact Registry 인프라 생성
- Ansible로 Kubernetes 배포 자동화
- GitHub Actions로 이미지 빌드/배포 파이프라인 실행
- 기본 CI/Security/DAST 워크플로우 확인

## 1) 현재 구성

- 앱: `app.py` (Flask)
- 로컬 실행: `docker-compose.yml`
- 인프라 코드: `infra/terraform/gke`
- 배포 코드: `ansible/playbooks/deploy-gke.yml`
- CD 파이프라인: `.github/workflows/cd.yml` (GKE 배포)
- 인프라 파이프라인: `.github/workflows/infra_terraform.yml`

## 2) 디렉터리 구조

```text
.
├── .github/workflows
│   ├── flask_ci.yml
│   ├── security.yml
│   ├── cd.yml
│   ├── infra_terraform.yml
│   └── dast.yml
├── ansible
│   ├── ansible.cfg
│   ├── inventory/hosts.ini
│   ├── manifests/*.yaml.j2
│   └── playbooks/deploy-gke.yml
├── infra/terraform/gke
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── versions.tf
│   └── terraform.tfvars.example
└── app.py
```

## 3) 사전 준비

- GCP 프로젝트 1개
- `gcloud`, `kubectl`, `terraform` 설치
- GitHub 저장소의 Actions 활성화
- Workload Identity Federation (GitHub OIDC)로 GCP 인증 구성

## 4) GitHub 설정값

### Variables

- `GCP_PROJECT_ID`: GCP 프로젝트 ID
- `GCP_REGION`: Terraform에서 사용할 리전 (예: `us-central1`, `us-central1-a` 같은 zone 값 사용 금지)
- `GAR_LOCATION`: Artifact Registry 리전 (예: `us-central1`)
- `GAR_REPOSITORY`: Artifact Registry 저장소 이름 (예: `edu-flask-repo`)
- `GKE_CLUSTER_NAME`: Terraform으로 만든 클러스터 이름 (예: `edu-gke-cluster`)
- `GKE_LOCATION`: GKE 리전 (예: `us-central1`)
- `APP_NAME` (선택): 기본값 `flask-app`
- `K8S_NAMESPACE` (선택): 기본값 `flask-app`
- `REPLICAS` (선택): 기본값 `2`
- `SERVICE_TYPE` (선택): 기본값 `LoadBalancer`

### Secrets

- `GCP_WORKLOAD_IDENTITY_PROVIDER`: WIF Provider 리소스 경로
- `GCP_SERVICE_ACCOUNT`: Actions가 사용할 GCP 서비스 계정 이메일

### 서비스 계정 권한(교육용 최소 예시)

- Terraform 실행용: `roles/container.admin`, `roles/compute.networkAdmin`, `roles/artifactregistry.admin`, `roles/serviceusage.serviceUsageAdmin`
- 배포 실행용: `roles/container.developer`, `roles/artifactregistry.writer`

## 5) 실습 순서 (입문자 권장)

### Step A. 로컬 앱 확인

```bash
docker compose up -d --build
curl http://localhost:5000
```

### Step B. Terraform으로 인프라 생성

```bash
cd infra/terraform/gke
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars에서 project_id 수정
terraform init
terraform plan
terraform apply
```

### Step C. 로컬에서 Ansible 배포 테스트

```bash
# kubeconfig 연결
gcloud container clusters get-credentials edu-gke-cluster --region us-central1 --project <PROJECT_ID>

# 컬렉션/의존성
ansible-galaxy collection install -r ansible/requirements.yml
python3 -m pip install ansible-core kubernetes

# 배포
IMAGE_REF="us-central1-docker.pkg.dev/<PROJECT_ID>/edu-flask-repo/flask-app:manual" \
ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook ansible/playbooks/deploy-gke.yml
```

### Step D. GitHub Actions 자동화

1. `infra_terraform.yml`을 수동 실행해 `plan/apply/destroy` 실습
2. `main` 브랜치에 push하면 `cd.yml`이 이미지 빌드 후 GKE 배포
3. `security.yml`, `dast.yml` 결과를 Security 탭/Artifacts에서 확인

## 6) 교육 포인트

- 인프라와 애플리케이션 배포 파이프라인 분리
- 선언형 코드(Terraform/Ansible/Jinja2) 기반 반복 배포
- GitHub OIDC로 장기 키 없이 GCP 인증
- CI/CD + 보안 스캔 연계

## 7) 참고

- 기존 GCE VM 중심 CD는 GKE 기반 CD로 전환되어 있습니다.
- DAST 워크플로우는 새 CD 이름(`CD - Build & Deploy to GKE (Ansible)`)을 추적합니다.
