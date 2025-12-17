// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totp_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TOTPNotifier)
const tOTPProvider = TOTPNotifierProvider._();

final class TOTPNotifierProvider
    extends $NotifierProvider<TOTPNotifier, TOTPState> {
  const TOTPNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tOTPProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tOTPNotifierHash();

  @$internal
  @override
  TOTPNotifier create() => TOTPNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TOTPState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TOTPState>(value),
    );
  }
}

String _$tOTPNotifierHash() => r'73bfc66a29ee7cfd26d3a891d4b7439d551df472';

abstract class _$TOTPNotifier extends $Notifier<TOTPState> {
  TOTPState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TOTPState, TOTPState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TOTPState, TOTPState>, TOTPState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
