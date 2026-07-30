// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Batch payment sums for all visible tickets.
///
/// Streams so peer machines refresh PAID / Partial when
/// `transaction_payment_records` arrive via Ditto (ticket rows alone do not
/// re-emit when only tender lines sync).

@ProviderFor(ticketsPaymentSums)
const ticketsPaymentSumsProvider = TicketsPaymentSumsProvider._();

/// Batch payment sums for all visible tickets.
///
/// Streams so peer machines refresh PAID / Partial when
/// `transaction_payment_records` arrive via Ditto (ticket rows alone do not
/// re-emit when only tender lines sync).

final class TicketsPaymentSumsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          Stream<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $StreamProvider<Map<String, double>> {
  /// Batch payment sums for all visible tickets.
  ///
  /// Streams so peer machines refresh PAID / Partial when
  /// `transaction_payment_records` arrive via Ditto (ticket rows alone do not
  /// re-emit when only tender lines sync).
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
  $StreamProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, double>> create(Ref ref) {
    return ticketsPaymentSums(ref);
  }
}

String _$ticketsPaymentSumsHash() =>
    r'10231d93a7e4c874a1ff782f6cc470f59c274942';

/// Branch-wide open tickets stream (PARKED / WAITING / IN_PROGRESS).
///
/// Does **not** watch [canCollectPosPaymentProvider] — that async role used to
/// tear down and recreate the Ditto observer (losing emits; badge flashed to 0).
/// Staff vs till filtering happens in [visibleTicketsProvider].
///
/// Watches [activeBranchProvider] and waits for [branchId] so the Ditto sync
/// subscription is never registered with a null branch (which would miss
/// cross-device parked tickets for the whole session).

@ProviderFor(ticketsStream)
const ticketsStreamProvider = TicketsStreamProvider._();

/// Branch-wide open tickets stream (PARKED / WAITING / IN_PROGRESS).
///
/// Does **not** watch [canCollectPosPaymentProvider] — that async role used to
/// tear down and recreate the Ditto observer (losing emits; badge flashed to 0).
/// Staff vs till filtering happens in [visibleTicketsProvider].
///
/// Watches [activeBranchProvider] and waits for [branchId] so the Ditto sync
/// subscription is never registered with a null branch (which would miss
/// cross-device parked tickets for the whole session).

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
  ///
  /// Watches [activeBranchProvider] and waits for [branchId] so the Ditto sync
  /// subscription is never registered with a null branch (which would miss
  /// cross-device parked tickets for the whole session).
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

String _$ticketsStreamHash() => r'7570cb66baca53bc8c7b66f4a72d6799293a28f0';

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

String _$reviewQueueStreamHash() => r'dc493022a5c8a5fccd0a3752cd8fa077be4fc242';
