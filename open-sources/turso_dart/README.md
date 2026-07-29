# turso_dart (Flipper fork)

Vendored from [pub.dev `turso_dart` 0.1.0](https://pub.dev/packages/turso_dart) with one change:

Android builds pass `-Wl,-z,max-page-size=16384` (and `common-page-size`) so
`libturso_dart_native.so` has 16 KB ELF `LOAD` alignment. Upstream 0.1.0 ships
4 KB alignment, which Google Play rejects for apps targeting API 35+.

Patch:

- `hook/build.dart` — sets `CARGO_TARGET_*_LINUX_ANDROID_RUSTFLAGS` for the
  three Android triples. Required because `native_toolchain_rust` invokes
  `cargo` with `--manifest-path` and does not `cd` into `rust/`, so Cargo never
  loads `rust/.cargo/config.toml` (config discovery is cwd-based).
- `rust/.cargo/config.toml` — same flags for local `cd rust && cargo build
  --target …` workflows; not used by the Flutter native-assets hook.

Remove this fork when upstream publishes a 16 KB-aligned release.
