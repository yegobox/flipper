// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_branch_selector.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the selected business

@ProviderFor(SelectedBusiness)
const selectedBusinessProvider = SelectedBusinessProvider._();

/// Provider for the selected business
final class SelectedBusinessProvider
    extends $NotifierProvider<SelectedBusiness, Business?> {
  /// Provider for the selected business
  const SelectedBusinessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBusinessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBusinessHash();

  @$internal
  @override
  SelectedBusiness create() => SelectedBusiness();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Business? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Business?>(value),
    );
  }
}

String _$selectedBusinessHash() => r'2578b9712eb3ee260aecfd52bf47f34ec8b2dbc7';

/// Provider for the selected business

abstract class _$SelectedBusiness extends $Notifier<Business?> {
  Business? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Business?, Business?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Business?, Business?>,
              Business?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for the selected branch

@ProviderFor(SelectedBranch)
const selectedBranchProvider = SelectedBranchProvider._();

/// Provider for the selected branch
final class SelectedBranchProvider
    extends $NotifierProvider<SelectedBranch, Branch?> {
  /// Provider for the selected branch
  const SelectedBranchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBranchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBranchHash();

  @$internal
  @override
  SelectedBranch create() => SelectedBranch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Branch? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Branch?>(value),
    );
  }
}

String _$selectedBranchHash() => r'ee917e3b5c6ea74ba5e0c640b2958c8964ddccfb';

/// Provider for the selected branch

abstract class _$SelectedBranch extends $Notifier<Branch?> {
  Branch? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Branch?, Branch?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Branch?, Branch?>,
              Branch?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
