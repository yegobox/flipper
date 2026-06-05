// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Batch payment sums for all visible tickets (one query per stream update).

@ProviderFor(ticketsPaymentSums)
const ticketsPaymentSumsProvider = TicketsPaymentSumsProvider._();

/// Batch payment sums for all visible tickets (one query per stream update).

final class TicketsPaymentSumsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          FutureOr<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $FutureProvider<Map<String, double>> {
  /// Batch payment sums for all visible tickets (one query per stream update).
  const TicketsPaymentSumsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketsPaymentSumsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketsPaymentSumsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, double>> create(Ref ref) {
    return ticketsPaymentSums(ref);
  }
}

String _$ticketsPaymentSumsHash() =>
    r'10c1d49b0c807cfe4ea55d9453095a4748d0646c';

@ProviderFor(ticketsStream)
const ticketsStreamProvider = TicketsStreamProvider._();

final class TicketsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ITransaction>>,
          List<ITransaction>,
          Stream<List<ITransaction>>
        >
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  const TicketsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ITransaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    return ticketsStream(ref);
  }
}

String _$ticketsStreamHash() => r'594d1a73ae785bd1adc7013c8cb82028eba9b0a6';
