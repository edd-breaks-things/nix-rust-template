# Rust with Nix Template

[![CI](https://github.com/edd-breaks-things/nix-rust-template/actions/workflows/ci.yml/badge.svg)](https://github.com/edd-breaks-things/nix-rust-template/actions/workflows/ci.yml)

A simple GitHub template for Rust projects using Nix flakes. Get started with Rust development quickly with a reproducible environment.

## Quick Start

### Prerequisites
- [Nix](https://nixos.org/download.html) with flakes enabled
- Git

### Using This Template

1. Click "Use this template" on GitHub
2. Clone your new repository
3. Enter the development environment:
   ```bash
   nix develop
   ```

### Basic Commands

```bash
# Build the project
cargo build

# Run the application
cargo run

# Run tests
cargo test

# Check code with clippy
cargo clippy

# Format code
cargo fmt

# Watch for changes and rebuild
cargo watch -x run
```

## Project Structure

```
.
├── src/
│   ├── main.rs    # Application entry point
│   └── lib.rs     # Library code
├── Cargo.toml     # Rust dependencies
├── Cargo.lock     # Lock file (committed for reproducibility)
├── flake.nix      # Nix development environment
└── README.md      # This file
```

## Customizing

### Rename Your Project

1. Edit `Cargo.toml` and change the `name` field
2. Update `flake.nix` - replace `example-rust-app` with your binary name
3. Update imports in `src/main.rs` if needed

### Add Dependencies

Edit `Cargo.toml`:
```toml
[dependencies]
serde = "1.0"
```

Then run `cargo build` to update `Cargo.lock`.

### Add System Dependencies

Edit `flake.nix` to add packages to `buildInputs`:
```nix
buildInputs = with pkgs; [
  rustToolchain
  cargo-watch
  pkg-config      # Add system tools
  openssl         # Add libraries
];
```

## Building for Production

### Native Binary
```bash
# Optimized build
cargo build --release

# Or using Nix
nix build
```

### Docker Image
```bash
# Build Docker image with Nix (no Docker daemon required!)
nix build .#dockerImage

# Load into Docker
docker load < result

# Run the container
docker run rust-app:latest
```

## CI/CD

The template includes GitHub Actions that run on every push:
- Format check
- Clippy linting  
- Test suite
- Docker image build

## Advanced Features

Once you're comfortable with the basics, you can extend the template:

<details>
<summary>Add more development tools</summary>

Edit `flake.nix`:
```nix
buildInputs = with pkgs; [
  rustToolchain
  cargo-watch
  cargo-edit      # For cargo add/rm/upgrade
  cargo-audit     # Security audits
  cargo-nextest   # Faster test runner
  bacon           # Background compiler
];
```
</details>

<details>
<summary>Add async support</summary>

Add to `Cargo.toml`:
```toml
[dependencies]
tokio = { version = "1", features = ["full"] }
```

Update `src/main.rs`:
```rust
#[tokio::main]
async fn main() {
    // Your async code
}
```
</details>

<details>
<summary>Cross-compilation</summary>

Add targets to `flake.nix`:
```nix
rustToolchain = pkgs.rust-bin.stable.latest.default.override {
  extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
  targets = [ "wasm32-unknown-unknown" ];  # Add targets
};
```
</details>

## Troubleshooting

### Enable Nix Flakes
Add to `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### Rust Version
The template uses the latest stable Rust. To use a specific version, edit `flake.nix`:
```nix
rustToolchain = pkgs.rust-bin.stable."1.75.0".default.override {
  # ...
};
```

### macOS Issues
The template includes `libiconv` for macOS compatibility. If you encounter linking errors, ensure Xcode Command Line Tools are installed:
```bash
xcode-select --install
```

## Resources

- [Rust Book](https://doc.rust-lang.org/book/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Cargo Documentation](https://doc.rust-lang.org/cargo/)

## License

This template is provided as-is for use in your projects. Add your preferred license.