import 'package:flutter_test/flutter_test.dart';
import 'package:flipper/ui/product/widget/product_description_viewmodel.dart';

void main() {
  testWidgets('product description ...', (tester) async {
    //DONE: Test the  increaseQty,decreaseQty,slide
    //NOTES: {Telesphore} added a Unit test ==> correct me I did wrong -> this is what I got
    group('canSubmit -', () {
      test('Test increaseQty can incriment ', () {
       final model = ProductDescriptionViewmodel();
        model.increaseQty();
        expect(model.quantity, 1);
      });
      test('Test decreaseQty can decrease ', () {
        final model = ProductDescriptionViewmodel();
        model.decreaseQty();
        expect(model.quantity, -1);
      });

      test('Test slide button ', () {
       final  model = ProductDescriptionViewmodel();
        model.slide(value: 0);
        expect(model.slider, 100);
      });
    });
  });
}
