// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notices)
const noticesProvider = NoticesProvider._();

final class NoticesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Notice>>,
          List<Notice>,
          FutureOr<List<Notice>>
        >
    with $FutureModifier<List<Notice>>, $FutureProvider<List<Notice>> {
  const NoticesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noticesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noticesHash();

  @$internal
  @override
  $FutureProviderElement<List<Notice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Notice>> create(Ref ref) {
    return notices(ref);
  }
}

String _$noticesHash() => r'19958cbd986611fa48a712c2e9fd07b48c2c75de';
