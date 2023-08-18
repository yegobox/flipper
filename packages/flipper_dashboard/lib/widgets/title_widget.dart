import 'package:flipper_models/isar_models.dart';

String titleWidget({required HomeViewModel model, required String name}) {
  if (model.amountTotal == 0) {
    return '';
  }
  return name + ' Frw' + model.amountTotal.toStringAsFixed(2);
}
