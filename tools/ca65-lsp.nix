{ pkgs }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "ca65-lsp";
  version = "25.11.08";

  src = pkgs.fetchFromGitHub {
    owner = "techwritescode";
    repo = pname;
    rev = "d4501ca423a1e64d102f81244ad56f44478aa5e3";
    sha256 = "sha256-L/9Ev8LsOqa3Mxb0bMXelmWyb3xlsCAc0r5PcA4Sd3I=";
  };

  cargoSha256 = "sha256-L/9Ev8LsOqa3Mxb0bMXelmWyb3xlsCAc0r5PcA4Sd3I=";
  cargoHash = "sha256-d+HbIz9RgOh7pIou5SRYnD6D5lBHujpTBwqBxoByuA8=";

  meta = with pkgs.lib; {
    description = "ca65-lsp is a language server, parser, and semantic analyzer for the CA65 assembly dialect. It is part of ongoing efforts to improve tooling for the 6502 processor family.";
    homepage = "https://github.com/techwritescode/ca65-lsp";
    license = licenses.unlicense;
  };
}
