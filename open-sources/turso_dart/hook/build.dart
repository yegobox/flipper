import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

/// Linker flags required for Google Play 16 KB page-size devices.
///
/// `turso_dart` builds via Cargo + NDK clang as linker. Unlike AGP/NDK CMake
/// defaults on NDK r28+, Rust cdylibs still land with 4 KB ELF `p_align` unless
/// these flags are passed explicitly.
const _android16KbRustFlags =
    '-C link-arg=-Wl,-z,max-page-size=16384 '
    '-C link-arg=-Wl,-z,common-page-size=16384';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final isAndroid = input.config.code.targetOS == OS.android;
    final existing = Platform.environment['RUSTFLAGS'] ?? '';
    await RustBuilder(
      assetName: 'src/ffi.g.dart',
      extraCargoEnvironmentVariables: {
        if (isAndroid)
          'RUSTFLAGS': existing.isEmpty
              ? _android16KbRustFlags
              : '$existing $_android16KbRustFlags',
      },
    ).run(input: input, output: output);
  });
}
