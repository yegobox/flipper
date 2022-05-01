import 'package:flipper_models/isar_models.dart';

String titleWidget(
    {required BusinessHomeViewModel model, required String name}) {
  if (model.amountTotal.toString() == 'null') {
    return name;
  }
  if (model.amountTotal == 0) {
    return '';
  }
  return name + ' Frw' + model.amountTotal.toInt().toString();
}
