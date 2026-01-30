{
  description = "MP281X's dotfiles managed with Nix + Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "mp281x";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit username; };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ home-manager git ];        
        shellHook = ''
          echo "Dotfiles development environment"
          echo "Run: home-manager switch --flake .#${username}"
        '';
      };
    };
}
