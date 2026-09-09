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
