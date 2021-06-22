library flipper_services;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flipper_services/proxy.dart';
import 'abstractions/dynamic_link.dart';

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
  Future handleDynamicLink() async {
    // if the is opened with the link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDnamicLink(data!);
    //app is opened from foreground
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLinkData) async {
      _handleDnamicLink(dynamicLinkData!);
    }, onError: (OnLinkErrorException exception) async {
      print(
          'error opening deepLinkhttps://flipper.page.link/jFcwPBWoU1r5yivT7');
    });
  }

  void _handleDnamicLink(PendingDynamicLinkData data) {
    final Uri? deepLink = data.link;
    if (deepLink != null) {
      print('_deepLink: $deepLink');
    }
  }

  Future<String> createDynamicLink() async {
    // get minimum version from firestore to keep up with update
    final userId = ProxyService.box.read(key: 'userId');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://flipper.page.link',
      link: Uri.parse('https://flipper.page.link/open/?userId=' + userId!),
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
        description: 'flipper open',
      ),
    );
    try {
      final shortLink = await parameters.buildShortLink();
      return shortLink.shortUrl.toString(); //as ShortDynamicLink
    } catch (PlatformException) {
      return "https://play.google.com/store/apps/details?id=rw.flipper";
    }
  }
}
