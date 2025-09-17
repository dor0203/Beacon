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
            pkgs.lld
            pkgs.openssl
            wasmpkgs.wasm-bindgen-cli_0_2_101
            pkgs.pkg-config

            pkgs.cargo
            pkgs.rustc
            pkgs.dioxus-cli
            pkgs.postgresql
          ];

          shellHook = ''
            source .env

            if [ ! -d "$PGDATA" ]; then
              initdb --pgdata=$PGDATA -c "unix_socket_directories=$PGDATA" > /dev/null
            fi
            pg_ctl --pgdata=$PGDATA -l "$PGDATA/logfile" start
            trap "pg_ctl -D \"$PGDATA\" stop" EXIT

            if ! psql -U $USER -lqt | cut -d \| -f 1 | grep -qw $DBNAME; then
              echo "created catalog $DBNAME"
              createdb -U $USER $DBNAME
            fi
          '';
        };
      };
}
