#!/bin/sh

# Prerequisities
# - install Rust
# - install and set Xcode Command Line Tools
#   - sudo xcodebuild -license
#   - sudo xcode-select -s /Applications/Xcode.app

echo "Setup rustup"
rustup update 1.40.0
rustup default 1.40.0
rustup component add rls-preview rust-analysis rust-src

echo "Setup rustup target platforms"
rustup target remove aarch64-linux-android
rustup target armv7-linux-androideabi
rustup target arm-linux-androideabi
rustup target i686-linux-android
rustup target x86_64-linux-android
rustup target add aarch64-apple-ios
rustup target add armv7-apple-ios
rustup target add armv7s-apple-ios
rustup target add x86_64-apple-ios
rustup target add i386-apple-ios

RUST_TARGETS=$(rustc --print target-list | grep -i ios)
if [ "$RUST_TARGETS" = "" ]; then
    echo "Error: Rust targets for iOS has not been set! Try to run 'xcode-select -s /Applications/Xcode.app'"
    exit 1
fi

echo "Install Rust Xcode tools"
cargo install cargo-lipo
cargo install cargo-xcode

echo "Check Homebrew"
BREW_VERSION=$(brew --version)
if ! [[ $BREW_VERSION =~ ^'Homebrew ' ]]; then
    echo "Error: Missing Homebrew, package manager for macOS to install native dependencies."
    exit 1
fi

echo "Update Homebrew"
brew doctor
brew update

echo "Install required native libraries and utilities (libsodium is added with URL to homebrew since version<1.0.15 is required)"
brew install pkg-config
brew install libsodium
brew install automake
brew install autoconf
brew install cmake
brew install openssl
brew install zmq
brew install wget
brew install truncate
brew install libzip
