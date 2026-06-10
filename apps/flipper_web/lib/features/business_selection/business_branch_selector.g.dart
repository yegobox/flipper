// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_branch_selector.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedBusiness)
const selectedBusinessProvider = SelectedBusinessProvider._();

final class SelectedBusinessProvider
    extends $NotifierProvider<SelectedBusiness, Business?> {
  const SelectedBusinessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBusinessProvider',
        isAutoDispose: false,
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

String _$selectedBusinessHash() => r'6d245760aacf7cb5164401252e78b98a77807743';

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

@ProviderFor(SelectedBranch)
const selectedBranchProvider = SelectedBranchProvider._();

final class SelectedBranchProvider
    extends $NotifierProvider<SelectedBranch, Branch?> {
  const SelectedBranchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBranchProvider',
        isAutoDispose: false,
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

String _$selectedBranchHash() => r'bc99833d82f612166d9cdea59853091eb8be65f0';

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
