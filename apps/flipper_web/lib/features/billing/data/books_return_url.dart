/// Where Dodo sends the customer once the hosted card checkout is done.
///
/// flipper_web uses Flutter's default *hash* URL strategy, so the app route
/// has to sit after `#`. The page at that route reads `planId` and resumes
/// polling the plan, so a customer who pays in the tab Dodo opened still sees
/// Books unlock rather than a paywall that never learned about the payment.
///
/// [base] defaults to the page currently loaded; injectable for tests.
String booksSubscribeReturnUrl(String planId, {Uri? base}) {
  final page = base ?? Uri.base;
  final path = page.path.isEmpty ? '/' : page.path;
  final query = Uri(
    queryParameters: {'planId': planId, 'rail': 'card'},
  ).query;
  // `Uri.origin` is only defined for http(s). Anything else — a `file:` page
  // in a test VM, a desktop build — has nowhere for Dodo to send anyone, so
  // keep the route and drop the host rather than throw mid-payment.
  final origin = page.scheme == 'http' || page.scheme == 'https'
      ? page.origin
      : '';
  return '$origin$path#/subscribe?$query';
}
