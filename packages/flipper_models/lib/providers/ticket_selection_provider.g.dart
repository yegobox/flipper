// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_selection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TicketSelection)
const ticketSelectionProvider = TicketSelectionProvider._();

final class TicketSelectionProvider
    extends $NotifierProvider<TicketSelection, Set<String>> {
  const TicketSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketSelectionHash();

  @$internal
  @override
  TicketSelection create() => TicketSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$ticketSelectionHash() => r'785690ca1d4a0017978989585a7abb5e64988398';

abstract class _$TicketSelection extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
