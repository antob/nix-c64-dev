{
  description = "Some C64 development tools in a Nix flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.c64-manpages = import ./docs/manpages.nix { inherit pkgs; };
        packages.dali = import ./tools/dali.nix { inherit pkgs; };
        packages.exomizer = import ./tools/exomizer.nix { inherit pkgs; };
        packages.bitmap2spr = import ./tools/bitmap2spr { inherit pkgs; };
        packages.kickassembler = import ./tools/kickassembler.nix { inherit pkgs; };
        packages.retrodebugger = import ./tools/retrodebugger.nix { inherit pkgs; };
        packages.spindle = import ./tools/spindle.nix { inherit pkgs; };
        packages.ca65-lsp = import ./tools/ca65-lsp.nix { inherit pkgs; };
      }
    );
}
