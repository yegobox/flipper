import 'package:flipper_models/db_model_export.dart';

String titleWidget({required CoreViewModel model, required String name}) {
  if (model.amountTotal == 0) {
    return '';
  }
  return name + ' Frw' + model.amountTotal.toStringAsFixed(2);
}
