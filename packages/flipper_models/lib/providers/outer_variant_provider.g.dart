// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outer_variant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OuterVariants)
const outerVariantsProvider = OuterVariantsFamily._();

final class OuterVariantsProvider
    extends $AsyncNotifierProvider<OuterVariants, List<Variant>> {
  const OuterVariantsProvider._(
      {required OuterVariantsFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'outerVariantsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$outerVariantsHash();

  @override
  String toString() {
    return r'outerVariantsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OuterVariants create() => OuterVariants();

  @override
  bool operator ==(Object other) {
    return other is OuterVariantsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$outerVariantsHash() => r'eb215931c88c330061e3777c04cf858338f452aa';

final class OuterVariantsFamily extends $Family
    with
        $ClassFamilyOverride<OuterVariants, AsyncValue<List<Variant>>,
            List<Variant>, FutureOr<List<Variant>>, int> {
  const OuterVariantsFamily._()
      : super(
          retry: null,
          name: r'outerVariantsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  OuterVariantsProvider call(
    int branchId,
  ) =>
      OuterVariantsProvider._(argument: branchId, from: this);

  @override
  String toString() => r'outerVariantsProvider';
}

abstract class _$OuterVariants extends $AsyncNotifier<List<Variant>> {
  late final _$args = ref.$arg as int;
  int get branchId => _$args;

  FutureOr<List<Variant>> build(
    int branchId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<List<Variant>>, List<Variant>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Variant>>, List<Variant>>,
        AsyncValue<List<Variant>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Products)
const productsProvider = ProductsFamily._();

final class ProductsProvider
    extends $AsyncNotifierProvider<Products, List<Product>> {
  const ProductsProvider._(
      {required ProductsFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'productsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @override
  String toString() {
    return r'productsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Products create() => Products();

  @override
  bool operator ==(Object other) {
    return other is ProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsHash() => r'48b3f55713014a116dfd34ad2342668f17108211';

final class ProductsFamily extends $Family
    with
        $ClassFamilyOverride<Products, AsyncValue<List<Product>>, List<Product>,
            FutureOr<List<Product>>, int> {
  const ProductsFamily._()
      : super(
          retry: null,
          name: r'productsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ProductsProvider call(
    int branchId,
  ) =>
      ProductsProvider._(argument: branchId, from: this);

  @override
  String toString() => r'productsProvider';
}

abstract class _$Products extends $AsyncNotifier<List<Product>> {
  late final _$args = ref.$arg as int;
  int get branchId => _$args;

  FutureOr<List<Product>> build(
    int branchId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
        AsyncValue<List<Product>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
