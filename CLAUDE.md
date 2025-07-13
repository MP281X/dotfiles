# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles repository designed for WSL2-based development environments. It provides automated setup and configuration for a complete development stack including Neovim IDE, shell environment, and Kubernetes/Docker workflows.

## Common Commands

### Setup and Installation
- **Fresh install**: `bash <(curl -s -L https://raw.githubusercontent.com/MP281X/dotfiles/main/scripts/setup.sh)`
- **Update configurations**: `cd ~/dotfiles && bash ./scripts/dotfiles.sh`
- **WSL setup from Windows**: `./scripts/setup.ps1` (PowerShell)

### Development Workflow
- **Editor**: `vi` (nvim)
- **AI Assistant**: `c` (claude), `cc` (claude --continue)
- **Package management**: `i` (pnpm update), `pnpx` (pnpm dlx)
- **Git operations**: `g` (gitui), `gl` (list repos), `gc` (clone), `gr` (cleanup branches)

### Container and Cluster Management
- **Docker**: `ps` (formatted container list)
- **Kubernetes**: `k` (k9s dashboard)
- **System restart**: `reboot`/`restart` (WSL shutdown)

## Architecture

### Configuration Structure
- **`/shell/`** - Shell and terminal configurations (bashrc, starship, gitui, windows-terminal)
- **`/nvim/`** - Complete Neovim IDE setup with Lazy.nvim plugin manager
- **`/windows/`** - Windows-specific files (AutoHotkey, win32yank, fonts)
- **`/claude/`** - Claude Code MCP global configuration
- **`/scripts/`** - Installation automation (setup.sh, dotfiles.sh, setup.ps1)

### Key Design Patterns
- **Modular Neovim Configuration**: Separated into config.lua, plugin.lua, keymaps.lua, lsp-config.lua for maintainability
- **Idempotent Setup Scripts**: Can be run multiple times safely
- **WSL2-First Design**: Optimized for Windows development through WSL2 with cross-platform integration
- **Declarative Package Management**: Uses Homebrew for consistent tool installation

### Installation Flow
1. `setup.ps1` handles WSL2 Debian installation and user creation (Windows)
2. `setup.sh` installs packages, development tools, and configures environment (Linux)
3. `dotfiles.sh` deploys configuration files to appropriate locations

### Development Environment
- **Shell**: Bash with comprehensive aliases and functions
- **Editor**: Neovim with LSP support for multiple languages
- **Tools**: Modern CLI tools (eza, fzf, ripgrep, starship)
- **Containers**: Docker with systemd integration
- **Kubernetes**: kubectl, k9s, kubeseal for cluster management
- **Git**: GitHub CLI with automated authentication

## Important Notes

- All configurations are designed to be reproducible and version-controlled
- The system expects access to a Windows D: drive for secrets/configuration during setup
- Neovim configuration uses Lazy.nvim plugin manager - modify `nvim/plugin.lua` for plugin changes
- Shell aliases and functions are defined in `shell/bashrc`
- WSL-specific features include clipboard integration (win32yank) and Windows Terminal configuration