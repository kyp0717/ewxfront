{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    utils.url = "github:numtide/flake-utils";

    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-parts,
    utils,
    gomod2nix,
    ...
  } @ inputs: let
    config = import ./config;
    overlays = [gomod2nix.overlays.default];
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
          inherit pkgs;
          module = config;
        };
      in {
        checks = {
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        };


        packages = {
          default = nvim;
          vite = pkgs.buildGoModule {
            name = "vite";
            rev = "master";
            src = ./.;

            vendorHash = "sha256-aHPT3Vl0is+NYaHqkdDjDjEVjvXnwCqK7Bbgm5FhBT0=";
          };
        };

        devShells.default = pkgs.mkShellNoCC {
          shellHook = ''
            echo Welcome to Neovim powered by Nixvim -- https://github.com/nix-community/nixvim
            PS1="Nixvim: \\w \$ "
            alias vim='nvim'
          '';
          packages = with pkgs; [
            nodejs
            nvim
            go
            gopls
            gotools
            go-tools
            gomod2nix.packages.${system}.default
            sqlite-interactive
          ];
        };
      };
    };
}
