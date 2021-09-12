library flipper_services;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flipper_services/proxy.dart';
import 'abstractions/dynamic_link.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';

class UnSupportedDynamicLink implements DynamicLink {
  @override
  Future<String> createDynamicLink() async {
    return "https://play.google.com/store/apps/details?id=rw.flipper";
  }

  @override
  Future handleDynamicLink() {
    // TODO: implement handleDynamicLink
    throw UnimplementedError();
  }
}

class DynamicLinkService implements DynamicLink {
  final log = getLogger('DynamicLinkService');
  Future handleDynamicLink() async {
    // if the link is opened with the link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (data != null) {
      _handleDnamicLink(data);
    }
    //app is opened from foreground
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (dynamicLinkData) async {
          _handleDnamicLink(dynamicLinkData!);
        },
        onError: (OnLinkErrorException exception) async {});
  }

  void _handleDnamicLink(PendingDynamicLinkData data) {
    final Uri? deepLink = data.link;

    if (deepLink != null) {
      log.i('_deepLink: $deepLink');
      var isRefer = deepLink.pathSegments.contains('refer');
      if (isRefer) {
        var code = deepLink.queryParameters['code'];
        //save the code in localstorage to be used later
        ProxyService.box.write(key: 'referralCode', value: code.toString());
        ProxyService.nav.navigateTo(Routes.initial);
      }
    }
  }

  Future<String> createDynamicLink() async {
    // get minimum version from firestore to keep up with update
    final userId = ProxyService.box.read(key: 'userId');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://flipper.page.link',
      link: Uri.parse("https://flipper.yegobox.com/refer?code=$userId"),
      androidParameters: AndroidParameters(
        packageName: 'rw.flipper',
        minimumVersion: 1,
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'referral',
        medium: 'social',
        source: 'app',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'flipper',
          description: 'flipper referral system',
          imageUrl:
              Uri.parse('https://flipper.yegobox.com/referral-system.png')),
    );
    try {
      final shortLink = await parameters.buildShortLink();
      log.i(shortLink.shortUrl.toString());
      return shortLink.shortUrl.toString(); //as ShortDynamicLink
    } catch (PlatformException) {
      return "https://play.google.com/store/apps/details?id=rw.flipper";
    }
  }
}
