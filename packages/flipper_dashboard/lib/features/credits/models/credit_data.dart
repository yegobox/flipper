import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/models/credit.model.dart';

class CreditData extends ChangeNotifier {
  int _availableCredits = 0;
  final int _maxCredits = 1000000; // Maximum credit limit
  StreamSubscription<List<Map<String, dynamic>>>? _creditSubscription;
  Credit? _creditModel;

  CreditData() {
    _initCreditStream();
  }

  void _initCreditStream() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null) {
      _creditSubscription = Supabase.instance.client
          .from('credits')
          .stream(primaryKey: ['id'])
          .eq('branch_id', branchId)
          .limit(1)
          .listen(_updateCreditData);
    }
  }

  void _updateCreditData(List<Map<String, dynamic>> data) {
    if (data.isNotEmpty) {
      final creditMap = data.first;
      _creditModel = Credit(
        id: creditMap['id'] as String,
        branchId: creditMap['branch_id'] as String?,
        businessId: creditMap['business_id'] as String?,
        credits: (creditMap['credits'] as num).toDouble(),
        createdAt: DateTime.parse(creditMap['created_at'] as String),
        updatedAt: DateTime.parse(creditMap['updated_at'] as String),
        branchServerId: creditMap['branch_server_id']?.toString() ?? '',
      );
      _availableCredits = _creditModel!.credits.toInt();
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
        await ProxyService.strategy.updateCredit(_creditModel!);
      }
    }
  }

  @override
  void dispose() {
    _creditSubscription?.cancel();
    super.dispose();
  }
}
