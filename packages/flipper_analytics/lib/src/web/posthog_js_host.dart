/// Where posthog-js is served from: `https://us.i.posthog.com` serves its
/// bundle from `https://us-assets.i.posthog.com`; a self-hosted or proxied
/// host serves it itself.
String assetsHostFor(String host) {
  final base = host.endsWith('/') ? host.substring(0, host.length - 1) : host;
  return '${base.replaceFirst('.i.posthog.com', '-assets.i.posthog.com')}'
      '/static/array.full.js';
}
