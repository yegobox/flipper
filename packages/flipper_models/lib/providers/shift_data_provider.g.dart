// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shiftData)
const shiftDataProvider = ShiftDataProvider._();

final class ShiftDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShiftData>,
          ShiftData,
          FutureOr<ShiftData>
        >
    with $FutureModifier<ShiftData>, $FutureProvider<ShiftData> {
  const ShiftDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shiftDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shiftDataHash();

  @$internal
  @override
  $FutureProviderElement<ShiftData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ShiftData> create(Ref ref) {
    return shiftData(ref);
  }
}

String _$shiftDataHash() => r'1bcd59218905f1c567839884c094a5bf17870f81';
