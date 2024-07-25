{
  description = "Elyth's NeoVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # pre-commit-hooks = {
    #   url = "github:cachix/pre-commit-hooks.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };


  };

  outputs =
    { nixpkgs
    , nixvim
    , flake-parts
      # , pre-commit-hooks
    , gomod2nix
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem =
        { system
        , pkgs
        , self'
        , lib
        , ...
        }:
        let
          nixvim' = nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = ./config;
          };
        in
        {
          checks = {
            default = pkgs.nixvimLib.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "A nixvim configuration";
            };
            # pre-commit-check = pre-commit-hooks.lib.${system}.run {
            #   src = ./.;
            #   hooks = {
            #     statix.enable = true;
            #     nixpkgs-fmt.enable = true;
            #   };
            # };
          };

          # formatter = pkgs.nixpkgs-fmt;

          packages = {
            default = nvim;

            vite = pkgs.buildGoModule {
              name = "vite";
              rev = "master";
              src = ./.;
              vendorHash = "sha256-aHPT3Vl0is+NYaHqkdDjDjEVjvXnwCqK7Bbgm5FhBT0=";
            };
          };

          devShells = {
            default = with pkgs;
              mkShell {
                # inherit (self'.checks.pre-commit-check) shellHook;
                packages = [
                  nvim
                  nodejs
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
    };
}
