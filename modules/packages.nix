{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core system utilities
    curl         # HTTP client
    wget         # File downloader
    xz           # Compression utility
    unzip        # Archive extractor
    jq           # JSON processor
    gcc          # C/C++ compiler (needed for some packages)
    gnumake      # Build tool
    ripgrep      # Fast grep alternative
    htop         # Process viewer
    btop         # Resource monitor (modern alternative to htop)

    # Terminal UI tools
    eza          # Modern ls replacement with icons
    gitui        # Terminal UI for Git

    # Editor
    # JavaScript/TypeScript runtime
    bun          # Fast JavaScript runtime and package manager

    # Container tools
    docker       # Docker client (daemon via Docker Desktop on WSL)

    # Environment and navigation tools
    bat          # Cat with syntax highlighting
    fd           # Fast find alternative

    # LSP servers for Neovim
    typescript-language-server    # TypeScript support
    tailwindcss-language-server   # Tailwind CSS support
    vscode-langservers-extracted  # JSON, HTML, CSS, ESLint
    lua-language-server           # Lua support
    nil                           # Nix language support
  ];
}
