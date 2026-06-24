/// Classifies checkout load failures for the recovery screen.
enum CheckoutErrorKind {
  noBranch,
  generic,
}

CheckoutErrorKind checkoutErrorKindFrom(Object error) {
  final message = error.toString();
  if (message.contains('No default branch selected')) {
    return CheckoutErrorKind.noBranch;
  }
  return CheckoutErrorKind.generic;
}

bool isNoBranchCheckoutError(Object error) =>
    checkoutErrorKindFrom(error) == CheckoutErrorKind.noBranch;

/// User-visible diagnostic code for support (design handoff).
String checkoutErrorDiagnosticCode(Object error) {
  if (isNoBranchCheckoutError(error)) {
    return 'no_default_branch';
  }
  return 'checkout_load_failed';
}
