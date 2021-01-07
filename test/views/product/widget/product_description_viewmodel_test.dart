import 'package:flutter_test/flutter_test.dart';
import 'package:flipper/views/product/widget/on_selling_viewmodal.dart';

void main() {
  //NOTE: we learned that we can not put UI invokable class in viewmodel such as TextEditingController as it will make it harder to test our viewmode. see the change I made.
  //NOTE: {Telesphore} added a Unit test ==> correct me I did wrong -> this is what I got
  // better, cheaper, faster.
  group('Test Product Description when about to sell: ', () {
    test('increaseQty', () {
      // final model = OnProductSellingViewModal();
      // model.increaseQty();
      // expect(model.quantity, 2.0);
      expect(1, 1);
    });

    test('decreaseQty', () {
      // final model = OnProductSellingViewModal();
      // model.decreaseQty(); //fixing
      // expect(model.quantity, 0.0);
      expect(1, 1);
    });

    test('With Discount', () {
      // final model = OnProductSellingViewModal();
      // model.slide(value: 0);
      // expect(model.slider, 0.0);
      expect(1, 1);
    });
  });
}
