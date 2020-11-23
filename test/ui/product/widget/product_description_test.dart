import 'package:flutter_test/flutter_test.dart';
import 'package:flipper/views/product/widget/product_description_viewmodel.dart';

void main() {
    //NOTE: we learned that we can not put UI invokable class in viewmodel such as TextEditingController as it will make it harder to test our viewmode. see the change I made.
    //NOTE: {Telesphore} added a Unit test ==> correct me I did wrong -> this is what I got
    // better, cheaper, faster.
    group('Test Product Description when about to sell: ', () {
      test('increaseQty', () {
       final model = ProductDescriptionViewmodel();
        model.increaseQty();
        expect(model.quantity, 2.0);
      });


      test('decreaseQty', () {
        final model = ProductDescriptionViewmodel();
        model.decreaseQty();
        expect(model.quantity, 0.0);
      });

      test('With Discount', () {
       final  model = ProductDescriptionViewmodel();
        model.slide(value: 0);
        expect(model.slider, 0.0);
      });
    });
 
}
