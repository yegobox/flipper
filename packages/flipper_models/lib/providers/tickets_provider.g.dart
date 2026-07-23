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
    r'37f97952721cdab3013a4baef9523ee7fb56f8af';

/// Branch-wide open tickets stream (PARKED / WAITING / IN_PROGRESS).
///
/// Does **not** watch [canCollectPosPaymentProvider] — that async role used to
/// tear down and recreate the Ditto observer (losing emits; badge flashed to 0).
/// Staff vs till filtering happens in [visibleTicketsProvider].

@ProviderFor(ticketsStream)
const ticketsStreamProvider = TicketsStreamProvider._();

/// Branch-wide open tickets stream (PARKED / WAITING / IN_PROGRESS).
///
/// Does **not** watch [canCollectPosPaymentProvider] — that async role used to
/// tear down and recreate the Ditto observer (losing emits; badge flashed to 0).
/// Staff vs till filtering happens in [visibleTicketsProvider].

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
  /// Branch-wide open tickets stream (PARKED / WAITING / IN_PROGRESS).
  ///
  /// Does **not** watch [canCollectPosPaymentProvider] — that async role used to
  /// tear down and recreate the Ditto observer (losing emits; badge flashed to 0).
  /// Staff vs till filtering happens in [visibleTicketsProvider].
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

String _$ticketsStreamHash() => r'07d5e457c80998fde1ec25e1824c2d0bfeafe7e8';

/// Ticket Review + Handover workflow: branch-wide tickets awaiting reviewer
/// sign-off (`pendingReview`). Deliberately separate from [ticketsStream] —
/// these tickets do not appear in the normal Tickets list.

@ProviderFor(reviewQueueStream)
const reviewQueueStreamProvider = ReviewQueueStreamProvider._();

/// Ticket Review + Handover workflow: branch-wide tickets awaiting reviewer
/// sign-off (`pendingReview`). Deliberately separate from [ticketsStream] —
/// these tickets do not appear in the normal Tickets list.

final class ReviewQueueStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ITransaction>>,
          List<ITransaction>,
          Stream<List<ITransaction>>
        >
    with
        $FutureModifier<List<ITransaction>>,
        $StreamProvider<List<ITransaction>> {
  /// Ticket Review + Handover workflow: branch-wide tickets awaiting reviewer
  /// sign-off (`pendingReview`). Deliberately separate from [ticketsStream] —
  /// these tickets do not appear in the normal Tickets list.
  const ReviewQueueStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewQueueStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewQueueStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ITransaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ITransaction>> create(Ref ref) {
    return reviewQueueStream(ref);
  }
}

String _$reviewQueueStreamHash() => r'986d5f00cdf2506fae93731cc333cc8aeb5b87f8';
