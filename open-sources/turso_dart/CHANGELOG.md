## 0.1.0+flipper.1
- Fix Android 16 KB ELF alignment: pass max-page-size via
  `CARGO_TARGET_*_RUSTFLAGS` in the build hook (`.cargo/config.toml` alone is
  ignored when cargo is invoked with `--manifest-path` from another cwd).

## 0.1.0
- Expose isolate.dart as async alternative to be used in flutter project
- Flipper: Android 16 KB page-size linker flags (see README)

## 0.0.2
- fix possible memory leaks
- fix crash on tx commit/rollback

## 0.0.1
- initial release