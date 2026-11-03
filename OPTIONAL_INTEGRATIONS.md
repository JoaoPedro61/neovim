# Optional Integrations

These packages are not required for startup. They enable faster search, Git UI,
native Telescope sorting, icons, and system clipboard support.

## macOS

```bash
brew install make cmake lazygit fd
brew install --cask font-jetbrains-mono-nerd-font
```

macOS already provides the `pbcopy` and `pbpaste` clipboard commands.

## Windows

Run PowerShell:

```powershell
winget install --id Kitware.CMake -e
winget install --id JesseDuffield.lazygit -e
winget install --id sharkdp.fd -e
winget install --id Microsoft.PowerShell -e
```

Install a Nerd Font from PowerShell:

```powershell
Install-PSResource -Name NerdFonts -Scope CurrentUser
Import-Module NerdFonts
Install-NerdFont -Name JetBrainsMono
```

Windows and WSL normally provide `clip.exe` and `powershell.exe` for the
configured clipboard bridge.

## Debian

```bash
sudo apt update
sudo apt install make cmake fd-find wl-clipboard xclip xsel
```

Install LazyGit through Go when the Debian release does not package it:

```bash
go install github.com/jesseduffield/lazygit@latest
```

## Ubuntu

```bash
sudo apt update
sudo apt install make cmake fd-find wl-clipboard xclip xsel
```

Install LazyGit through Go when the Ubuntu release does not package it:

```bash
go install github.com/jesseduffield/lazygit@latest
```

## Arch Linux

```bash
sudo pacman -S make cmake lazygit fd wl-clipboard xclip xsel ttf-jetbrains-mono-nerd
```

## Fedora

```bash
sudo dnf install make cmake lazygit fd-find wl-clipboard xclip xsel
```

## Nix and NixOS

```bash
nix profile install \
  nixpkgs#gnumake \
  nixpkgs#cmake \
  nixpkgs#lazygit \
  nixpkgs#fd \
  nixpkgs#wl-clipboard \
  nixpkgs#xclip \
  nixpkgs#xsel \
  nixpkgs#nerd-fonts.jetbrains-mono
```

## Nerd Font on Debian, Ubuntu, and Fedora

Use the upstream Nerd Fonts installer:

```bash
installer=https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh
curl -fsSL "$installer" -o install-nerd-font.sh
chmod +x install-nerd-font.sh
./install-nerd-font.sh install JetBrainsMono
```

Configure the terminal application to use `JetBrainsMono Nerd Font` after
installation.

## Notes

- Telescope enables `telescope-fzf-native.nvim` when `make`, `gmake`, or
  `cmake` is available.
- Debian and Ubuntu install `fd` as `fdfind`. Telescope can still use ripgrep
  or another available finder without an `fd` alias.
- Install only one clipboard provider for the active Linux display server:
  `wl-clipboard` for Wayland, or `xclip`/`xsel` for X11.
- `go install` writes LazyGit to `~/go/bin` by default. Add that directory to
  `PATH` when necessary.

## Sources

- [Nerd Fonts installation guide](https://github.com/ryanoasis/nerd-fonts#font-installation)
- [Arch Linux Neovim guide](https://wiki.archlinux.org/title/Neovim)
- [LazyGit installation guide](https://github.com/jesseduffield/lazygit#installation)
