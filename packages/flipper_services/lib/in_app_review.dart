// import 'package:in_app_review/in_app_review.dart';
import 'dart:math';

abstract class Review {
  void review();
}

class UnSupportedReview implements Review {
  @override
  void review() {
    // TODO: implement review
  }
}

class InAppReviewService implements Review {
  // final InAppReview inAppReview = InAppReview.instance;

  @override
  void review() async {
    Random rnd = Random();
    int min = 8, max = 42;
    int r = min + rnd.nextInt(max - min);

    if (r.isEven) {
      //this is to occasionally show the rating of flipper to the user
      // if (await inAppReview.isAvailable()) {
      //   inAppReview.requestReview();
      // }
    }
  }
}
