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

void main(List<String> args) async {
  await build(args, (input, output) async {
    await const RustBuilder(
      assetName: 'src/ffi.g.dart',
      extraCargoEnvironmentVariables: _android16KbEnv,
    ).run(input: input, output: output);
  });
}
