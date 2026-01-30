{ pkgs, lib, ... }:

{
  # Install Bun global packages declaratively via activation script
  # This runs after writeBoundary to ensure Bun is available
  home.activation.bunGlobalPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Ensure packages are installed globally via Bun
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    
    # Helper function to check and install packages
    install_bun_global() {
      local pkg="$1"
      local cmd="${2:-$1}"
      
      if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Installing $pkg via Bun..."
        $DRY_RUN_CMD ${pkgs.bun}/bin/bun install -g "$pkg" || true
      fi
    }
    
    # Install oxfmt (formatter)
    install_bun_global "oxfmt"
    
    # Install oxlint (linter)
    install_bun_global "oxlint"
    
    # Install TypeScript Go (tsgo) - provides 'tsgo' command
    install_bun_global "@typescript/native-preview" "tsgo"
  '';
}
