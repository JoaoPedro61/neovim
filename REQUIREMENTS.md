# Required Dependencies

This configuration requires:

- Neovim `0.12` or newer
- Git
- `curl` or GNU `wget`
- `unzip`, GNU `tar`, and `gzip`
- Tree-sitter CLI `0.26.1` or newer
- a C compiler
- Node.js and npm
- ripgrep (`rg`)

Install commands assume an administrator-capable account and internet access.
After installation, open a new terminal so `PATH` changes take effect.

## macOS

Install [Homebrew](https://brew.sh/) first, then run:

```bash
brew update
brew install neovim git curl wget unzip gnu-tar gzip tree-sitter-cli llvm node ripgrep
```

Apple Clang is also available through the Xcode Command Line Tools:

```bash
xcode-select --install
```

## Windows

Run PowerShell. WinGet ships with App Installer on supported Windows versions.

```powershell
winget install --id Neovim.Neovim -e
winget install --id Git.Git -e
winget install --id 7zip.7zip -e
winget install --id LLVM.LLVM -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id BurntSushi.ripgrep.MSVC -e
winget install --id Rustlang.Rustup -e
```

Windows already provides PowerShell, `curl`, and `tar`. Install Tree-sitter CLI
through Cargo after reopening PowerShell:

```powershell
rustup default stable
cargo install tree-sitter-cli --locked
```

## Debian

The Debian repository may not provide Neovim `0.12`. Install the host tools,
then use the official Neovim archive below.

```bash
sudo apt update
sudo apt install \
  git curl wget unzip tar gzip build-essential \
  nodejs npm ripgrep cargo
cargo install tree-sitter-cli --locked
```

For x86-64:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

Use the `arm64` archive name instead on ARM64.

## Ubuntu

Ubuntu repositories may not provide Neovim `0.12`. Install the host tools,
then use the official Neovim archive below.

```bash
sudo apt update
sudo apt install \
  git curl wget unzip tar gzip build-essential \
  nodejs npm ripgrep cargo
cargo install tree-sitter-cli --locked
```

For x86-64:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

Use the `arm64` archive name instead on ARM64.

## Arch Linux

```bash
sudo pacman -Syu
sudo pacman -S \
  neovim git curl wget unzip tar gzip base-devel \
  tree-sitter-cli nodejs npm ripgrep
```

## Fedora

```bash
sudo dnf upgrade --refresh
sudo dnf install \
  neovim git curl wget unzip tar gzip gcc gcc-c++ \
  tree-sitter-cli nodejs npm ripgrep
```

Confirm that Fedora supplied Tree-sitter CLI `0.26.1` or newer. If it did not,
install Cargo and replace it:

```bash
sudo dnf install cargo
cargo install tree-sitter-cli --locked --force
```

## Nix and NixOS

With flakes enabled:

```bash
nix profile install \
  nixpkgs#neovim \
  nixpkgs#git \
  nixpkgs#curl \
  nixpkgs#wget \
  nixpkgs#unzip \
  nixpkgs#gnutar \
  nixpkgs#gzip \
  nixpkgs#gcc \
  nixpkgs#tree-sitter \
  nixpkgs#nodejs_22 \
  nixpkgs#ripgrep
```

The same package names can be added to `environment.systemPackages` on NixOS
or `home.packages` in Home Manager.

## Verify

```bash
nvim --version
git --version
tree-sitter --version
cc --version
node --version
npm --version
rg --version
```

Neovim must report `0.12` or newer. Tree-sitter must report `0.26.1` or newer.
Then run `:checkhealth`, `:Mason`, and `:Lazy` inside Neovim.

## Sources

- [Neovim installation guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)
- [Mason requirements](https://github.com/mason-org/mason.nvim#requirements)
- [nvim-treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- [Tree-sitter CLI installation](https://tree-sitter.github.io/tree-sitter/creating-parsers/1-getting-started.html#installation)
- [WinGet documentation](https://learn.microsoft.com/windows/package-manager/winget/)
