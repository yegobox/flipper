// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_by_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(branchById)
const branchByIdProvider = BranchByIdFamily._();

final class BranchByIdProvider
    extends $FunctionalProvider<AsyncValue<Branch?>, Branch?, Stream<Branch?>>
    with $FutureModifier<Branch?>, $StreamProvider<Branch?> {
  const BranchByIdProvider._({
    required BranchByIdFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'branchByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$branchByIdHash();

  @override
  String toString() {
    return r'branchByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Branch?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Branch?> create(Ref ref) {
    final argument = this.argument as String?;
    return branchById(ref, branchId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BranchByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$branchByIdHash() => r'fad8f6dd66498578a4ccb008f0e58db2b3524b2f';

final class BranchByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Branch?>, String?> {
  const BranchByIdFamily._()
    : super(
        retry: null,
        name: r'branchByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BranchByIdProvider call({required String? branchId}) =>
      BranchByIdProvider._(argument: branchId, from: this);

  @override
  String toString() => r'branchByIdProvider';
}
