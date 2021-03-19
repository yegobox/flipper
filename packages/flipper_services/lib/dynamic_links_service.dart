library flipper_services;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'locator.dart';
import 'shared_state_service.dart';

class DynamicLinkService {
  Future handleDynamicLink() async {
    // if the is opened with the link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDnamicLink(data);
    //app is opened from foreground
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
      _handleDnamicLink(dynamicLinkData);
    }, onError: (OnLinkErrorException exception) async {
      print(
          'error opening deepLinkhttps://flipper.page.link/jFcwPBWoU1r5yivT7');
    });
  }

  void _handleDnamicLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_deepLink: $deepLink');
    }
  }

  Future<ShortDynamicLink> createDynamicLink() async {
    // get minimum version from firestore to keep up with update
    final state = locator<SharedStateService>();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://flipper.page.link',
      link:
          Uri.parse('https://flipper.page.link/open/?userId=' + state.user.id),
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
      return shortLink;
    } catch (PlatformException) {
      return null;
    }
  }
}
