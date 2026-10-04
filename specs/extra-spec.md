# extra

### uv 설치

Python 패키지·프로젝트 매니저. `https://docs.astral.sh/uv/` 참고.

- [ ] uv 설치
  - 판정 기준: `uv --version`이 동작하면 충족.
  - 설치 방법은 여러 가지(공식 standalone 설치 스크립트, 배포판 패키지 매니저, pipx 등)이므로
    실행 시점에 사용자에게 물어 고르게 한다.
  - 설치 경로가 셸 `PATH`에 들어 있는지 확인하고, 없으면 rc 파일에 추가할지 사용자에게 묻는다.

### Node.js 설치

`https://nodejs.org/` 참고.

- [ ] Node 버전 매니저 설치
  - 판정 기준: 버전 매니저 명령(예: `fnm --version`)이 동작하면 충족.
  - 설치 방법(버전 매니저 / 배포판 패키지 / 공식 바이너리)은 실행 시점에 사용자에게 물어 고르게 한다.
    프로젝트마다 Node 버전이 갈릴 수 있으면 버전 매니저 쪽이 낫다는 점을 함께 알린다.
- [ ] 셸 rc 파일에 버전 매니저 초기화 구문 추가
  - 판정 기준: 새 로그인 셸에서 버전 매니저 명령과 `node`가 바로 잡히면 충족.
  - 디렉터리 이동 시 `.nvmrc`/`.node-version`을 따라가게 하려면 그 옵션도 함께 켠다(fnm의 `--use-on-cd`).
- [ ] Node.js LTS 설치 및 기본 버전으로 지정
  - 판정 기준: `node --version`과 `npm --version`이 동작하고 LTS 계열이면 충족.

### herdr 설치

- [ ] herdr 설치: 코딩 에이전트용 터미널 멀티플렉서. 설치 전에 `https://github.com/herdrdev/herdr`의 README와 `https://herdr.dev/docs/`를 읽고 참고하라.

### Tailscale 설치

메시 VPN. `https://tailscale.com/kb/1031/install-linux` 참고.

- [ ] tailscale 설치
  - 판정 기준: `tailscale version`이 동작하면 충족.
  - 설치 방법(공식 `install.sh`, 배포판 패키지 저장소, static 바이너리)은 실행 시점에 사용자에게
    물어 고르게 한다. macOS는 AGENTS.md 지침에 따라 `brew`를 쓴다.
- [ ] 계정 로그인
  - 판정 기준: `tailscale status`가 로그인된 상태로 자기 노드를 보여주면 충족.
  - **로그인은 사용자가 직접 한다.** `sudo tailscale up`이 출력하는 인증 URL을 사용자가
    브라우저에서 열어 승인하게 하고, 에이전트는 로그인됐는지만 확인한다.
  - 인증키(`--auth-key`)를 에이전트에게 넘기지 않는다. 키는 비밀값이다.
- [ ] GUI 없는 머신이면 재부팅 후에도 자동으로 서비스되게 설정
  - GUI 여부는 `DISPLAY`/`WAYLAND_DISPLAY`와 설치된 세션 목록(`/usr/share/xsessions`)으로 판단한다.
  - 판정 기준: `systemctl is-enabled tailscaled`가 `enabled`, `is-active`가 `active`면 충족.
  - systemd가 없는 환경(일부 컨테이너 등)이면 강행하지 말고 그 사실과 대안을 보고한 뒤 물어본다.