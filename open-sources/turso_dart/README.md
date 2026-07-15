# turso_dart (Flipper fork)

Vendored from [pub.dev `turso_dart` 0.1.0](https://pub.dev/packages/turso_dart) with one change:

Android builds pass `-Wl,-z,max-page-size=16384` (and `common-page-size`) so
`libturso_dart_native.so` has 16 KB ELF `LOAD` alignment. Upstream 0.1.0 ships
4 KB alignment, which Google Play rejects for apps targeting API 35+.

Patch:
- `rust/.cargo/config.toml` — linker flags for Android Cargo target triples only
  (safe for web: those triples are never used, and the hook must not read
  `input.config.code` which is null on web).

Remove this fork when upstream publishes a 16 KB-aligned release.
