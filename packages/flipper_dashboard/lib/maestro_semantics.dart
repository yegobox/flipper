import 'package:flutter/material.dart';

/// Stable semantics identifiers used by Maestro and other integration tests.
///
/// Keep these IDs stable: flows should prefer them over visible copy because
/// labels may be localized, formatted, or changed during UI polish.
abstract final class MaestroIds {
  static const mposCheckoutScreen = 'flipper.mpos.checkout.screen';
  static const mposCheckoutBack = 'flipper.mpos.checkout.back';
  static const mposAddMoreItems = 'flipper.mpos.checkout.addMoreItems';
  static const mposSaveTicket = 'flipper.mpos.checkout.saveTicket';
  static const mposCheckoutPrimary = 'flipper.mpos.checkout.primary';
  static const mposCheckoutSecondary = 'flipper.mpos.checkout.secondary';

  static const mposCartBar = 'flipper.mpos.cartBar';
  static const mposReviewPay = 'flipper.mpos.reviewPay';

  static const mposCustomerAttach = 'flipper.mpos.customer.attach';
  static const mposCustomerRemove = 'flipper.mpos.customer.remove';

  static const mposPaymentCash = 'flipper.mpos.payment.cash';
  static const mposPaymentMomo = 'flipper.mpos.payment.momo';
  static const mposPaymentCredit = 'flipper.mpos.payment.credit';
  static const mposPaymentCashAmount = 'flipper.mpos.payment.cashAmount';
  static const mposPaymentMomoPhone = 'flipper.mpos.payment.momoPhone';
  static const mposPaymentQuickExact = 'flipper.mpos.payment.quickCash.exact';
  static const mposPaymentQuick5000 = 'flipper.mpos.payment.quickCash.5000';
  static const mposPaymentQuick10000 = 'flipper.mpos.payment.quickCash.10000';
  static const mposPaymentQuick20000 = 'flipper.mpos.payment.quickCash.20000';

  static const mposItemLinePrefix = 'flipper.mpos.item';
}

class MaestroSemantics extends StatelessWidget {
  const MaestroSemantics({
    super.key,
    required this.id,
    required this.child,
    this.label,
    this.button,
    this.textField,
    this.enabled,
    this.selected,
    this.value,
    this.hint,
  });

  final String id;
  final String? label;
  final Widget child;
  final bool? button;
  final bool? textField;
  final bool? enabled;
  final bool? selected;
  final String? value;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: Key(id),
      container: true,
      identifier: id,
      label: label ?? id,
      button: button,
      textField: textField,
      enabled: enabled,
      selected: selected,
      value: value,
      hint: hint,
      child: child,
    );
  }
}
