# kickstart.nvim

설치 전에 먼저 `https://github.com/nvim-lua/kickstart.nvim`의 README를 읽고 참고하라.

### nvim 설치

- [ ] nvim이 설치되어 있는지 확인하고, 없거나 버전이 낮으면 설치한다.
  - 판정 기준: `nvim --version`이 동작하고 **0.10.0 이상**이면 충족으로 본다. (kickstart.nvim이 요구하는 최소 버전)
  - Linux에서 배포판 패키지 매니저(apt 등)의 nvim은 대개 구버전이라 이 기준에 미달한다. 미달하면 패키지 매니저 대신 **공식 릴리스 바이너리(AppImage 또는 tar.gz)** 로 설치한다.
  - macOS는 AGENTS.md 지침에 따라 `brew install neovim`을 쓴다.
  - 설치 방식이 둘 이상 가능하면 실행 전에 어느 쪽으로 할지 사용자에게 보고하고 허락을 구한다.

### nvim 별칭 설정

- [ ] `vim`을 `nvim`으로 실행하는 별칭 추가
  - **사용 중인 셸**의 rc 파일에 추가한다. 셸은 `echo $SHELL` 또는 `ps -p $$ -o comm=`로 확인한다.
    zsh는 `~/.zshrc`, bash는 `~/.bashrc`(macOS는 `~/.bash_profile`), fish는 `~/.config/fish/config.fish`.
  - 판정 기준: 새 셸에서 `vim`이 nvim으로 실행되면 충족.
- [ ] `EDITOR` 환경변수를 nvim으로 설정
  - 같은 rc 파일에 추가한다. sh 계열은 `export EDITOR=nvim`, fish는 `set -gx EDITOR nvim`.
  - 판정 기준: 새 셸에서 `echo $EDITOR`가 nvim을 가리키면 충족.
- [ ] git `core.editor`를 nvim으로 설정
  - 판정 기준: `git config --get core.editor`가 nvim을 가리키면 충족.

### 필요한(의존) 것들 설치

- [ ] Basic utils: git, make, unzip, C Compiler(gcc). 각각 설치되어 있는지 먼저 확인하고, 없는 것만 설치한다.
  - 판정 기준: `git --version`, `make --version`, `unzip -v`, `gcc --version`이 모두 동작하면 충족.
- [ ] ripgrep 설치
  - 판정 기준: `rg --version`이 동작하면 충족.
- [ ] fd-find 설치
  - 판정 기준: `fd --version` 또는 `fdfind --version`이 동작하면 충족. 배포판에 따라 실행 파일 이름이 `fdfind`이므로, 그런 경우 `fd`로 쓸 수 있게 심볼릭 링크를 만들어 준다.
- [ ] tree-sitter CLI 설치: `https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md#installation` 참고
  - 판정 기준: `tree-sitter --version`이 동작하면 충족.
  - 설치 경로가 여러 개(npm / cargo / 릴리스 바이너리)이므로, 이 머신에 이미 있는 도구를 우선으로 하나 골라 사용자에게 보고하고 허락을 구한다.
- [ ] Clipboard tool 설치 (플랫폼에 맞는 것: Linux는 xclip 또는 xsel, WSL은 win32yank, macOS는 pbcopy 내장)
  - 판정 기준: 해당 플랫폼의 클립보드 도구가 `nvim`에서 인식되면 충족. `nvim --headless "+checkhealth provider" +qa`로 확인할 수 있다.
  - **디스플레이가 없는 헤드리스 환경(SSH 접속, 컨테이너 등)이면** xclip/xsel을 깔아도 동작하지 않는다. 이 경우 설치를 강행하지 말고, 그 사실과 대안(터미널 OSC52 방식)을 사용자에게 보고한 뒤 어떻게 할지 물어본다.

### kickstart.nvim 설치

kickstart.nvim은 **사용자 계정으로 포크한 저장소**를 쓴다. 설정을 직접 고쳐 나가는 것이
kickstart의 사용법이므로, 원본을 그대로 clone하지 않는다.

- [ ] 사용자 GitHub 계정에 kickstart.nvim 포크 확보
  - 판정 기준: `gh repo list --fork --json name,parent` 결과에 부모가 `nvim-lua/kickstart.nvim`인 저장소가 있으면 충족. 계정명이 필요하면 `gh api user --jq .login`으로 알아낸다.
  - 포크 여부는 저장소 **이름이 아니라 fork 관계**로 판단한다. 포크할 때 이름을 바꿨을 수 있으므로 이름만 보고 없다고 단정하지 말 것.
  - 없으면 `https://github.com/nvim-lua/kickstart.nvim`을 사용자 계정으로 포크한 뒤 다시 확인한다.
- [ ] 포크한 저장소를 nvim 설정 경로에 clone
  - 설정 경로는 `${XDG_CONFIG_HOME:-$HOME/.config}/nvim`이다. `nvim --headless -c 'echo stdpath("config")' -c q`로도 확인할 수 있다.
  - 판정 기준: 그 경로가 위 포크 저장소의 작업 트리이고(`git -C <경로> remote get-url origin`), `init.lua`가 있으면 충족.
  - **이미 다른 nvim 설정이 있으면 덮어쓰지 않는다.** 그 사실을 사용자에게 보고하고, 백업(예: `nvim.bak`으로 이동) 후 진행할지 물어본다.
  - clone URL은 이 머신의 인증 상태에 맞춘다. SSH 키가 GitHub에 등록돼 있으면 SSH를, 아니면 `gh repo clone`을 쓴다.
- [ ] 첫 실행으로 플러그인 설치 완료
  - 판정 기준: `nvim --headless "+Lazy! sync" +qa`가 오류 없이 끝나고, `nvim --headless "+checkhealth" +qa`에 치명적 오류가 없으면 충족.
  - 이 단계는 네트워크에서 플러그인과 LSP 서버를 내려받으므로 시간이 걸릴 수 있다.
  - checkhealth 경고 중 이미 다른 항목에서 다루는 것(클립보드 등)은 여기서 다시 조치하지 않는다.

### kickstart.nvim 머신별 설정 브랜치

kickstart는 설정을 직접 고쳐 나가는 것이 사용법이라, 머신마다 설정이 갈라진다.
머신에 공통으로 적용할 것은 기본 브랜치에, 그 머신에만 해당하는 것은 별도 브랜치에 둔다.
nvim 설정 경로는 `nvim --headless -c 'echo stdpath("config")' -c q`로 확인한다.

- [ ] 머신 공통 설정 변경을 포크의 기본 브랜치에 커밋하고 원격에 push
  - 기본 브랜치 이름은 `git symbolic-ref --short refs/remotes/origin/HEAD`로 알아낸다.
  - 판정 기준: 작업 트리에 커밋 안 된 설정 변경이 없고, 기본 브랜치가 `origin`의 같은 이름 브랜치와 같은 커밋이면 충족.
  - 어떤 변경이 공통이고 어떤 것이 이 머신 전용인지 애매하면 커밋하기 전에 사용자에게 묻는다.
- [ ] 이 머신 전용 설정 브랜치를 만들고 체크아웃
  - 브랜치 이름은 머신마다 다르므로 명세에 박지 않는다. `<your branch name>`을 **만들기 전에 사용자에게 물어본다.**
  - 기본 브랜치에서 갈라 나온다.
  - 판정 기준: `git branch --show-current`가 그 브랜치를 가리키면 충족. 이미 있으면 새로 만들지 않고 체크아웃만 한다.

### nvim 컬러스킴을 rose-pine으로 변경

`https://github.com/rose-pine/neovim` 참고.

kickstart 본체(`init.lua`)의 기본 컬러스킴 블록은 건드리지 않는다. 대신 kickstart가 마련해 둔
확장 지점인 `lua/custom/plugins/`에 파일을 따로 만들어 덮어쓴다. 이 디렉터리의 `.lua` 파일은
`custom/plugins/init.lua`가 자동으로 로드하고, 그 시점이 기본 컬러스킴 호출보다 뒤이므로
별도 조치 없이 우선 적용된다. upstream kickstart와 병합할 때 충돌을 피하려는 것이다.

- [ ] `lua/custom/plugins/` 자동 로드 활성화
  - `init.lua` 맨 끝의 `require 'custom.plugins'` 한 줄이 주석 처리돼 있으면 푼다.
  - 판정 기준: 그 줄이 주석 해제된 채 실행되면 충족.
- [ ] rose-pine 테마를 `lua/custom/plugins/` 아래 별도 파일에 설정
  - 변형(variant)은 취향이므로 `<your variant>`로 두고 사용자에게 물어본다. `main` / `moon` / `dawn` / `auto` 중 하나.
  - 이 저장소는 이름이 `rose-pine/neovim`이라, `vim.pack.add`에 `name = 'rose-pine'`을 지정하지 않으면
    플러그인 디렉터리가 `neovim`이 되어 `require 'rose-pine'`이 실패한다.
  - 옵션은 `colorscheme` 호출 **전에** `setup`으로 넘긴다.
  - 판정 기준: `nvim --headless -c 'lua print(vim.g.colors_name)' -c q`가 rose-pine 계열 이름을 출력하면 충족.
- [ ] 커서라인 배경을 본문 배경보다 어둡게 조정
  - rose-pine 기본 `CursorLine`은 본문 배경보다 **밝은** overlay 색이라, 어둡게 하려면 덮어써야 한다.
    `setup`의 `highlight_groups`에 `CursorLine`을 넣으면 된다.
  - 어두운 정도는 취향이므로 `<your cursorline bg>`로 두고 사용자에게 물어본다.
    본문 배경 hex를 기준으로 몇 단계(예: 10% / 20% / 팔레트 내 더 어두운 base)를 제시해 고르게 한다.
  - 판정 기준: `nvim --headless`로 `CursorLine`의 bg가 `Normal`의 bg보다 어두우면 충족.

### nvim 파이썬 개발 환경

타입 검사는 pyright 계열 LSP가, lint·포맷·import 정렬은 ruff가 맡도록 역할을 나눈다.
ruff 하나가 flake8/isort/black을 대체하므로 그 셋은 설치하지 않는다.
`https://docs.astral.sh/ruff/editors/` 참고.

kickstart는 LSP를 `servers` 테이블에, 포매터를 conform의 `formatters_by_ft`에 적도록
자리를 마련해 두었다. 두 곳 모두 주석 처리된 예시가 있으므로 그 자리를 쓴다.
mason이 `servers` 테이블의 항목을 자동 설치하므로 별도 설치 명령은 필요 없다.

- [ ] 파이썬 타입체커 LSP 활성화
  - `pyright`와 `basedpyright` 중 `<your python type checker>`를 사용자에게 물어 고른다.
    basedpyright는 인레이 힌트·시맨틱 하이라이트 등 Pylance 전용 기능을 오픈소스로 포함한다.
  - 둘 중 하나만 켠다. 같이 켜면 진단이 중복된다.
  - 판정 기준: 파이썬 파일을 열었을 때 `:checkhealth vim.lsp` 또는 `vim.lsp.get_clients`에
    그 서버가 붙으면 충족.
- [ ] ruff LSP 활성화
  - 판정 기준: 파이썬 파일에 `ruff` 클라이언트가 붙으면 충족.
  - 타입체커와 hover가 겹치므로 ruff 쪽 hover는 끈다.
- [ ] conform 포매터를 ruff로 설정
  - import 정렬 후 포맷 순서로 이어서 실행한다.
  - 저장 시 자동 포맷 여부는 취향이므로 `<your format on save>`를 사용자에게 물어본다.
  - 판정 기준: 파이썬 버퍼에서 포맷 키맵이 ruff로 동작하면 충족.

### nvim 가상환경 선택기

프로젝트의 `.venv`를 골라 LSP를 그 인터프리터로 다시 붙여 준다. 이게 없으면 가상환경에
설치한 패키지를 타입체커가 찾지 못해 import마다 진단이 뜬다.
`https://github.com/linux-cultist/venv-selector.nvim` 참고.

- [ ] venv-selector 설치 및 설정
  - kickstart 본체가 마련한 자리가 없는 새 플러그인이므로 `lua/custom/plugins/` 아래 파일로 둔다.
  - 요구사항: nvim 0.11 이상, `fd`(또는 `fdfind`), 피커 플러그인(telescope 등). 설치 전에 확인한다.
  - 예전 `regexp` 브랜치는 `main`에 병합됐다. 브랜치를 따로 지정하지 않는다.
  - 키맵은 취향이므로 `<your keymap>`을 사용자에게 물어본다.
  - 판정 기준: 파이썬 파일에서 `:VenvSelect`가 존재하고, 고른 가상환경의 python이
    LSP 설정에 반영되면 충족.