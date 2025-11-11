{
  description = "Mac-style NixOS Plymouth Theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    with flake-utils.lib; eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = {
        default = pkgs.callPackage ./package.nix {};
        xinux = pkgs.callPackage ./package.nix {};
      };

      devShells.default = pkgs.mkShell {
        name = "plymouth-test";
        packages = with pkgs; [
          plymouth
          (pkgs.writeShellScriptBin "show" (builtins.readFile ./showplaymouth.sh))
        ];
      };
    })
    // {
      overlays.default = final: prev: {
         xinux = final.callPackage ./package.nix {};
      };
    };
}
