{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl         # HTTP client
    wget         # File downloader
    xz           # Compression utility
    unzip        # Archive extractor
    jq           # JSON processor
    gcc          # C/C++ compiler
    gnumake      # Build tool
    ripgrep      # Fast grep alternative
    eza          # Modern ls replacement
  ];
}
