{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let nix = nixFlakes; in
stdenv.mkDerivation {
  name = "nix-direnv";

  src = ./.;

  postPatch = ''
    substituteInPlace direnvrc \
      --replace "grep" "${gnugrep}/bin/grep" \
      --replace "nix" "${nix}/bin/nix" \
      --replace "nix-shell" "${nix}/bin/nix-shell" \
      --replace "nix-instantiate" "${nix}/bin/nix-instantiate"
  '';

  installPhase = ''
    install -m500 -D direnvrc $out/share/nix-direnv/direnvrc
  '';

  meta = with stdenv.lib; {
    description = "A fast, persistent use_nix implementation for direnv";
    homepage    = "https://github.com/nix-community/nix-direnv";
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
