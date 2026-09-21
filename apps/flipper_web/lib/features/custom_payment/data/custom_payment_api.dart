import 'package:flipper_payments/flipper_payments.dart';

/// What staff typed on the page.
class CustomPaymentDraft {
  const CustomPaymentDraft({
    required this.businessId,
    required this.amountRwf,
    required this.cadence,
    required this.rail,
    this.phoneNumber,
    this.email,
    this.customerName,
    this.note,
    this.returnUrl,
  });

  final String businessId;
  final int amountRwf;
  final CustomPaymentCadence cadence;
  final CustomPaymentRail rail;
  final String? phoneNumber;
  final String? email;
  final String? customerName;
  final String? note;
  final String? returnUrl;
}

/// The connector's staff endpoints, behind one seam so tests never reach a
/// real payment route.
abstract class CustomPaymentApi {
  Future<CustomPaymentView> create(CustomPaymentDraft draft);

  Future<CustomPaymentView?> awaitSettlement(
    String id, {
    required CustomPaymentRail rail,
    required Duration timeout,
    required Duration pollInterval,
    void Function(CustomPaymentView view)? onStatus,
    bool Function()? isCancelled,
  });

  Future<CustomPaymentView> status(String id, {bool sync = false});

  Future<List<CustomPaymentView>> recentForBusiness(String businessId);
}

/// Real implementation over `flipper_payments`.
class FlipperPaymentsCustomPaymentApi implements CustomPaymentApi {
  FlipperPaymentsCustomPaymentApi({
    required String staffToken,
    PaymentsHttpClient? http,
  }) : _client = CustomPaymentClient(
         http ?? defaultPaymentsHttpClient,
         staffToken: staffToken,
       );

  final CustomPaymentClient _client;

  @override
  Future<CustomPaymentView> create(CustomPaymentDraft draft) => _client.create(
    businessId: draft.businessId,
    amount: draft.amountRwf,
    cadence: draft.cadence,
    rail: draft.rail,
    phoneNumber: draft.phoneNumber,
    email: draft.email,
    customerName: draft.customerName,
    note: draft.note,
    returnUrl: draft.returnUrl,
  );

  @override
  Future<CustomPaymentView?> awaitSettlement(
    String id, {
    required CustomPaymentRail rail,
    required Duration timeout,
    required Duration pollInterval,
    void Function(CustomPaymentView view)? onStatus,
    bool Function()? isCancelled,
  }) => CustomPaymentWatcher(_client).awaitSettlement(
    id,
    rail: rail,
    timeout: timeout,
    pollInterval: pollInterval,
    onStatus: onStatus,
    isCancelled: isCancelled,
  );

  @override
  Future<CustomPaymentView> status(String id, {bool sync = false}) =>
      _client.status(id, sync: sync);

  @override
  Future<List<CustomPaymentView>> recentForBusiness(String businessId) =>
      _client.recentForBusiness(businessId);
}
