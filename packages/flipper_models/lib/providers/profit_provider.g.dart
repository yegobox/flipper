// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Profit)
const profitProvider = ProfitFamily._();

final class ProfitProvider extends $AsyncNotifierProvider<Profit, double> {
  const ProfitProvider._({
    required ProfitFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'profitProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profitHash();

  @override
  String toString() {
    return r'profitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Profit create() => Profit();

  @override
  bool operator ==(Object other) {
    return other is ProfitProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profitHash() => r'2d52323242eb1f46bbf278fa78929ac97d547069';

final class ProfitFamily extends $Family
    with
        $ClassFamilyOverride<
          Profit,
          AsyncValue<double>,
          double,
          FutureOr<double>,
          String
        > {
  const ProfitFamily._()
    : super(
        retry: null,
        name: r'profitProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfitProvider call(String branchId) =>
      ProfitProvider._(argument: branchId, from: this);

  @override
  String toString() => r'profitProvider';
}

abstract class _$Profit extends $AsyncNotifier<double> {
  late final _$args = ref.$arg as String;
  String get branchId => _$args;

  FutureOr<double> build(String branchId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<double>, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<double>, double>,
              AsyncValue<double>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
