import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

/// Android 16 KB ELF alignment is set in `rust/.cargo/config.toml` for
/// Android target triples only. Do not read [HookConfig.code] here — web
/// builds invoke this hook without a code-assets extension and would null-crash.
void main(List<String> args) async {
  await build(args, (input, output) async {
    await const RustBuilder(
      assetName: 'src/ffi.g.dart',
    ).run(input: input, output: output);
  });
}
