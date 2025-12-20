// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'side_nav_bar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SideNavCollapsed)
const sideNavCollapsedProvider = SideNavCollapsedProvider._();

final class SideNavCollapsedProvider
    extends $NotifierProvider<SideNavCollapsed, bool> {
  const SideNavCollapsedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sideNavCollapsedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sideNavCollapsedHash();

  @$internal
  @override
  SideNavCollapsed create() => SideNavCollapsed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sideNavCollapsedHash() => r'af53ed13e8752af25dae6b19c8a33cccecc16900';

abstract class _$SideNavCollapsed extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedNavIndex)
const selectedNavIndexProvider = SelectedNavIndexProvider._();

final class SelectedNavIndexProvider
    extends $NotifierProvider<SelectedNavIndex, int> {
  const SelectedNavIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedNavIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedNavIndexHash();

  @$internal
  @override
  SelectedNavIndex create() => SelectedNavIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedNavIndexHash() => r'620d89537ef670fc39a10b47defdeb356758e120';

abstract class _$SelectedNavIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
