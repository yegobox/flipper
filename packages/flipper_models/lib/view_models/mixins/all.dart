import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';

mixin Properties {
  final settingService = getIt<SettingsService>();
  final languageService = getIt<Language>();
  final KeyPadService keypad = getIt<KeyPadService>();
  final ProductService productService = getIt<ProductService>();
  final AppService app = getIt<AppService>();
  final bool _updateStarted = false;
  Setting? _setting;

  bool newTransactionPressed = false;

  String newTransactionType = 'none';
  String transactionPeriod = "Today";
  String profitType = "Net Profit";

  String passCode = "0";

  Setting? get setting => _setting;
  bool get updateStart => _updateStarted;
  String? defaultLanguage;

  Locale? klocale;

  Locale? get locale => klocale;

  String? categoryName;

  get categories => app.categories;
}

mixin SharebleMethods {
  Stream<Customer?> getCustomer({String? key, String? id}) {
    // Convert FutureOr<List<Customer>> to Future<List<Customer>>
    Future<List<Customer>> customersFuture = Future(() async {
      return await ProxyService.strategy.customers(
          key: key, id: id, branchId: ProxyService.box.getBranchId()!);
    });

    return Stream.fromFuture(customersFuture).asyncExpand((customers) async* {
      // If we have a list of customers, yield each one
      for (var customer in customers) {
        yield customer;
      }
    });
  }

  Stream<List<ITransaction>> getCashInTransactions() {
    final transactions = ProxyService.strategy.transactions(isExpense: false);
    return Stream.value(transactions);
  }

  Stream<List<ITransaction>> getCashOutTransactions() {
    final transactions = ProxyService.strategy.transactions(isExpense: true);
    return Stream.value(transactions);
  }
}
