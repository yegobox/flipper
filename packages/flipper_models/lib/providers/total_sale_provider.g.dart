// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_sale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TotalSale)
const totalSaleProvider = TotalSaleFamily._();

final class TotalSaleProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  const TotalSaleProvider._(
      {required TotalSaleFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'totalSaleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalSaleHash();

  @override
  String toString() {
    return r'totalSaleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as String;
    return TotalSale(
      ref,
      branchId: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TotalSaleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalSaleHash() => r'ca4aeafa03a148bd15abf3aaa937e077254d2abb';

final class TotalSaleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  const TotalSaleFamily._()
      : super(
          retry: null,
          name: r'totalSaleProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TotalSaleProvider call({
    required String branchId,
  }) =>
      TotalSaleProvider._(argument: branchId, from: this);

  @override
  String toString() => r'totalSaleProvider';
}
