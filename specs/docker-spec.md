# Docker

### Docker

- 공식 문서: https://docs.docker.com/desktop/setup/install/mac-install/

- [ ] Docker Desktop 설치
  - macOS: `brew install --cask docker-desktop`
  - 판정 기준: `docker --version`이 동작하면 충족.
- [ ] Docker 엔진 동작 확인
  - Docker Desktop 앱을 처음 실행하면 약관 동의 등 GUI 초기 설정이 필요하므로 사용자가 직접 실행한다.
  - 판정 기준: `docker run --rm hello-world`가 성공하면 충족.