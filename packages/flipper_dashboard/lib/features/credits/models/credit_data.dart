import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/credit.model.dart';

class CreditData extends ChangeNotifier {
  int _availableCredits = 0;
  final int _maxCredits = 1000000; // Maximum credit limit
  StreamSubscription<Credit?>? _creditSubscription;
  Credit? _creditModel;

  CreditData() {
    _initCreditStream();
  }

  void _initCreditStream() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null) {
      _creditSubscription = ProxyService.strategy
          .credit(
              branchId: (await ProxyService.strategy
                      .branch(serverId: ProxyService.box.getBranchId()!))!
                  .id)
          .listen(_updateCreditData);
    }
  }

  void _updateCreditData(Credit? credit) {
    if (credit != null) {
      _creditModel = credit;
      _availableCredits = credit.credits.toInt();
      notifyListeners();
    }
  }

  int get availableCredits => _availableCredits;
  int get maxCredits => _maxCredits;

  Future<void> buyCredits(int amount) async {
    // Update local state immediately for responsive UI
    _availableCredits += amount;
    if (_availableCredits > _maxCredits) {
      _availableCredits = _maxCredits;
    }
    notifyListeners();

    // The actual credit update will happen through the API and will be reflected
    // when the credit stream emits a new value
  }

  Future<void> useCredits(int amount) async {
    if (_availableCredits >= amount) {
      // Update local state immediately for responsive UI
      _availableCredits -= amount;
      notifyListeners();

      // If we have the credit model, update it through the API
      if (_creditModel != null) {
        // final updatedCredit = _creditModel!.copyWith(credits: _availableCredits);
        // await ProxyService.strategy.updateCredit(updatedCredit);
      }
    }
  }

  @override
  void dispose() {
    _creditSubscription?.cancel();
    super.dispose();
  }
}
