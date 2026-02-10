// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_button_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PayButtonState)
const payButtonStateProvider = PayButtonStateProvider._();

final class PayButtonStateProvider
    extends $NotifierProvider<PayButtonState, Map<ButtonType, bool>> {
  const PayButtonStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payButtonStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payButtonStateHash();

  @$internal
  @override
  PayButtonState create() => PayButtonState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<ButtonType, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<ButtonType, bool>>(value),
    );
  }
}

String _$payButtonStateHash() => r'4c130f58e7c7a43c10766ef53aff85bc7c846f09';

abstract class _$PayButtonState extends $Notifier<Map<ButtonType, bool>> {
  Map<ButtonType, bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<ButtonType, bool>, Map<ButtonType, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<ButtonType, bool>, Map<ButtonType, bool>>,
              Map<ButtonType, bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedButtonType)
const selectedButtonTypeProvider = SelectedButtonTypeProvider._();

final class SelectedButtonTypeProvider
    extends $NotifierProvider<SelectedButtonType, ButtonType> {
  const SelectedButtonTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedButtonTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedButtonTypeHash();

  @$internal
  @override
  SelectedButtonType create() => SelectedButtonType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ButtonType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ButtonType>(value),
    );
  }
}

String _$selectedButtonTypeHash() =>
    r'8e80ef03589c9bc16306a4333443081a239577ca';

abstract class _$SelectedButtonType extends $Notifier<ButtonType> {
  ButtonType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ButtonType, ButtonType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ButtonType, ButtonType>,
              ButtonType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
