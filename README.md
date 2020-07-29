# Indy VCX Build

Libvcx and related library building by bash script divide by arch `X86_64, arm64` for IOS

> Test build at indy-sdk commit 5c91107c59f0628a9529de97f40d652451850ef4

## ENV configure

Currently, you need to manually select by comment other else for `./env.sh` on `OPENSSL_PATH`

## Building library

Uncomment the command and wait for the library build at `build.sh`

```bash
# Build 3rd party libraries
build_crypto
build_libsodium
build_libzmq


# Extract architectures from fat files int non-fat files
# We introduce library names as third parameter of extract_architectures becuase VCX cargo build requires 
# OPENSSL_LIB_DIR variable for folder with both OpenSSL libs (libssl and libcrypto) toghether.

# extract_architectures LIB_PATH LIB_FILE_NAME and LIB_NAME
extract_architectures output/libsodium-ios/dist/ios/lib/libsodium.a libsodium sodium
extract_architectures output/libzmq-ios/dist/ios/lib/libzmq.a libzmq zmq
extract_architectures output/OpenSSL-for-iPhone/lib/libssl.a libssl openssl
extract_architectures output/OpenSSL-for-iPhone/lib/libcrypto.a libcrypto openssl


# Build libindy
checkout_indy_sdk
build_libindy
copy_libindy_architectures


# Build vcx
build_libvcx
copy_libvcx_architectures


# Copy libraries to combine
copy_libs_tocombine

# Combine libs by arch and merge libs to single fat binary
combine_libs libvcxall


# Build vcx.framework
# apply_vcx_wrapper_ios_patch # This might be not work on indy-sdk tag 1.15.0
build_vcx_framework libvcxall
```

## Command

```bash
./build.sh
```

## Troubleshoot Guide

- Error: `error: libzmq.rb: patch does not apply` - Can try to update your home brew `brew install zmq` and remove `./output/libzmq-ios/dist`
- If rebuild on older version works but newer version does not - Clear all caches and previous vcx build at `./output/indy-sdk`: The newer version might update its dependencies so, rebuild all for new version is a good idea.
- To prevent and track any issue -> suggest to **uncomment command and run one-by-one**
