{
  description = "Elyth's NeoVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";

  };

  outputs =
    { nixpkgs
    , nixvim
    , flake-parts
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
          };

          packages = {
            default = nvim;
          };

          devShells = {
            default = with pkgs;
              mkShell {
                packages = [
                  nvim
                  nodejs
                ];
                shellHook = ''
                  export PROMPT="%m%d"
                '';
              };
          };
        };
    };
}
