// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_business_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(branches)
const branchesProvider = BranchesFamily._();

final class BranchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Branch>>,
          List<Branch>,
          FutureOr<List<Branch>>
        >
    with $FutureModifier<List<Branch>>, $FutureProvider<List<Branch>> {
  const BranchesProvider._({
    required BranchesFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'branchesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$branchesHash();

  @override
  String toString() {
    return r'branchesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Branch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Branch>> create(Ref ref) {
    final argument = this.argument as String?;
    return branches(ref, businessId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BranchesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$branchesHash() => r'02123f5f9843bb1c860e93a513a3737c2c8647da';

final class BranchesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Branch>>, String?> {
  const BranchesFamily._()
    : super(
        retry: null,
        name: r'branchesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BranchesProvider call({String? businessId}) =>
      BranchesProvider._(argument: businessId, from: this);

  @override
  String toString() => r'branchesProvider';
}
