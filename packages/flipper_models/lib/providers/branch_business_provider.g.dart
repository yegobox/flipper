// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_business_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Branches the current user may access for [businessId].
///
/// Same source as [LoginChoices] (`Ditto user_access` via `getBranches`).
/// Local Brick rows only enrich fields (e.g. `isDefault`) for those ids —
/// never add branches the user cannot access.

@ProviderFor(branches)
const branchesProvider = BranchesFamily._();

/// Branches the current user may access for [businessId].
///
/// Same source as [LoginChoices] (`Ditto user_access` via `getBranches`).
/// Local Brick rows only enrich fields (e.g. `isDefault`) for those ids —
/// never add branches the user cannot access.

final class BranchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Branch>>,
          List<Branch>,
          FutureOr<List<Branch>>
        >
    with $FutureModifier<List<Branch>>, $FutureProvider<List<Branch>> {
  /// Branches the current user may access for [businessId].
  ///
  /// Same source as [LoginChoices] (`Ditto user_access` via `getBranches`).
  /// Local Brick rows only enrich fields (e.g. `isDefault`) for those ids —
  /// never add branches the user cannot access.
  const BranchesProvider._({
    required BranchesFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'branchesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$branchesHash();

  @override
  String toString() {
    return r'branchesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Branch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Branch>> create(Ref ref) {
    final argument = this.argument as String?;
    return branches(ref, businessId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BranchesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$branchesHash() => r'68602e9497e5f8f5b3ad33807fb6cf4da891eab6';

/// Branches the current user may access for [businessId].
///
/// Same source as [LoginChoices] (`Ditto user_access` via `getBranches`).
/// Local Brick rows only enrich fields (e.g. `isDefault`) for those ids —
/// never add branches the user cannot access.

final class BranchesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Branch>>, String?> {
  const BranchesFamily._()
    : super(
        retry: null,
        name: r'branchesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Branches the current user may access for [businessId].
  ///
  /// Same source as [LoginChoices] (`Ditto user_access` via `getBranches`).
  /// Local Brick rows only enrich fields (e.g. `isDefault`) for those ids —
  /// never add branches the user cannot access.

  BranchesProvider call({String? businessId}) =>
      BranchesProvider._(argument: businessId, from: this);

  @override
  String toString() => r'branchesProvider';
}

/// Every branch row synced for [businessId] (admin screens, e.g. Add Branch).

@ProviderFor(allBusinessBranches)
const allBusinessBranchesProvider = AllBusinessBranchesFamily._();

/// Every branch row synced for [businessId] (admin screens, e.g. Add Branch).

final class AllBusinessBranchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Branch>>,
          List<Branch>,
          FutureOr<List<Branch>>
        >
    with $FutureModifier<List<Branch>>, $FutureProvider<List<Branch>> {
  /// Every branch row synced for [businessId] (admin screens, e.g. Add Branch).
  const AllBusinessBranchesProvider._({
    required AllBusinessBranchesFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'allBusinessBranchesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allBusinessBranchesHash();

  @override
  String toString() {
    return r'allBusinessBranchesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Branch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Branch>> create(Ref ref) {
    final argument = this.argument as String?;
    return allBusinessBranches(ref, businessId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AllBusinessBranchesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allBusinessBranchesHash() =>
    r'4df75da6e9b1af8384792590120647d19db47fae';

/// Every branch row synced for [businessId] (admin screens, e.g. Add Branch).

final class AllBusinessBranchesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Branch>>, String?> {
  const AllBusinessBranchesFamily._()
    : super(
        retry: null,
        name: r'allBusinessBranchesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every branch row synced for [businessId] (admin screens, e.g. Add Branch).

  AllBusinessBranchesProvider call({String? businessId}) =>
      AllBusinessBranchesProvider._(argument: businessId, from: this);

  @override
  String toString() => r'allBusinessBranchesProvider';
}
