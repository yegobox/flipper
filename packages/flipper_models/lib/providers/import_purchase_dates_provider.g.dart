// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_purchase_dates_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider to fetch the last import/purchase date for a given branch and request type

@ProviderFor(importPurchaseDates)
const importPurchaseDatesProvider = ImportPurchaseDatesFamily._();

/// Provider to fetch the last import/purchase date for a given branch and request type

final class ImportPurchaseDatesProvider extends $FunctionalProvider<
        AsyncValue<DateTime?>, DateTime?, FutureOr<DateTime?>>
    with $FutureModifier<DateTime?>, $FutureProvider<DateTime?> {
  /// Provider to fetch the last import/purchase date for a given branch and request type
  const ImportPurchaseDatesProvider._(
      {required ImportPurchaseDatesFamily super.from,
      required ({
        String branchId,
        String requestType,
      })
          super.argument})
      : super(
          retry: null,
          name: r'importPurchaseDatesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$importPurchaseDatesHash();

  @override
  String toString() {
    return r'importPurchaseDatesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DateTime?> create(Ref ref) {
    final argument = this.argument as ({
      String branchId,
      String requestType,
    });
    return importPurchaseDates(
      ref,
      branchId: argument.branchId,
      requestType: argument.requestType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ImportPurchaseDatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importPurchaseDatesHash() =>
    r'b38581246fcd47ca60ca59d7a6b6a0c2fcf2ac9f';

/// Provider to fetch the last import/purchase date for a given branch and request type

final class ImportPurchaseDatesFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<DateTime?>,
            ({
              String branchId,
              String requestType,
            })> {
  const ImportPurchaseDatesFamily._()
      : super(
          retry: null,
          name: r'importPurchaseDatesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider to fetch the last import/purchase date for a given branch and request type

  ImportPurchaseDatesProvider call({
    required String branchId,
    required String requestType,
  }) =>
      ImportPurchaseDatesProvider._(argument: (
        branchId: branchId,
        requestType: requestType,
      ), from: this);

  @override
  String toString() => r'importPurchaseDatesProvider';
}
