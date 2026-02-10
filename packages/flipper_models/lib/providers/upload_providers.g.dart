// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UploadProgress)
const uploadProgressProvider = UploadProgressProvider._();

final class UploadProgressProvider
    extends $NotifierProvider<UploadProgress, double> {
  const UploadProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadProgressHash();

  @$internal
  @override
  UploadProgress create() => UploadProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$uploadProgressHash() => r'eab17d35bbb02740b15fbb439eaa2f9934f57817';

abstract class _$UploadProgress extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
