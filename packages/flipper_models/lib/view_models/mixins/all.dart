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
  Stream<Customer?> getCustomer({String? key, int? id}) {
    return Stream.fromFuture(
            ProxyService.realm.getCustomerFuture(key: key, id: id))
        .asyncExpand((customer) async* {
      // Yield the customer as he become available

      yield customer;
    });
  }

  Stream<List<TransactionItem>> transactionItemsStream(
      {required ITransaction transaction}) {
    return Stream.fromFuture(ProxyService.realm.transactionItemsFuture(
            transactionId: transaction.id!,
            doneWithTransaction: false,
            active: false))
        .asyncExpand((items) async* {
      yield items;
    });
  }

  Stream<List<ITransaction>> getCashInTransactions() {
    final transactions = ProxyService.realm.transactions(isExpense: false);
    return Stream.value(transactions);
  }

  Stream<List<ITransaction>> getCashOutTransactions() {
    final transactions = ProxyService.realm.transactions(isExpense: true);
    return Stream.value(transactions);
  }
}
