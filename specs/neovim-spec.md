# kickstart.nvim

설치 전에 먼저 `https://github.com/nvim-lua/kickstart.nvim`의 README를 읽고 참고하라.

### nvim 설치

- [ ] nvim이 설치되어 있는지 확인하고, 없거나 버전이 낮으면 설치한다.
  - 판정 기준: `nvim --version`이 동작하고 **0.10.0 이상**이면 충족으로 본다. (kickstart.nvim이 요구하는 최소 버전)
  - Linux에서 배포판 패키지 매니저(apt 등)의 nvim은 대개 구버전이라 이 기준에 미달한다. 미달하면 패키지 매니저 대신 **공식 릴리스 바이너리(AppImage 또는 tar.gz)** 로 설치한다.
  - macOS는 AGENTS.md 지침에 따라 `brew install neovim`을 쓴다.
  - 설치 방식이 둘 이상 가능하면 실행 전에 어느 쪽으로 할지 사용자에게 보고하고 허락을 구한다.


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
