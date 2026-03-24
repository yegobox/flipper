// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$ticketsStreamHash() => r'8bac2a9188cd54b86f0c0aee5bf4ff65f9e749f4';
