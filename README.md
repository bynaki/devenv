# devenv — 명세로 관리하는 개발환경

AI 코딩 에이전트가 개발환경을 대신 세팅해 주는 프로젝트입니다.

설치 스크립트를 직접 작성하고 유지보수하는 대신, 이 저장소에는 "어떤 개발환경을
원하는가"를 사람이 읽을 수 있는 명세로 적어 둡니다. 실제 설치와 설정은 Claude
Code CLI 또는 Codex CLI 같은 에이전트가 담당합니다. 에이전트는 이 명세를 읽고,
현재 머신의 상태를 확인한 뒤, 아직 충족되지 않은 부분만 골라서 수행합니다.

덕분에 얻는 이점:

- OS나 패키지 매니저가 달라도 분기 처리를 일일이 코딩할 필요가 없습니다.
- 새 장비에서도 명령 한 번으로 같은 개발환경을 재현할 수 있습니다.

## 목차

- [용어 정리](#용어-정리)
- [명세 문서 형식](#명세-문서-형식)
- [사전 준비](#사전-준비)
- [시작하기](#시작하기)
- [라이선스](#라이선스)

## 용어 정리

| 용어 | 설명 |
| --- | --- |
| 명세 | 환경 세팅을 명시한 문서입니다. |
| 명세 폴더 (`specs`) | 명세 파일이 모여있는 폴더입니다. **읽기 전용**이며 수정·생성·삭제하지 않습니다. |
| 활성 명세 | 명세 파일의 복사본으로, 에이전트는 이 파일을 바탕으로 작업합니다. |
| 활성 명세 폴더 (`active-specs`) | 활성 명세 파일들을 모아놓은 폴더입니다. 에이전트가 수정할 수 있는 유일한 폴더입니다. |

> 에이전트는 `specs` 폴더의 명세를 **읽기만** 하고 실행하지 않습니다. 실제로
> 실행되는 대상은 `active-specs` 폴더 안의 명세뿐입니다.

## 명세 문서 형식

```markdown
# 명세 제목
이 명세 문서 설명

### git 설치
- [ ] git 설치
- [ ] git config 설정
```

- 각 항목은 `- [ ]`(미완료) / `- [x]`(완료 또는 건너뜀) 체크리스트로 표기합니다.
- 항목 실행이 끝나면 에이전트가 `[ ]`를 `[x]`로 바꿔 완료를 표시합니다.

## 사전 준비

### git 설치

이 저장소를 포크하고 클론하려면 git이 먼저 필요합니다.

```bash
# Linux: Debian / Ubuntu (APT)
sudo apt update && sudo apt install git

# Linux: Fedora / RHEL / CentOS (DNF)
sudo dnf install git

# Linux: Arch Linux
sudo pacman -S git

# macOS (Homebrew 권장)
brew install git
# 또는 Xcode Command Line Tools
xcode-select --install

# WSL (내부적으로 Linux 배포판이므로 위 Linux 명령과 동일, 대부분 Ubuntu)
sudo apt update && sudo apt install git
```

```powershell
# Windows (WinGet)
winget install --id Git.Git -e --source winget

# 또는 Chocolatey
choco install git
```

또는 [git-scm.com](https://git-scm.com/download/win)에서 공식 인스톨러(Git for
Windows)를 받아 실행해도 됩니다.

설치 후 확인:

```bash
git --version
```

### 에이전트 CLI 설치

이 저장소를 쓰려면 명세를 실행해 줄 에이전트 CLI가 최소 하나는 필요합니다.
Claude Code와 Codex 중 편한 쪽을 고르면 되고, 둘 다 설치해도 됩니다.

#### Claude Code CLI

공식 설치 스크립트를 사용하는 방식이 권장됩니다. 설치본이 백그라운드에서 자동
업데이트됩니다.

```bash
# macOS / Linux / WSL
curl -fsSL https://claude.ai/install.sh | bash
```

```powershell
# Windows PowerShell
irm https://claude.ai/install.ps1 | iex
```

패키지 매니저를 선호한다면 아래 방법도 있습니다. 단, 이 경로들은 자동 업데이트가
되지 않으므로 직접 업그레이드해야 합니다.

```bash
brew install --cask claude-code        # macOS (Homebrew)
winget install Anthropic.ClaudeCode    # Windows (WinGet)
npm install -g @anthropic-ai/claude-code   # Node.js 22+ 필요
```

설치 후 확인과 실행:

```bash
claude --version   # 버전이 찍히면 정상
claude doctor      # 설치·설정 상태 진단
claude             # 대화형 세션 시작
```

처음 `claude`를 실행하면 브라우저가 열리며 로그인을 진행합니다.

- Pro, Max, Team, Enterprise 또는 Console 계정이 필요하며 무료 플랜에서는 쓸 수
  없습니다.
- 시스템 요구사항: macOS 13+, Windows 10 1809+, Ubuntu 20.04+ / Debian 10+ /
  Alpine 3.19+, RAM 4GB 이상.

#### Codex CLI

```bash
# macOS / Linux
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

```powershell
# Windows PowerShell
powershell -ExecutionPolicy ByPass -c "irm https://chatgpt.com/codex/install.ps1 | iex"
```

패키지 매니저로 설치하려면:

```bash
brew install --cask codex   # macOS (Homebrew)
npm install -g @openai/codex
```

설치 후 프로젝트 디렉토리에서 실행합니다:

```bash
codex
```

첫 실행에서 **Sign in with ChatGPT**를 선택해 로그인합니다. ChatGPT Plus, Pro,
Business, Edu, Enterprise 플랜에서 사용할 수 있고, API 키로 인증하는 방법도
있습니다.

## 시작하기

### 1. 저장소 포크

환경 명세는 사람마다 다릅니다. 원본 저장소를 직접 클론하지 말고, **먼저 자신의
계정으로 포크**한 뒤 그 포크를 각자의 환경에 맞게 고쳐 나가세요.

[GitHub 웹에서 Fork 버튼](https://github.com/bynaki/devenv/fork)을 눌러도 되고,
`gh` CLI가 있다면 다음 한 줄이면 됩니다.

```bash
gh repo fork bynaki/devenv --clone=false
```

### 2. 개발환경에 클론

포크한 저장소를 개발환경으로 클론합니다. `<your-username>`은 자신의 GitHub
계정으로 바꾸세요.

```bash
git clone https://github.com/<your-username>/devenv.git ~/devenv
cd ~/devenv
```

원본 저장소를 `upstream`으로 등록해 두면 이후 개선 사항을 가져올 수 있습니다.

```bash
git remote add upstream https://github.com/bynaki/devenv.git
git fetch upstream
```

나중에 원본의 변경을 반영할 때:

```bash
git fetch upstream && git merge upstream/main
```

### 3. 활성 명세 폴더로 복사

클론한 디렉토리로 이동합니다.

```shell
cd ~/devenv
```

`active-specs` 이름으로 활성 폴더를 만듭니다.

```shell
mkdir active-specs
```

`specs` 명세 폴더 안에 있는, 세팅하고 싶은 명세 파일을 `active-specs` 폴더로
복사합니다.

```shell
cp specs/esential-spec.md active-specs  # 예
```

복사한 명세 안에서 실행하고 싶지 않은 항목이 있다면 미리 `[x]`로 체크해 두세요.
에이전트는 이미 `[x]`인 항목을 건드리지 않고 넘어갑니다.

```md
### git 설치

- [ ] git 설치          # [ ] = 실행할 항목
- [x] git config 설정   # [x] = 건너뛸 항목
```

### 4. 에이전트 실행

Claude Code:
```shell
claude
```

Codex:
```shell
codex
```

에이전트에게 요청하는 방법은 두 가지입니다.

- **파일을 지정하지 않는 경우**: "환경 세팅해줘"라고 요청하면, 에이전트는
  `esential-spec.md`를 가장 먼저 처리한 뒤 나머지 `*-spec.md` 파일들을 순서대로
  처리합니다.
- **파일을 지정하는 경우**: "`@<파일명>` 환경 세팅해줘"라고 요청하면, 그 파일
  하나만 처리하고 다른 명세 파일은 건드리지 않습니다.

명세에 없는 설치·설정을 새로 요청하면, 에이전트가 먼저 `agent-spec.md`에 새
체크리스트 항목을 추가한 뒤 그 항목을 처리합니다. `agent-spec.md`가 없다면
새로 만듭니다.

## 라이선스

[MIT License](LICENSE)
