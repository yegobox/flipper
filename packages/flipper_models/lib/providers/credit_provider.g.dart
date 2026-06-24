// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(creditStream)
const creditStreamProvider = CreditStreamFamily._();

final class CreditStreamProvider
    extends $FunctionalProvider<AsyncValue<Credit?>, Credit?, Stream<Credit?>>
    with $FutureModifier<Credit?>, $StreamProvider<Credit?> {
  const CreditStreamProvider._({
    required CreditStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'creditStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$creditStreamHash();

  @override
  String toString() {
    return r'creditStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Credit?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Credit?> create(Ref ref) {
    final argument = this.argument as String;
    return creditStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CreditStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$creditStreamHash() => r'f0ab6f8f1d50f8175daac68ce1562a17b4fa5277';

final class CreditStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Credit?>, String> {
  const CreditStreamFamily._()
    : super(
        retry: null,
        name: r'creditStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreditStreamProvider call(String branchId) =>
      CreditStreamProvider._(argument: branchId, from: this);

  @override
  String toString() => r'creditStreamProvider';
}
