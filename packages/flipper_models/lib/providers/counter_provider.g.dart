// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(counters)
const countersProvider = CountersFamily._();

final class CountersProvider extends $FunctionalProvider<
        AsyncValue<List<Counter>>, List<Counter>, Stream<List<Counter>>>
    with $FutureModifier<List<Counter>>, $StreamProvider<List<Counter>> {
  const CountersProvider._(
      {required CountersFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'countersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countersHash();

  @override
  String toString() {
    return r'countersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Counter>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Counter>> create(Ref ref) {
    final argument = this.argument as String;
    return counters(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countersHash() => r'26d951ec86bc6daa2bcede94bf201b3f39e90d9f';

final class CountersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Counter>>, String> {
  const CountersFamily._()
      : super(
          retry: null,
          name: r'countersProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountersProvider call(
    String branchId,
  ) =>
      CountersProvider._(argument: branchId, from: this);

  @override
  String toString() => r'countersProvider';
}

@ProviderFor(highestCounter)
const highestCounterProvider = HighestCounterFamily._();

final class HighestCounterProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const HighestCounterProvider._(
      {required HighestCounterFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'highestCounterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$highestCounterHash();

  @override
  String toString() {
    return r'highestCounterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return highestCounter(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HighestCounterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$highestCounterHash() => r'6ce633bf4243d74650b3f11a48a9ef16c05fad03';

final class HighestCounterFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  const HighestCounterFamily._()
      : super(
          retry: null,
          name: r'highestCounterProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  HighestCounterProvider call(
    String branchId,
  ) =>
      HighestCounterProvider._(argument: branchId, from: this);

  @override
  String toString() => r'highestCounterProvider';
}
