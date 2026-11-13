// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Branch devices for delegation target pickers.
///
/// TODO(ditto-migration): deliberately still on Brick → Supabase, **not**
/// Ditto. Ditto `devices` can lag behind or keep stale rows after reinstall;
/// Supabase is the source of truth for the picker list. Porting this needs the
/// staleness handled first — see docs/DITTO_ONLY_MIGRATION.md.

@ProviderFor(devicesForBranch)
final devicesForBranchProvider = DevicesForBranchFamily._();

/// Branch devices for delegation target pickers.
///
/// TODO(ditto-migration): deliberately still on Brick → Supabase, **not**
/// Ditto. Ditto `devices` can lag behind or keep stale rows after reinstall;
/// Supabase is the source of truth for the picker list. Porting this needs the
/// staleness handled first — see docs/DITTO_ONLY_MIGRATION.md.

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
  /// TODO(ditto-migration): deliberately still on Brick → Supabase, **not**
  /// Ditto. Ditto `devices` can lag behind or keep stale rows after reinstall;
  /// Supabase is the source of truth for the picker list. Porting this needs the
  /// staleness handled first — see docs/DITTO_ONLY_MIGRATION.md.
  DevicesForBranchProvider._({
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

String _$devicesForBranchHash() => r'31ed21d523900d21ffd6c6b6cfcebcbbdcdc0275';

/// Branch devices for delegation target pickers.
///
/// TODO(ditto-migration): deliberately still on Brick → Supabase, **not**
/// Ditto. Ditto `devices` can lag behind or keep stale rows after reinstall;
/// Supabase is the source of truth for the picker list. Porting this needs the
/// staleness handled first — see docs/DITTO_ONLY_MIGRATION.md.

final class DevicesForBranchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Device>>, String> {
  DevicesForBranchFamily._()
    : super(
        retry: null,
        name: r'devicesForBranchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Branch devices for delegation target pickers.
  ///
  /// TODO(ditto-migration): deliberately still on Brick → Supabase, **not**
  /// Ditto. Ditto `devices` can lag behind or keep stale rows after reinstall;
  /// Supabase is the source of truth for the picker list. Porting this needs the
  /// staleness handled first — see docs/DITTO_ONLY_MIGRATION.md.

  DevicesForBranchProvider call({required String branchId}) =>
      DevicesForBranchProvider._(argument: branchId, from: this);

  @override
  String toString() => r'devicesForBranchProvider';
}
