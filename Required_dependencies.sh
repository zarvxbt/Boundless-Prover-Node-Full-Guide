#!/bin/bash

# RISC Zero Development Environment Installation Script
# This script installs Rust, the RISC Zero toolchain, and related tools

set -e  # Exit on any error

echo "Starting RISC Zero Development Environment Installation..."

# Status message function
print_status() {
    echo "[STATUS] $1"
}

# Success message function
print_success() {
    echo "[SUCCESS] $1"
}

# Error message function
print_error() {
    echo "[ERROR] $1"
}

# Check for sudo privileges
check_sudo() {
    if [[ $EUID -eq 0 ]]; then
        SUDO=""
    else
        SUDO="sudo"
    fi
}

print_status "Installing rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
print_success "Rustup installed successfully"

print_status "Updating rustup..."
rustup update
print_success "Rustup updated"

print_status "Installing Rust toolchain via system package manager..."
check_sudo

print_status "Checking APT repository status..."
apt_output=$($SUDO apt update 2>&1) || apt_failed=true

if [[ "$apt_failed" == "true" ]] || echo "$apt_output" | grep -q "NO_PUBKEY\|not signed\|401\|403\|404"; then
    print_error "APT update error detected, fixing problematic repositories..."

    print_status "Cleaning Tailscale repository files..."
    $SUDO rm -f /etc/apt/sources.list.d/tailscale* 2>/dev/null || true
    $SUDO rm -f /etc/apt/trusted.gpg.d/tailscale* 2>/dev/null || true
    $SUDO rm -f /usr/share/keyrings/tailscale* 2>/dev/null || true

    print_status "Removing other problematic repositories..."
    $SUDO rm -f /etc/apt/sources.list.d/nvidia-* 2>/dev/null || true
    $SUDO rm -f /etc/apt/sources.list.d/google-* 2>/dev/null || true  
    $SUDO rm -f /etc/apt/sources.list.d/wine* 2>/dev/null || true
    $SUDO rm -f /etc/apt/sources.list.d/chrome* 2>/dev/null || true

    print_status "Cleaning APT cache..."
    $SUDO apt clean
    $SUDO apt autoclean

    $SUDO rm -rf /var/lib/apt/lists/*

    print_status "Updating APT repositories again..."
    if ! $SUDO apt update; then
        print_error "Still errors, switching to basic Ubuntu repository..."
        echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse" | $SUDO tee /etc/apt/sources.list.d/ubuntu-main.list
        $SUDO apt update
    fi
fi

print_status "Installing Cargo..."
if ! $SUDO apt install -y cargo 2>/dev/null; then
    print_status "APT install failed, using rustup-installed Cargo..."
    print_success "Using Cargo installed by rustup"
else
    print_success "Cargo installed via apt"
fi

print_status "Verifying Cargo installation..."
cargo --version
print_success "Cargo verification complete"

print_status "Installing rzup..."
curl -L https://risczero.com/install | bash
source ~/.bashrc
print_success "rzup installed"

print_status "Verifying rzup installation..."
export PATH="$HOME/.risc0/bin:/root/.risc0/bin:$PATH"
echo 'export PATH="$HOME/.risc0/bin:/root/.risc0/bin:$PATH"' >> ~/.bashrc

if command -v rzup &> /dev/null; then
    rzup --version
    print_success "rzup verification complete"
else
    print_error "rzup not found in PATH, checking alternative locations..."

    possible_paths=(
        "$HOME/.risc0/bin"
        "/root/.risc0/bin" 
        "$HOME/.rzup/bin"
        "/root/.rzup/bin"
        "$HOME/.local/bin"
        "/usr/local/bin"
    )

    rzup_found=false
    for path in "${possible_paths[@]}"; do
        if [ -f "$path/rzup" ]; then
            print_status "rzup found: $path/rzup"
            export PATH="$path:$PATH"
            echo "export PATH=\"$path:\$PATH\"" >> ~/.bashrc
            rzup_found=true
            break
        fi
    done

    if [ "$rzup_found" = true ]; then
        rzup --version
        print_success "rzup verification complete"
    else
        print_error "rzup installation might have failed"
        print_status "Try reinstalling manually:"
        print_status "curl -L https://risczero.com/install | bash"
        exit 1
    fi
fi

print_status "Installing RISC Zero Rust Toolchain..."
rzup install rust
print_success "RISC Zero Rust toolchain installed"

print_status "Installing cargo-risczero..."
cargo install cargo-risczero
print_success "cargo-risczero installed with cargo"

print_status "Installing cargo-risczero via rzup..."
rzup install cargo-risczero
print_success "cargo-risczero installed with rzup"

print_status "Updating rustup again..."
rustup update
print_success "Rustup updated"

print_status "Installing Bento-client..."
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli
print_success "Bento-client installed"

print_status "Updating PATH in .bashrc..."
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
print_success "PATH updated"

print_status "Verifying Bento-client installation..."
if command -v bento_cli &> /dev/null; then
    bento_cli --version
    print_success "Bento-client verification complete"
else
    print_error "bento_cli not found in PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    if command -v bento_cli &> /dev/null; then
        bento_cli --version
        print_success "Bento-client verified after PATH update"
    else
        print_error "Bento-client installation may have failed"
    fi
fi

print_status "Installing Boundless CLI..."
cargo install --locked boundless-cli
print_success "Boundless CLI installed"

print_status "Updating PATH for Boundless CLI..."
export PATH=$PATH:/root/.cargo/bin:$HOME/.cargo/bin
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
print_success "PATH updated for Boundless CLI"

print_status "Verifying Boundless CLI installation..."
if command -v boundless &> /dev/null; then
    boundless -h
    print_success "Boundless CLI verification complete"
else
    print_error "boundless command not found in PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    if command -v boundless &> /dev/null; then
        boundless -h
        print_success "Boundless CLI verified after PATH update"
    else
        print_error "Boundless CLI installation may have failed"
    fi
fi

print_success "RISC Zero Development Environment Installation Complete!"
echo ""
echo "Next Steps:"
echo "1. Restart your terminal or run: source ~/.bashrc"
echo "2. Verify all tools work:"
echo "   - cargo --version"
echo "   - rzup --version"
echo "   - bento_cli --version"
echo "   - boundless -h"
echo ""
echo "You are now ready to develop with RISC Zero!"
