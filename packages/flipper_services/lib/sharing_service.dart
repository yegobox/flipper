import 'abstractions/shareable.dart';
import 'package:share_plus/share_plus.dart';

class SharingService implements Shareable {
  @override
  void share(String shareble) {
    Share.share(shareble, subject: 'And you, you can enjoy flipper!');
  }
}
