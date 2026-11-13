// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_branch_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeBranch)
final activeBranchProvider = ActiveBranchProvider._();

final class ActiveBranchProvider
    extends $FunctionalProvider<AsyncValue<Branch>, Branch, Stream<Branch>>
    with $FutureModifier<Branch>, $StreamProvider<Branch> {
  ActiveBranchProvider._()
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

String _$activeBranchHash() => r'af2b081d3da7b49c4357695b1f2428e02010b938';
