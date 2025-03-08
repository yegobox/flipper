// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_button_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$payButtonStateHash() => r'4a3e45e03d8feef89f5dab7530b21e2bd132e1ec';

/// See also [PayButtonState].
@ProviderFor(PayButtonState)
final payButtonStateProvider =
    AutoDisposeNotifierProvider<PayButtonState, Map<ButtonType, bool>>.internal(
  PayButtonState.new,
  name: r'payButtonStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$payButtonStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PayButtonState = AutoDisposeNotifier<Map<ButtonType, bool>>;
String _$selectedButtonTypeHash() =>
    r'8e80ef03589c9bc16306a4333443081a239577ca';

/// See also [SelectedButtonType].
@ProviderFor(SelectedButtonType)
final selectedButtonTypeProvider =
    AutoDisposeNotifierProvider<SelectedButtonType, ButtonType>.internal(
  SelectedButtonType.new,
  name: r'selectedButtonTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedButtonTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedButtonType = AutoDisposeNotifier<ButtonType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
