{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "c64-manpages";
  version = "0.1.0";

  src = ./manpages;

  nativeBuildInputs = [ pkgs.installShellFiles ];

  installPhase = ''
    installManPage man99/*
  '';
}
