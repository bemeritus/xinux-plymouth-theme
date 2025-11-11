{stdenvNoCC}:
stdenvNoCC.mkDerivation {
  pname = "xinux-mac-style";
  version = "0.1.0";
  src = ./src;

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/xinux
    cp -r mac-style $out/share/plymouth/themes/
    chmod +x $out/share/plymouth/themes/mac-style/xinux.plymouth
    substituteInPlace $out/share/plymouth/themes/xinux/xinux.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/xinux/images"
  '';
}
