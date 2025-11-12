# {
#   stdenv,
#   fetchurl,
#   lib,
#   unzip,
#   # To select only certain themes, pass `selected_themes` as a list of strings.
#   # reference ./shas.nix for available themes
#   selected_themes ? [ ],
# }:
# let
#   version = "1.0";
#   # this file is generated via ./update.sh
#   # borrowed from pkgs/data/fonts/nerdfonts
#   themeShas = import ./shas.nix;
#   knownThemes = builtins.attrNames themeShas;
#   selectedThemes =
#     if (selected_themes == [ ]) then
#       knownThemes
#     else
#       let
#         unknown = lib.subtractLists knownThemes selected_themes;
#       in
#       if (unknown != [ ]) then
#         throw "Unknown theme(s): ${lib.concatStringsSep " " unknown}"
#       else
#         selected_themes;
#   srcs = lib.lists.forEach selectedThemes (
#     name:
#     (fetchurl {
#       url = themeShas.${name}.url;
#       sha256 = themeShas.${name}.sha;
#     })
#   );
# in
# stdenv.mkDerivation {
#   pname = "xinux-plymouth-theme";
#   inherit version srcs;

#   nativeBuildInputs = [
#     unzip
#   ];

#   sourceRoot = ".";
#   unpackCmd = "tar xzf $curSrc";

#   installPhase = ''
#     mkdir -p $out/share/plymouth/themes
#     for theme in ${toString selectedThemes}; do
#       mv $theme $out/share/plymouth/themes/$theme
#     done
#     find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
#   '';
# }
#
{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "xinux-plymouth-theme";
  version = "0.0.1";

  src = ./.;

  buildInputs = [
    pkgs.git
  ];

  configurePhase = ''
mkdir -p $out/share/plymouth/themes/
  '';

  buildPhase = ''
  '';

  installPhase = ''
  cp -r xinux/mac_style $out/share/plymouth/themes
cat xinux/mac_style/mac_style.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/mac_style/mac_style.plymouth
  '';
}
