# DevOps 교육용 실습 레포 (GCE + k3s)

Flask 앱을 GCE VM 1대 위에 k3s로 배포하는 교육용 레포입니다.

## 1) 구성

- 앱: `app.py`
- CI: `.github/workflows/flask_ci.yml`
- 보안 스캔: `.github/workflows/security.yml`
- DAST: `.github/workflows/dast.yml`
- 인프라(Terraform): `infra/terraform/gce_k3s`
- 배포(Ansible): `ansible/playbooks/deploy-gce-k3s.yml`
- CD: `.github/workflows/cd.yml`
- 인프라 워크플로우: `.github/workflows/infra_terraform.yml`

## 2) GitHub Variables

- `GCP_PROJECT_ID` (또는 Secret로 등록 가능)
- `GCE_REGION` (선택, 기본 `us-central1`)
- `GCE_ZONE` (선택, 기본 `us-central1-a`)
- `APP_NAME` (선택, 기본 `flask-app`)
- `K8S_NAMESPACE` (선택, 기본 `flask-app`)
- `REPLICAS` (선택, 기본 `2`)
- `SERVICE_TYPE` (선택, 기본 `NodePort`)
- `K3S_NODE_PORT` (선택, 기본 `30080`)

## 3) GitHub Secrets

- `GCP_WORKLOAD_IDENTITY_PROVIDER` (Terraform 자동화 시)
- `GCP_SERVICE_ACCOUNT` (Terraform 자동화 시)
- `GCP_HOST` (Terraform apply 후 VM 외부 IP)
- `GCP_USER` (예: `ubuntu`)
- `GCP_SSH_KEY` (CD SSH 접속 + Terraform용 공개키 자동 파생)
- `REMOTE_APP_DIR` (선택, 레거시 변수)
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `DOMAIN` (DAST 타깃 도메인)

## 4) 실행 순서

### Step A. 인프라 생성

1. `Actions > Infra - Terraform for GCE k3s` 실행
2. `action=plan` 후 `action=apply` 실행
3. 생성된 외부 IP를 `GCP_HOST` Secret(또는 Variable)에 설정

### Step B. 앱 배포

1. `Actions > CD - Build & Deploy to GCE k3s` 실행
2. 성공 후 접속: `http://<GCP_HOST>:30080`

### Step C. 검증

- `security.yml` 결과 확인
- CD 성공 후 `dast.yml` 결과 확인

## 5) 수동 배포(로컬에서 직접)

```bash
cp ansible/inventory/gce_k3s.ini.example ansible/inventory/gce_k3s.ini

# ansible/inventory/gce_k3s.ini 예시
# [k3s_nodes]
# <GCE_IP> ansible_user=ubuntu

IMAGE_REF="<dockerhub-user>/flask-app:<tag>" \
K3S_NODE_PORT=30080 \
ANSIBLE_CONFIG=ansible/ansible.cfg \
ansible-playbook -i ansible/inventory/gce_k3s.ini ansible/playbooks/deploy-gce-k3s.yml

```
