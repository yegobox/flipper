// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Branch devices for delegation target pickers.
///
/// Always reads via [Strategy.cloudSync] (Brick → Supabase), **not** Capella/Ditto.
/// Ditto `devices` can lag behind or keep stale rows after reinstall; Supabase is
/// the source of truth for the picker list.

@ProviderFor(devicesForBranch)
const devicesForBranchProvider = DevicesForBranchFamily._();

/// Branch devices for delegation target pickers.
///
/// Always reads via [Strategy.cloudSync] (Brick → Supabase), **not** Capella/Ditto.
/// Ditto `devices` can lag behind or keep stale rows after reinstall; Supabase is
/// the source of truth for the picker list.

final class DevicesForBranchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Device>>,
          List<Device>,
          FutureOr<List<Device>>
        >
    with $FutureModifier<List<Device>>, $FutureProvider<List<Device>> {
  /// Branch devices for delegation target pickers.
  ///
  /// Always reads via [Strategy.cloudSync] (Brick → Supabase), **not** Capella/Ditto.
  /// Ditto `devices` can lag behind or keep stale rows after reinstall; Supabase is
  /// the source of truth for the picker list.
  const DevicesForBranchProvider._({
    required DevicesForBranchFamily super.from,
    required String super.argument,
  }) : super(
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Device>> create(Ref ref) {
    final argument = this.argument as String;
    return devicesForBranch(ref, branchId: argument);
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

String _$devicesForBranchHash() => r'4fcc826894e5ce66a809440d2925f6424306bead';

/// Branch devices for delegation target pickers.
///
/// Always reads via [Strategy.cloudSync] (Brick → Supabase), **not** Capella/Ditto.
/// Ditto `devices` can lag behind or keep stale rows after reinstall; Supabase is
/// the source of truth for the picker list.

final class DevicesForBranchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Device>>, String> {
  const DevicesForBranchFamily._()
    : super(
        retry: null,
        name: r'devicesForBranchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Branch devices for delegation target pickers.
  ///
  /// Always reads via [Strategy.cloudSync] (Brick → Supabase), **not** Capella/Ditto.
  /// Ditto `devices` can lag behind or keep stale rows after reinstall; Supabase is
  /// the source of truth for the picker list.

  DevicesForBranchProvider call({required String branchId}) =>
      DevicesForBranchProvider._(argument: branchId, from: this);

  @override
  String toString() => r'devicesForBranchProvider';
}
