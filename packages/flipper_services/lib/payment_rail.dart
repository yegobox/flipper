/// Which rail a subscription is billed on.
///
/// Flipper sells one subscription over two rails (`data-connector`:
/// `MOMO_BILLING.md`, `DODO_BILLING.md`). Both drive the same `plans` row, and
/// `plans.payment_method` records which one owns it, so feature gating,
/// billing history and reports never have to know how the customer paid.
///
/// The wire values are the connector's, not ours to choose:
/// [PaymentRail.mtnMomo] writes `MTNMOMO` and [PaymentRail.card] writes `DODO`
/// — the same string the Dodo webhook stamps on the plan when it projects a
/// subscription. Writing anything else here would make the row disagree with
/// itself the moment the first webhook landed.
enum PaymentRail {
  /// MTN Mobile Money. We push a request-to-pay and poll MTN for the verdict.
  mtnMomo('MTNMOMO'),

  /// Card, via Dodo Payments' hosted checkout. Dodo holds the mandate and runs
  /// the renewals; we hand over a link and read the outcome back.
  card('DODO');

  const PaymentRail(this.wireValue);

  /// The value written to `plans.payment_method`.
  final String wireValue;

  /// Reads a stored `plans.payment_method` back.
  ///
  /// Defaults to [PaymentRail.mtnMomo] for anything unrecognised — including
  /// null, and including the legacy `CARD` / `Card` values that older builds
  /// wrote for the retired Paystack flow. MoMo is the rail every existing plan
  /// is on, so it is the only safe default.
  static PaymentRail fromWire(String? value) {
    final normalized = value?.trim().toUpperCase();
    return switch (normalized) {
      'DODO' => PaymentRail.card,
      _ => PaymentRail.mtnMomo,
    };
  }

  String get label => switch (this) {
        PaymentRail.mtnMomo => 'Mobile Money',
        PaymentRail.card => 'Card',
      };

  String get description => switch (this) {
        PaymentRail.mtnMomo => 'Approve on your phone with MTN MoMo',
        PaymentRail.card => 'Pay by Visa or Mastercard',
      };

  bool get isMomo => this == PaymentRail.mtnMomo;
  bool get isCard => this == PaymentRail.card;
}
