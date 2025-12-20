// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(devicesForBranch)
const devicesForBranchProvider = DevicesForBranchFamily._();

final class DevicesForBranchProvider extends $FunctionalProvider<
        AsyncValue<List<Device>>, List<Device>, FutureOr<List<Device>>>
    with $FutureModifier<List<Device>>, $FutureProvider<List<Device>> {
  const DevicesForBranchProvider._(
      {required DevicesForBranchFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'devicesForBranchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$devicesForBranchHash();

  @override
  String toString() {
    return r'devicesForBranchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Device>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Device>> create(Ref ref) {
    final argument = this.argument as int;
    return devicesForBranch(
      ref,
      branchId: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DevicesForBranchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$devicesForBranchHash() => r'268ba32c393f7251cac837041b1d3f0ba977f117';

final class DevicesForBranchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Device>>, int> {
  const DevicesForBranchFamily._()
      : super(
          retry: null,
          name: r'devicesForBranchProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  DevicesForBranchProvider call({
    required int branchId,
  }) =>
      DevicesForBranchProvider._(argument: branchId, from: this);

  @override
  String toString() => r'devicesForBranchProvider';
}
