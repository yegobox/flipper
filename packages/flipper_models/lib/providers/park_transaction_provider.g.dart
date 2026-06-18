// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod wrapper for [ParkTransactionService] with explicit loading state.

@ProviderFor(ParkTransaction)
const parkTransactionProvider = ParkTransactionProvider._();

/// Riverpod wrapper for [ParkTransactionService] with explicit loading state.
final class ParkTransactionProvider
    extends $AsyncNotifierProvider<ParkTransaction, void> {
  /// Riverpod wrapper for [ParkTransactionService] with explicit loading state.
  const ParkTransactionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parkTransactionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parkTransactionHash();

  @$internal
  @override
  ParkTransaction create() => ParkTransaction();
}

String _$parkTransactionHash() => r'6e488e2c3ca2f0b96ab69e2ebcacf05102e7ada2';

/// Riverpod wrapper for [ParkTransactionService] with explicit loading state.

abstract class _$ParkTransaction extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
