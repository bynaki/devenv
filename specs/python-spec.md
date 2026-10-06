# python

### 외부 프로그램용 파이썬 LSP (pyright)

nvim 밖의 프로그램이 파이썬 LSP로 쓸 수 있게 `PATH`에 pyright를 설치한다. nvim(mason)의 LSP와는 별개다.

- 공식 저장소: https://github.com/microsoft/pyright
- PyPI 래퍼: https://github.com/RobertCraigie/pyright-python

#### macOS

해당 OS(macOS)가 아니면 이 절의 항목은 모두 충족으로 본다.

- [ ] pyright 설치
  - 방법: `brew install pyright`
  - 판정 기준: `pyright --version`이 동작하고 `command -v pyright-langserver`가 경로를 출력하면 충족. (`pyright-langserver`는 `--version`이 없다)

#### Linux

해당 OS(Linux)가 아니면 이 절의 항목은 모두 충족으로 본다.

- [ ] pyright 설치
  - 방법: `uv tool install 'pyright[nodejs]'`. `nodejs` extra가 Node 바이너리를 함께 설치하므로 시스템 Node가 필요 없다.
  - 판정 기준: `pyright --version`이 동작하고 `command -v pyright-langserver`가 경로를 출력하면 충족. (`pyright-langserver`는 `--version`이 없다)
