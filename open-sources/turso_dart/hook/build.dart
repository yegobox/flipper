import 'package:code_assets/code_assets.dart';
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

/// Apple deployment target for the Rust build, taken from the hook input.
///
/// Two problems are solved here, both caused by `native_toolchain_rust` mapping
/// architecture to a target triple and passing no deployment target:
///
/// 1. rustc links `aarch64-apple-ios` at its own default minimum (iOS 10.0)
///    while the `cc`-built C/assembly in `aws-lc-sys` (hyper-rustls ->
///    aws-lc-rs) compiles against the SDK default. Objects built for the newer
///    SDK call `___chkstk_darwin`, unavailable at iOS 10.0, so the link fails
///    with "Undefined symbols for architecture arm64" and the Xcode archive
///    dies at `Target dart_build failed: Building native assets failed`.
///
/// 2. Flutter wraps this dylib in a framework whose `Info.plist` declares
///    `MinimumOSVersion` from its own constant (`targetIOSVersion` in
///    flutter_tools/lib/src/isolated/native_assets/ios/native_assets.dart) and
///    passes the same number here as `iOS.targetVersion`. If the binary's
///    `minos` disagrees with that declaration, App Store Connect rejects the
///    upload with "ITMS-90208: Invalid Bundle - The bundle
///    Runner.app/Frameworks/turso_dart_native.framework does not support the
///    minimum OS Version specified in the Info.plist."
///
/// Reading the value from the input keeps the binary in step with whatever
/// Flutter declares, instead of drifting when that constant changes. Returns an
/// empty map for non-Apple targets and for builds without code assets (web),
/// which carry no [CodeConfig] to read.
Map<String, String> _appleDeploymentTargetEnv(BuildInput input) {
  if (!input.config.buildCodeAssets) return const {};
  final code = input.config.code;
  return switch (code.targetOS) {
    OS.iOS => {'IPHONEOS_DEPLOYMENT_TARGET': '${code.iOS.targetVersion}.0'},
    OS.macOS => {'MACOSX_DEPLOYMENT_TARGET': '${code.macOS.targetVersion}.0'},
    _ => const {},
  };
}

void main(List<String> args) async {
  await build(args, (input, output) async {
    await RustBuilder(
      assetName: 'src/ffi.g.dart',
      extraCargoEnvironmentVariables: {
        ..._android16KbEnv,
        ..._appleDeploymentTargetEnv(input),
      },
    ).run(input: input, output: output);
  });
}
