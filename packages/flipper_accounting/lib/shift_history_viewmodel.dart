import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class ShiftHistoryViewModel extends StreamViewModel<List<Shift>> {
  final int businessId;

  ShiftHistoryViewModel({
    required this.businessId,
  });

  @override
  Stream<List<Shift>> get stream => ProxyService.strategy.getShifts(
        businessId: businessId,
      );
}
