
{
  description = "Flake for adi1090x Plymouth themes (with optional selected themes)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      selectedThemes = [ "mac_style"];

      themeShas = import ./shas.nix;
      knownThemes = builtins.attrNames themeShas;
      selected =
        if (selectedThemes == [ ]) then
          knownThemes
        else
          let
            unknown = pkgs.lib.subtractLists knownThemes selectedThemes;
          in
          if (unknown != [ ]) then
            throw "Unknown theme(s): ${pkgs.lib.concatStringsSep " " unknown}"
          else
            selectedThemes;

      srcs = pkgs.lib.lists.forEach selected (
        name:
        pkgs.fetchurl {
          url = themeShas.${name}.url;
          sha256 = themeShas.${name}.sha;
        }
      );
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "xinux-plymouth-theme";
        version = "1.0";
        inherit srcs;

        nativeBuildInputs = [ pkgs.unzip ];

        sourceRoot = ".";
        unpackCmd = "tar xzf $curSrc";

        installPhase = ''
          mkdir -p $out/share/plymouth/themes
          for theme in ${toString selected}; do
            mv $theme $out/share/plymouth/themes/$theme
          done
          find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@/usr/@$out/@" {} \;
        '';

      };
    };
}
