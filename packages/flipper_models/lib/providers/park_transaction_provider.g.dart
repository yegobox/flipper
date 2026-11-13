// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod wrapper for [ParkTransactionService] with explicit loading state.

@ProviderFor(ParkTransaction)
final parkTransactionProvider = ParkTransactionProvider._();

/// Riverpod wrapper for [ParkTransactionService] with explicit loading state.
final class ParkTransactionProvider
    extends $AsyncNotifierProvider<ParkTransaction, void> {
  /// Riverpod wrapper for [ParkTransactionService] with explicit loading state.
  ParkTransactionProvider._()
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

String _$parkTransactionHash() => r'c54d5759ff6191c1c7f797746a97df015af4f1d0';

/// Riverpod wrapper for [ParkTransactionService] with explicit loading state.

abstract class _$ParkTransaction extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
