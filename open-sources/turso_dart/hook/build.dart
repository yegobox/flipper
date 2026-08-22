import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

/// Android 16 KB ELF alignment for Google Play (targetSdk 35+).
///
/// `native_toolchain_rust` runs `cargo build --manifest-path …` without setting
/// cwd to the crate, so Cargo never reads `rust/.cargo/config.toml` (config is
/// discovered from cwd, not the manifest). Pass flags via target RUSTFLAGS env
/// vars instead. Do not read [HookConfig.code] here — web builds invoke this
/// hook without a code-assets extension and would null-crash.
const _android16KbRustflags =
    '-C link-arg=-Wl,-z,max-page-size=16384 '
    '-C link-arg=-Wl,-z,common-page-size=16384';

const _android16KbEnv = <String, String>{
  'CARGO_TARGET_AARCH64_LINUX_ANDROID_RUSTFLAGS': _android16KbRustflags,
  'CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_RUSTFLAGS': _android16KbRustflags,
  'CARGO_TARGET_X86_64_LINUX_ANDROID_RUSTFLAGS': _android16KbRustflags,
};

/// Apple deployment targets for the Rust build.
///
/// `native_toolchain_rust` maps architecture to a target triple and nothing
/// else, so rustc links with its own default minimum (iOS 10.0) while the
/// `cc`-built C/assembly in `aws-lc-sys` (hyper-rustls -> aws-lc-rs) compiles
/// against the SDK default. Objects built for the newer SDK call
/// `___chkstk_darwin`, which is unavailable at iOS 10.0, so the link fails with
/// "Undefined symbols for architecture arm64" and the Xcode archive dies at
/// `Target dart_build failed: Building native assets failed`.
///
/// Setting these makes rustc and cc agree. Ignored for Android/Linux/Windows
/// targets. Keep in sync with apps/flipper/ios/Podfile (platform :ios) and
/// apps/flipper/macos/Podfile (platform :osx).
const _appleDeploymentTargetEnv = <String, String>{
  'IPHONEOS_DEPLOYMENT_TARGET': '16.0',
  'MACOSX_DEPLOYMENT_TARGET': '15.0',
};

void main(List<String> args) async {
  await build(args, (input, output) async {
    await const RustBuilder(
      assetName: 'src/ffi.g.dart',
      extraCargoEnvironmentVariables: {
        ..._android16KbEnv,
        ..._appleDeploymentTargetEnv,
      },
    ).run(input: input, output: output);
  });
}
