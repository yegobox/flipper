// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(category)
const categoryProvider = CategoryProvider._();

final class CategoryProvider extends $FunctionalProvider<
        AsyncValue<List<Category>>, List<Category>, Stream<List<Category>>>
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
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    return category(ref);
  }
}

String _$categoryHash() => r'd7d1a2fc3392925647a96665eac419cdddcd4ec5';

@ProviderFor(categories)
const categoriesProvider = CategoriesFamily._();

final class CategoriesProvider extends $FunctionalProvider<
        AsyncValue<List<Category>>, List<Category>, FutureOr<List<Category>>>
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  const CategoriesProvider._(
      {required CategoriesFamily super.from, required int super.argument})
      : super(
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
  $FutureProviderElement<List<Category>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    final argument = this.argument as int;
    return categories(
      ref,
      branchId: argument,
    );
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

String _$categoriesHash() => r'e90e2e2db04e8e2481c13b480d2296ae92285ff9';

final class CategoriesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Category>>, int> {
  const CategoriesFamily._()
      : super(
          retry: null,
          name: r'categoriesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CategoriesProvider call({
    required int branchId,
  }) =>
      CategoriesProvider._(argument: branchId, from: this);

  @override
  String toString() => r'categoriesProvider';
}
