// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_branch_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeBranch)
const activeBranchProvider = ActiveBranchProvider._();

final class ActiveBranchProvider
    extends $FunctionalProvider<AsyncValue<Branch>, Branch, Stream<Branch>>
    with $FutureModifier<Branch>, $StreamProvider<Branch> {
  const ActiveBranchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeBranchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeBranchHash();

  @$internal
  @override
  $StreamProviderElement<Branch> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Branch> create(Ref ref) {
    return activeBranch(ref);
  }
}

String _$activeBranchHash() => r'5c31565b68ec3474f6a2905db8263e27c15f0a51';
