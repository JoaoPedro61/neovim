# Language Toolchains

Only Rust and Go need host toolchains beyond the required Node.js installation.
Mason installs their configured LSP servers and supporting editor tools.

## Rust

Rust support requires `rustc`, `cargo`, and `rust-analyzer` in `PATH` before
Neovim starts. Install the stable toolchain through rustup.

### Rust on macOS

```bash
brew install rustup
rustup-init -y
rustup component add rust-analyzer
```

### Rust on Windows

Run PowerShell:

```powershell
winget install --id Rustlang.Rustup -e
rustup default stable
rustup component add rust-analyzer
```

### Rust on Debian

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh
sh rustup-init.sh -y
. "$HOME/.cargo/env"
rustup component add rust-analyzer
```

### Rust on Ubuntu

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh
sh rustup-init.sh -y
. "$HOME/.cargo/env"
rustup component add rust-analyzer
```

### Rust on Arch Linux

```bash
sudo pacman -S rustup
rustup default stable
rustup component add rust-analyzer
```

### Rust on Fedora

```bash
sudo dnf install rustup
rustup-init -y
rustup component add rust-analyzer
```

### Rust on Nix and NixOS

```bash
nix profile install nixpkgs#rustup
rustup default stable
rustup component add rust-analyzer
```

Verify Rust:

```bash
rustc --version
cargo --version
rust-analyzer --version
```

## Go

Go support requires the `go` executable. Mason installs `gopls`, `goimports`,
and `gofumpt` after Neovim starts.

### Go on macOS

```bash
brew install go
```

### Go on Windows

Run PowerShell:

```powershell
winget install --id GoLang.Go -e
```

### Go on Debian

```bash
sudo apt update
sudo apt install golang-go
```

### Go on Ubuntu

```bash
sudo apt update
sudo apt install golang-go
```

### Go on Arch Linux

```bash
sudo pacman -S go
```

### Go on Fedora

```bash
sudo dnf install golang
```

### Go on Nix and NixOS

```bash
nix profile install nixpkgs#go
```

Verify Go:

```bash
go version
```

## Web and configuration languages

JavaScript, TypeScript, Angular, HTML, CSS, JSON, YAML, Markdown, and Bash use
Node.js and npm from [REQUIREMENTS.md](./REQUIREMENTS.md). Mason installs their
configured language servers, formatters, and linters. Each project may still
require its own dependencies through `npm install`, `pnpm install`, or another
project-specific command.

## Sources

- [rustup installer](https://rustup.rs/)
- [Go installation guide](https://go.dev/doc/install)
- [Go downloads](https://go.dev/dl/)
