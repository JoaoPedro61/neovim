# joaopedro61/nvim

Neovim configuration for my daily setup. It uses `lazy.nvim`, keeps a global `settings.json`, and also supports workspace overrides through `.neovim/settings.json` inside a project.

## Requirements

- Neovim `0.11` or newer
- `git`
- A working `PATH` with the tools you actually use in your projects

## Installation

1. Back up any existing Neovim configuration.
2. Clone this repository into your Neovim config directory:

```bash
git clone https://github.com/JoaoPedro61/neovim.git ~/.config/nvim
```

3. Start Neovim:

```bash
nvim
```

4. Let `lazy.nvim` bootstrap itself on first launch.

That is enough to get the config running. The root `init.lua` bootstraps `lazy.nvim`, loads settings, applies platform-specific behavior, and then loads the plugin specs.

## Settings

This config uses three layers of settings, in this order:

1. Defaults from [lua/joaopedro61/settings/defaults.lua](./lua/joaopedro61/settings/defaults.lua)
2. Global settings from [settings.json](./settings.json)
3. Workspace settings from `<project>/.neovim/settings.json`

Workspace settings override global settings only for the current project. That is the main mechanism for per-project customization.

## Create Workspace Settings

If you are inside a project and want to start a project-specific settings file from the current effective config, run:

```vim
:SettingsCreateWorkspace
```

This creates:

```text
.neovim/settings.json
```

in the current working directory, using the active settings as the starting point.

Use the bang version to overwrite an existing workspace settings file:

```vim
:SettingsCreateWorkspace!
```

Open the active settings file with:

```vim
:SettingsOpen
```

## Common Workflow

1. Open the project in Neovim.
2. Run `:SettingsCreateWorkspace` if the project does not have `.neovim/settings.json` yet.
3. Edit the generated file with the values you want to override for that repository.
4. Save the file.
5. Neovim reloads the settings automatically.

## Notable Features

- Global and workspace settings with deep merge
- Colorscheme selection driven by settings
- Auto format, diagnostics, inlay hints, and codelens settings that respect `enable` and `exclude`
- Platform-specific clipboard and shell behavior
- Lazy-loaded plugin specs organized by domain

## Plugin Layout

The main groups are:

- `plugins/specs/ui`
- `plugins/specs/editor`
- `plugins/specs/coding`
- `plugins/specs/coding/lang`

This keeps the config split by responsibility instead of putting everything in one file.

## Useful Files

- [init.lua](/Users/jpedro/.config/nvim/init.lua)
- [lua/joaopedro61/init.lua](/Users/jpedro/.config/nvim/lua/joaopedro61/init.lua)
- [lua/joaopedro61/settings/init.lua](/Users/jpedro/.config/nvim/lua/joaopedro61/settings/init.lua)
- [lua/joaopedro61/plugins/init.lua](/Users/jpedro/.config/nvim/lua/joaopedro61/plugins/init.lua)

## Notes

- The config assumes `lazy.nvim` is available or can be cloned automatically.
- `settings.json` at the repo root is the global user config file for this setup.
- Workspace settings are intentionally stored under `.neovim/` so they stay local to the project.
