## About Me
  Name: Scott Donnelly (@sdd)
  Language: Rust | Shell: Zsh

## Version Control
  * VCS: Git with trunk-based development on `master`
  * Branching: `feat/`, `fix/` branches; `release/N.x.x` for major version backports
  * Commits: Conventional Commits (Angular), with `Fixes: #N` for bug issues
  * Branch names: Short, hyphenated descriptions (e.g., `fix/issue-123`)

## Workflow
  * TDD approach
  * Never add unstable Rust features without asking
  * Pre-commit: `cargo fmt` + `cargo clippy` (automated via `prek`)
  * Public projects: Always confirm before breaking changes

## Tooling
  * `prek` - pre-commit hooks
  * `just` - task runner (default task lists all tasks)
  * `release-plz` - release orchestration

## Style
* I like my projects to have comprehensive pre-commit and pre-push hooks in order to maintain a high standard. I like my CI to mirror those checks, only with the tools running in "check" mode where possible, so that for other contributors (or even me if I've not set up the hooks or ran --no-verify), I can ensure that the standards are still enforced.
* I like to use `just` tasks to help automate common tasks within the repo.
* I like to practice a "clippy zero" approach where possible, removing clippy warnings as we go, to reduce noise in tool calls and to stay clean

## Crate Choices
* Error handling: `anyhow` (apps), `thiserror` (libraries)
* Time: ALWAYS `jiff`, never `chrono`
* Logging: ALWAYS `tracing`, never `log`
* Async: prefer `tokio`
* CLI: `clap`

