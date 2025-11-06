{
  description = "BowlBird Logo Plymouth Theme";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: {
    defaultPackage.x86_64-linux =
    with import nixpkgs { system = "x86_64-linux"; };
    stdenv.mkDerivation {
      pname = "xinux-plymouth-theme";
      version = "1.0.0";
      src = ./xinux;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out/share/plymouth/themes/xinux
        cp * $out/share/plymouth/themes/xinux
        find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
      '';
    };
  };
}
