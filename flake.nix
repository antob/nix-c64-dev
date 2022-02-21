{
    description = "Some C64 development tools in a Nix flake";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
    };
    
    outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs { inherit system; };
    in rec {
        packages.dali = import ./tools/dali.nix { inherit pkgs; };
        packages.exomizer = import ./tools/exomizer.nix { inherit pkgs; };
        packages.kickassembler = import ./tools/kickassembler.nix { inherit pkgs; };
        packages.retrodebugger = import ./tools/retrodebugger.nix { inherit pkgs; };
        packages.spindle = import ./tools/spindle.nix { inherit pkgs; };
    });
}
