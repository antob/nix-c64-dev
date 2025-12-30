{ pkgs }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "bitmap2spr";
  version = "0.1.0";
  pyproject = false;

  propagatedBuildInputs = with pkgs.python3Packages; [
    pillow
  ];

  dontUnpack = true;
  installPhase = ''
    install -Dm755 "${./${pname}.py}" "$out/bin/${pname}"
  '';
}
