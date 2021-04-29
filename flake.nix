{
    description = "Some C64 development tools in a Nix flake";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
    };
    
    outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs { inherit system; };
    in rec {
        packages.exomizer = import ./tools/exomizer.nix { inherit pkgs; };
        packages.kickassembler = import ./tools/kickassembler.nix { inherit pkgs; };
        packages.c64debugger = import ./tools/c64debugger.nix { inherit pkgs; };
        packages.xa = import ./tools/xa.nix { inherit pkgs; };
        packages.vice = import ./tools/vice.nix { inherit pkgs; xa = packages.xa; };
    });
}
