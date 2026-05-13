// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// After updating focus flags, [categoryProvider]'s underlying stream can
/// emit slightly later; set this synchronously when the user confirms a category so UI
/// (e.g. cashbook Row) reflects the selection immediately. Cleared when the stream matches.

@ProviderFor(OptimisticFocusedCategory)
const optimisticFocusedCategoryProvider = OptimisticFocusedCategoryProvider._();

/// After updating focus flags, [categoryProvider]'s underlying stream can
/// emit slightly later; set this synchronously when the user confirms a category so UI
/// (e.g. cashbook Row) reflects the selection immediately. Cleared when the stream matches.
final class OptimisticFocusedCategoryProvider
    extends $NotifierProvider<OptimisticFocusedCategory, Category?> {
  /// After updating focus flags, [categoryProvider]'s underlying stream can
  /// emit slightly later; set this synchronously when the user confirms a category so UI
  /// (e.g. cashbook Row) reflects the selection immediately. Cleared when the stream matches.
  const OptimisticFocusedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'optimisticFocusedCategoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$optimisticFocusedCategoryHash();

  @$internal
  @override
  OptimisticFocusedCategory create() => OptimisticFocusedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Category? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Category?>(value),
    );
  }
}

String _$optimisticFocusedCategoryHash() =>
    r'ad7ae66ac3ddfda84129fa983f59d36f33b60c39';

/// After updating focus flags, [categoryProvider]'s underlying stream can
/// emit slightly later; set this synchronously when the user confirms a category so UI
/// (e.g. cashbook Row) reflects the selection immediately. Cleared when the stream matches.

abstract class _$OptimisticFocusedCategory extends $Notifier<Category?> {
  Category? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Category?, Category?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Category?, Category?>,
              Category?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(category)
const categoryProvider = CategoryProvider._();

final class CategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  const CategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryHash();

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    return category(ref);
  }
}

String _$categoryHash() => r'078d28b9faa37937a91462d2216464d98605ede6';

@ProviderFor(categories)
const categoriesProvider = CategoriesFamily._();

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  const CategoriesProvider._({
    required CategoriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @override
  String toString() {
    return r'categoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    final argument = this.argument as String;
    return categories(ref, branchId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoriesHash() => r'2cc09d31f52b7081bc5f2e94cbb6fecc59eb2c4d';

final class CategoriesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Category>>, String> {
  const CategoriesFamily._()
    : super(
        retry: null,
        name: r'categoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoriesProvider call({required String branchId}) =>
      CategoriesProvider._(argument: branchId, from: this);

  @override
  String toString() => r'categoriesProvider';
}

/// Ditto-backed category list (Capella). Prefer for screens that should not rely on the
/// default Brick cloudSync category subscription on native.

@ProviderFor(capellaCategories)
const capellaCategoriesProvider = CapellaCategoriesFamily._();

/// Ditto-backed category list (Capella). Prefer for screens that should not rely on the
/// default Brick cloudSync category subscription on native.

final class CapellaCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  /// Ditto-backed category list (Capella). Prefer for screens that should not rely on the
  /// default Brick cloudSync category subscription on native.
  const CapellaCategoriesProvider._({
    required CapellaCategoriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'capellaCategoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$capellaCategoriesHash();

  @override
  String toString() {
    return r'capellaCategoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    final argument = this.argument as String;
    return capellaCategories(ref, branchId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CapellaCategoriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$capellaCategoriesHash() => r'38faeb7e50dbd4bd9becb751d2404699b930a827';

/// Ditto-backed category list (Capella). Prefer for screens that should not rely on the
/// default Brick cloudSync category subscription on native.

final class CapellaCategoriesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Category>>, String> {
  const CapellaCategoriesFamily._()
    : super(
        retry: null,
        name: r'capellaCategoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Ditto-backed category list (Capella). Prefer for screens that should not rely on the
  /// default Brick cloudSync category subscription on native.

  CapellaCategoriesProvider call({required String branchId}) =>
      CapellaCategoriesProvider._(argument: branchId, from: this);

  @override
  String toString() => r'capellaCategoriesProvider';
}
