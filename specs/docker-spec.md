# Docker

## macOS

해당 OS(macOS)가 아니면 이 절의 항목은 모두 충족으로 본다.

- 공식 문서(Docker Desktop): https://docs.docker.com/desktop/setup/install/mac-install/

- [ ] Docker Desktop 설치
  - 방법: `brew install --cask docker-desktop`
  - 판정 기준: `docker --version`이 동작하면 충족.
- [ ] Docker 엔진 동작 확인
  - Docker Desktop 앱을 처음 실행하면 약관 동의 등 GUI 초기 설정이 필요하므로 사용자가 직접 실행한다.
  - 판정 기준: `docker run --rm hello-world`가 성공하면 충족.

## Linux

해당 OS(Linux)가 아니면 이 절의 항목은 모두 충족으로 본다.

- 공식 문서(Docker Engine): https://docs.docker.com/engine/install/
- 설치 후 설정: https://docs.docker.com/engine/install/linux-postinstall/

- [ ] Docker Engine 설치
  - 방법: 공식 문서의 배포판별 절차대로 Docker 공식 저장소(apt/dnf)에서 설치한다. 배포판 기본 패키지(`docker.io` 등)는 구버전일 수 있어 쓰지 않는다.
  - Docker Desktop for Linux는 GUI와 KVM(`/dev/kvm`)이 필요하므로 쓰지 않는다.
  - 판정 기준: `docker --version`이 동작하면 충족.
- [ ] 재부팅 후 Docker 서비스 자동 시작
  - 판정 기준: `systemctl is-enabled docker`가 `enabled`이고 `systemctl is-active docker`가 `active`면 충족.
- [ ] sudo 없이 docker 실행
  - root 계정이면 해당 없음 → 충족으로 본다.
  - 방법: `sudo usermod -aG docker $USER` 후 다시 로그인.
  - 주의: `docker` 그룹은 사실상 root 권한이다. 실행 전에 이 점을 사용자에게 알리고, 대안(rootless 모드)과 함께 묻는다.
  - 판정 기준: sudo 없이 `docker info`가 성공하면 충족.
- [ ] Docker 엔진 동작 확인
  - 판정 기준: `docker run --rm hello-world`가 성공하면 충족.
