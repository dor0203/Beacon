{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsforwasm.url = "https://github.com/NixOS/nixpkgs/archive/pull/443183/head.tar.gz";
  };

  outputs = { self, nixpkgs, nixpkgsforwasm }:
      let
        system = "x86_64-linux";
        wasmpkgs = nixpkgsforwasm.legacyPackages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.${system}.default = pkgs.mkShell {
          buildInputs = [
            pkgs.cargo
            pkgs.rustc
            pkgs.dioxus-cli
            pkgs.lld
            wasmpkgs.wasm-bindgen-cli_0_2_101
          ];
        };
      };
}
