# 필수(공통) 환경 세팅 목록

### OS 업데이트

- [ ] OS 업데이트 (Mac, Windows 제외)

### 시스템 시간대 설정

- [x] 이 머신에 맞는 시간대를 에이전트가 추론해 추천하고, 사용자에게 확인받는다.
  - 추론에 쓸 수 있는 단서: 현재 설정된 시간대(`timedatectl` 또는 `readlink -f /etc/localtime`),
    로케일(`locale`), 사용자가 대화에서 쓰는 언어.
  - 추천 하나만 내밀지 말고, 추천값을 맨 앞에 두고 후보 몇 개를 함께 보여준 뒤 고르게 한다.
    후보 목록은 `timedatectl list-timezones`에서 가져온다.
  - 추론의 근거와 한계를 함께 말한다. 특히 **헤드리스/원격 머신의 시간대는 사용자가 실제로
    있는 곳이 아닐 수 있으므로**, 추측임을 밝히고 사용자 확인 없이 단정하지 않는다.
  - 판정 기준: 사용자가 원하는 시간대를 확인해 주면 충족.
- [x] 사용자가 확인한 시간대로 설정한다.
  - 판정 기준: `timedatectl`(또는 `readlink -f /etc/localtime`)이 그 시간대를 가리키면 충족.
    이미 그 값이면 변경하지 않는다.

### git 설치

- [ ] git 설치
- [ ] git config 설정
  ```
  [user]
          name = <your name>
          email = <your email>
  [color]
          ui = auto
  [core]
          editor = <your editor>
  [pull]
          rebase = true
  [init]
          defaultBranch = main
  [push]
          recurseSubmodules = on-demand
  ```
- [ ] git config 설정이 잘 작동하는지 확인

### GitHub CLI 설치

- [ ] gh (GitHub CLI) 설치
- [ ] gh auth login (GitHub 계정 인증): 사용자가 직접 로그인 하도록하라. 로그인 했는지 확인해라.

### SSH Key 생성 및 등록

- [ ] `SSH key` 준비 및 `GitHub` 등록
1. 이 환경(`~/.ssh`)에 SSH 키가 있는지 확인한다.
2. 없으면 `ed25519` 방식으로 새로 생성한다.
3. `gh`로 이 키(공개키)가 이미 `GitHub` 계정에 등록되어 있는지 확인한다.
4. 등록되어 있지 않으면 `gh`로 `GitHub` 계정에 등록한다: 키 이름은 사용자가 직접 정하게하라.

- [ ] `SSH key`로 `git clone` 동작 테스트
1. `ssh -T git@github.com`으로 SSH 인증이 되는지 확인한다.

### zsh 설치

- [ ] `zsh` 설치
- [ ] `zsh`를 기본 셸로 전환
- [ ] 현재 `shell`을 `zsh`로 전환
- [ ] `Powerlevel10k` 설치 및 설정 (`https://github.com/romkatv/powerlevel10k` 참고)

### oh-my-zsh 설치

- [ ] `oh-my-zsh` 설치 (`https://github.com/ohmyzsh/ohmyzsh` 참고)
- 기본 플러그인 추가
  - [ ] `git` — git 별칭/상태 정보
  - [ ] `z` — 자주 쓰는 디렉토리로 빠르게 이동
- 커뮤니티 플러그인 추가 및 설치
  - [ ] `zsh-autosuggestions` — 이전 입력 기록 기반으로 자동완성 제안, 오른쪽 화살표로 수락
  - [ ] `zsh-syntax-highlighting` — 명령어 유효성에 따라 실시간 색상 표시(빨강=오류, 초록=정상)
