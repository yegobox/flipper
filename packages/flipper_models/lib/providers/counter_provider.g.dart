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
      {required CountersFamily super.from, required int super.argument})
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
    final argument = this.argument as int;
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

String _$countersHash() => r'dd59f67c7a77ff8f4056a21c14922d9fd8acf7e2';

final class CountersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Counter>>, int> {
  const CountersFamily._()
      : super(
          retry: null,
          name: r'countersProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountersProvider call(
    int branchId,
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
      {required HighestCounterFamily super.from, required int super.argument})
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
    final argument = this.argument as int;
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

String _$highestCounterHash() => r'ad3835014d4943737b95e35145ad9b927fc18ac0';

final class HighestCounterFamily extends $Family
    with $FunctionalFamilyOverride<int, int> {
  const HighestCounterFamily._()
      : super(
          retry: null,
          name: r'highestCounterProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  HighestCounterProvider call(
    int branchId,
  ) =>
      HighestCounterProvider._(argument: branchId, from: this);

  @override
  String toString() => r'highestCounterProvider';
}
