{
  description = "Rust development template with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        
        # Use stable Rust with common tools
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
        };

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustToolchain
            cargo-watch
          ] ++ lib.optionals stdenv.isDarwin [
            libiconv
          ];

          shellHook = ''
            echo "Rust development environment"
            echo "Rust version: $(rustc --version)"
            echo ""
            echo "Available commands:"
            echo "  cargo build    - Build the project"
            echo "  cargo run      - Run the application"
            echo "  cargo test     - Run tests"
            echo "  cargo clippy   - Run linter"
            echo "  cargo fmt      - Format code"
            echo "  cargo watch    - Watch for changes and rebuild"
          '';
        };

        # Build the Rust package
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "example-rust-app";
          version = "0.1.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };

        # Simple Docker image
        packages.dockerImage = pkgs.dockerTools.buildImage {
          name = "rust-app";
          tag = "latest";
          
          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [ self.packages.${system}.default ];
            pathsToLink = [ "/bin" ];
          };

          config = {
            Cmd = [ "/bin/example-rust-app" ];
          };
        };
      });
}