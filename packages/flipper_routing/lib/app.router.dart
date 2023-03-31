// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flipper_models/isar_models.dart' as _i4;
import 'package:flipper_routing/all_routes.dart' as _i2;
import 'package:flutter/material.dart' as _i3;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i5;

class Routes {
  static const startUpView = '/';

  static const signUpView = '/sign-up-view';

  static const flipperApp = '/flipper-app';

  static const loginView = '/login-view';

  static const addProductView = '/add-product-view';

  static const addDiscount = '/add-discount';

  static const listCategories = '/list-categories';

  static const colorTile = '/color-tile';

  static const receiveStock = '/receive-stock';

  static const addVariation = '/add-variation';

  static const addCategory = '/add-category';

  static const listUnits = '/list-units';

  static const sell = '/Sell';

  static const payments = '/Payments';

  static const collectCashView = '/collect-cash-view';

  static const afterSale = '/after-sale';

  static const transactionDetail = '/transaction-detail';

  static const settingsScreen = '/settings-screen';

  static const switchBranchView = '/switch-branch-view';

  static const scannView = '/scann-view';

  static const orderView = '/order-view';

  static const inAppBrowser = '/in-app-browser';

  static const customers = '/Customers';

  static const noNet = '/no-net';

  static const pinLogin = '/pin-login';

  static const devices = '/Devices';

  static const taxConfiguration = '/tax-configuration';

  static const printing = '/Printing';

  static const backUp = '/back-up';

  static const loginChoices = '/login-choices';

  static const tenantAdd = '/tenant-add';

  static const coldStartView = '/cold-start-view';

  static const socialHomeView = '/social-home-view';

  static const all = <String>{
    startUpView,
    signUpView,
    flipperApp,
    loginView,
    addProductView,
    addDiscount,
    listCategories,
    colorTile,
    receiveStock,
    addVariation,
    addCategory,
    listUnits,
    sell,
    payments,
    collectCashView,
    afterSale,
    transactionDetail,
    settingsScreen,
    switchBranchView,
    scannView,
    orderView,
    inAppBrowser,
    customers,
    noNet,
    pinLogin,
    devices,
    taxConfiguration,
    printing,
    backUp,
    loginChoices,
    tenantAdd,
    coldStartView,
    socialHomeView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startUpView,
      page: _i2.StartUpView,
    ),
    _i1.RouteDef(
      Routes.signUpView,
      page: _i2.SignUpView,
    ),
    _i1.RouteDef(
      Routes.flipperApp,
      page: _i2.FlipperApp,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i2.LoginView,
    ),
    _i1.RouteDef(
      Routes.addProductView,
      page: _i2.AddProductView,
    ),
    _i1.RouteDef(
      Routes.addDiscount,
      page: _i2.AddDiscount,
    ),
    _i1.RouteDef(
      Routes.listCategories,
      page: _i2.ListCategories,
    ),
    _i1.RouteDef(
      Routes.colorTile,
      page: _i2.ColorTile,
    ),
    _i1.RouteDef(
      Routes.receiveStock,
      page: _i2.ReceiveStock,
    ),
    _i1.RouteDef(
      Routes.addVariation,
      page: _i2.AddVariation,
    ),
    _i1.RouteDef(
      Routes.addCategory,
      page: _i2.AddCategory,
    ),
    _i1.RouteDef(
      Routes.listUnits,
      page: _i2.ListUnits,
    ),
    _i1.RouteDef(
      Routes.sell,
      page: _i2.Sell,
    ),
    _i1.RouteDef(
      Routes.payments,
      page: _i2.Payments,
    ),
    _i1.RouteDef(
      Routes.collectCashView,
      page: _i2.CollectCashView,
    ),
    _i1.RouteDef(
      Routes.afterSale,
      page: _i2.AfterSale,
    ),
    _i1.RouteDef(
      Routes.transactionDetail,
      page: _i2.TransactionDetail,
    ),
    _i1.RouteDef(
      Routes.settingsScreen,
      page: _i2.SettingsScreen,
    ),
    _i1.RouteDef(
      Routes.switchBranchView,
      page: _i2.SwitchBranchView,
    ),
    _i1.RouteDef(
      Routes.scannView,
      page: _i2.ScannView,
    ),
    _i1.RouteDef(
      Routes.orderView,
      page: _i2.OrderView,
    ),
    _i1.RouteDef(
      Routes.inAppBrowser,
      page: _i2.InAppBrowser,
    ),
    _i1.RouteDef(
      Routes.customers,
      page: _i2.Customers,
    ),
    _i1.RouteDef(
      Routes.noNet,
      page: _i2.NoNet,
    ),
    _i1.RouteDef(
      Routes.pinLogin,
      page: _i2.PinLogin,
    ),
    _i1.RouteDef(
      Routes.devices,
      page: _i2.Devices,
    ),
    _i1.RouteDef(
      Routes.taxConfiguration,
      page: _i2.TaxConfiguration,
    ),
    _i1.RouteDef(
      Routes.printing,
      page: _i2.Printing,
    ),
    _i1.RouteDef(
      Routes.backUp,
      page: _i2.BackUp,
    ),
    _i1.RouteDef(
      Routes.loginChoices,
      page: _i2.LoginChoices,
    ),
    _i1.RouteDef(
      Routes.tenantAdd,
      page: _i2.TenantAdd,
    ),
    _i1.RouteDef(
      Routes.coldStartView,
      page: _i2.ColdStartView,
    ),
    _i1.RouteDef(
      Routes.socialHomeView,
      page: _i2.SocialHomeView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartUpView: (data) {
      final args = data.getArgs<StartUpViewArguments>(
        orElse: () => const StartUpViewArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.StartUpView(key: args.key, invokeLogin: args.invokeLogin),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.SignUpView: (data) {
      final args = data.getArgs<SignUpViewArguments>(
        orElse: () => const SignUpViewArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.SignUpView(key: args.key, countryNm: args.countryNm),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.FlipperApp: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.FlipperApp(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.LoginView: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.LoginView(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.AddProductView: (data) {
      final args = data.getArgs<AddProductViewArguments>(
        orElse: () => const AddProductViewArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.AddProductView(key: args.key, productId: args.productId),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.AddDiscount: (data) {
      final args = data.getArgs<AddDiscountArguments>(
        orElse: () => const AddDiscountArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.AddDiscount(key: args.key, discount: args.discount),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.ListCategories: (data) {
      final args = data.getArgs<ListCategoriesArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.ListCategories(key: args.key, categories: args.categories),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.ColorTile: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.ColorTile(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.ReceiveStock: (data) {
      final args = data.getArgs<ReceiveStockArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.ReceiveStock(
                key: args.key,
                variantId: args.variantId,
                existingStock: args.existingStock),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.AddVariation: (data) {
      final args = data.getArgs<AddVariationArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.AddVariation(key: args.key, productId: args.productId),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.AddCategory: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.AddCategory(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.ListUnits: (data) {
      final args = data.getArgs<ListUnitsArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.ListUnits(key: args.key, type: args.type),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.Sell: (data) {
      final args = data.getArgs<SellArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.Sell(key: args.key, product: args.product),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.Payments: (data) {
      final args = data.getArgs<PaymentsArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.Payments(key: args.key, order: args.order),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.CollectCashView: (data) {
      final args = data.getArgs<CollectCashViewArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.CollectCashView(
                key: args.key,
                paymentType: args.paymentType,
                order: args.order),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.AfterSale: (data) {
      final args = data.getArgs<AfterSaleArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => _i2.AfterSale(
            key: args.key,
            totalOrderAmount: args.totalOrderAmount,
            order: args.order,
            receiptType: args.receiptType),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.TransactionDetail: (data) {
      final args = data.getArgs<TransactionDetailArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.TransactionDetail(key: args.key, order: args.order),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.SettingsScreen: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.SettingsScreen(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.SwitchBranchView: (data) {
      final args = data.getArgs<SwitchBranchViewArguments>(
        orElse: () => const SwitchBranchViewArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.SwitchBranchView(key: args.key),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.ScannView: (data) {
      final args = data.getArgs<ScannViewArguments>(
        orElse: () => const ScannViewArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.ScannView(key: args.key, intent: args.intent),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.OrderView: (data) {
      final args = data.getArgs<OrderViewArguments>(
        orElse: () => const OrderViewArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.OrderView(key: args.key),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.InAppBrowser: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.InAppBrowser(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.Customers: (data) {
      final args = data.getArgs<CustomersArguments>(nullOk: false);
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.Customers(key: args.key, orderId: args.orderId),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.NoNet: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.NoNet(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.PinLogin: (data) {
      final args = data.getArgs<PinLoginArguments>(
        orElse: () => const PinLoginArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.PinLogin(key: args.key),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.Devices: (data) {
      final args = data.getArgs<DevicesArguments>(
        orElse: () => const DevicesArguments(),
      );
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i2.Devices(key: args.key, pin: args.pin),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.TaxConfiguration: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.TaxConfiguration(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.Printing: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.Printing(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.BackUp: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.BackUp(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.LoginChoices: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.LoginChoices(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.TenantAdd: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.TenantAdd(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.ColdStartView: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.ColdStartView(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i2.SocialHomeView: (data) {
      return _i3.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _i2.SocialHomeView(),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class StartUpViewArguments {
  const StartUpViewArguments({
    this.key,
    this.invokeLogin,
  });

  final _i3.Key? key;

  final bool? invokeLogin;

  @override
  String toString() {
    return '{"key": "$key", "invokeLogin": "$invokeLogin"}';
  }
}

class SignUpViewArguments {
  const SignUpViewArguments({
    this.key,
    this.countryNm = "Rwanda",
  });

  final _i3.Key? key;

  final String? countryNm;

  @override
  String toString() {
    return '{"key": "$key", "countryNm": "$countryNm"}';
  }
}

class AddProductViewArguments {
  const AddProductViewArguments({
    this.key,
    this.productId,
  });

  final _i3.Key? key;

  final int? productId;

  @override
  String toString() {
    return '{"key": "$key", "productId": "$productId"}';
  }
}

class AddDiscountArguments {
  const AddDiscountArguments({
    this.key,
    this.discount,
  });

  final _i3.Key? key;

  final _i4.Discount? discount;

  @override
  String toString() {
    return '{"key": "$key", "discount": "$discount"}';
  }
}

class ListCategoriesArguments {
  const ListCategoriesArguments({
    this.key,
    required this.categories,
  });

  final _i3.Key? key;

  final List<_i4.Category> categories;

  @override
  String toString() {
    return '{"key": "$key", "categories": "$categories"}';
  }
}

class ReceiveStockArguments {
  const ReceiveStockArguments({
    this.key,
    required this.variantId,
    this.existingStock,
  });

  final _i3.Key? key;

  final int variantId;

  final String? existingStock;

  @override
  String toString() {
    return '{"key": "$key", "variantId": "$variantId", "existingStock": "$existingStock"}';
  }
}

class AddVariationArguments {
  const AddVariationArguments({
    this.key,
    required this.productId,
  });

  final _i3.Key? key;

  final int productId;

  @override
  String toString() {
    return '{"key": "$key", "productId": "$productId"}';
  }
}

class ListUnitsArguments {
  const ListUnitsArguments({
    this.key,
    required this.type,
  });

  final _i3.Key? key;

  final String type;

  @override
  String toString() {
    return '{"key": "$key", "type": "$type"}';
  }
}

class SellArguments {
  const SellArguments({
    this.key,
    required this.product,
  });

  final _i3.Key? key;

  final _i4.Product product;

  @override
  String toString() {
    return '{"key": "$key", "product": "$product"}';
  }
}

class PaymentsArguments {
  const PaymentsArguments({
    this.key,
    required this.order,
  });

  final _i3.Key? key;

  final _i4.Order order;

  @override
  String toString() {
    return '{"key": "$key", "order": "$order"}';
  }
}

class CollectCashViewArguments {
  const CollectCashViewArguments({
    this.key,
    required this.paymentType,
    required this.order,
  });

  final _i3.Key? key;

  final String paymentType;

  final _i4.Order order;

  @override
  String toString() {
    return '{"key": "$key", "paymentType": "$paymentType", "order": "$order"}';
  }
}

class AfterSaleArguments {
  const AfterSaleArguments({
    this.key,
    required this.totalOrderAmount,
    required this.order,
    this.receiptType = "ns",
  });

  final _i3.Key? key;

  final double totalOrderAmount;

  final _i4.Order order;

  final String? receiptType;

  @override
  String toString() {
    return '{"key": "$key", "totalOrderAmount": "$totalOrderAmount", "order": "$order", "receiptType": "$receiptType"}';
  }
}

class TransactionDetailArguments {
  const TransactionDetailArguments({
    this.key,
    required this.order,
  });

  final _i3.Key? key;

  final _i4.Order order;

  @override
  String toString() {
    return '{"key": "$key", "order": "$order"}';
  }
}

class SwitchBranchViewArguments {
  const SwitchBranchViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }
}

class ScannViewArguments {
  const ScannViewArguments({
    this.key,
    this.intent = 'selling',
  });

  final _i3.Key? key;

  final String intent;

  @override
  String toString() {
    return '{"key": "$key", "intent": "$intent"}';
  }
}

class OrderViewArguments {
  const OrderViewArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }
}

class CustomersArguments {
  const CustomersArguments({
    this.key,
    required this.orderId,
  });

  final _i3.Key? key;

  final int orderId;

  @override
  String toString() {
    return '{"key": "$key", "orderId": "$orderId"}';
  }
}

class PinLoginArguments {
  const PinLoginArguments({this.key});

  final _i3.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }
}

class DevicesArguments {
  const DevicesArguments({
    this.key,
    this.pin,
  });

  final _i3.Key? key;

  final int? pin;

  @override
  String toString() {
    return '{"key": "$key", "pin": "$pin"}';
  }
}

extension NavigatorStateExtension on _i5.NavigationService {
  Future<dynamic> navigateToStartUpView({
    _i3.Key? key,
    bool? invokeLogin,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.startUpView,
        arguments: StartUpViewArguments(key: key, invokeLogin: invokeLogin),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignUpView({
    _i3.Key? key,
    String? countryNm = "Rwanda",
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.signUpView,
        arguments: SignUpViewArguments(key: key, countryNm: countryNm),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFlipperApp([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.flipperApp,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddProductView({
    _i3.Key? key,
    int? productId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addProductView,
        arguments: AddProductViewArguments(key: key, productId: productId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddDiscount({
    _i3.Key? key,
    _i4.Discount? discount,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addDiscount,
        arguments: AddDiscountArguments(key: key, discount: discount),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToListCategories({
    _i3.Key? key,
    required List<_i4.Category> categories,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.listCategories,
        arguments: ListCategoriesArguments(key: key, categories: categories),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToColorTile([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.colorTile,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToReceiveStock({
    _i3.Key? key,
    required int variantId,
    String? existingStock,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.receiveStock,
        arguments: ReceiveStockArguments(
            key: key, variantId: variantId, existingStock: existingStock),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddVariation({
    _i3.Key? key,
    required int productId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addVariation,
        arguments: AddVariationArguments(key: key, productId: productId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddCategory([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addCategory,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToListUnits({
    _i3.Key? key,
    required String type,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.listUnits,
        arguments: ListUnitsArguments(key: key, type: type),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSell({
    _i3.Key? key,
    required _i4.Product product,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.sell,
        arguments: SellArguments(key: key, product: product),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPayments({
    _i3.Key? key,
    required _i4.Order order,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.payments,
        arguments: PaymentsArguments(key: key, order: order),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCollectCashView({
    _i3.Key? key,
    required String paymentType,
    required _i4.Order order,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.collectCashView,
        arguments: CollectCashViewArguments(
            key: key, paymentType: paymentType, order: order),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAfterSale({
    _i3.Key? key,
    required double totalOrderAmount,
    required _i4.Order order,
    String? receiptType = "ns",
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.afterSale,
        arguments: AfterSaleArguments(
            key: key,
            totalOrderAmount: totalOrderAmount,
            order: order,
            receiptType: receiptType),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTransactionDetail({
    _i3.Key? key,
    required _i4.Order order,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.transactionDetail,
        arguments: TransactionDetailArguments(key: key, order: order),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsScreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsScreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSwitchBranchView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.switchBranchView,
        arguments: SwitchBranchViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToScannView({
    _i3.Key? key,
    String intent = 'selling',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.scannView,
        arguments: ScannViewArguments(key: key, intent: intent),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderView,
        arguments: OrderViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToInAppBrowser([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.inAppBrowser,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCustomers({
    _i3.Key? key,
    required int orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.customers,
        arguments: CustomersArguments(key: key, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNoNet([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.noNet,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPinLogin({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.pinLogin,
        arguments: PinLoginArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDevices({
    _i3.Key? key,
    int? pin,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.devices,
        arguments: DevicesArguments(key: key, pin: pin),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTaxConfiguration([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.taxConfiguration,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPrinting([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.printing,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBackUp([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.backUp,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginChoices([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginChoices,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTenantAdd([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.tenantAdd,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToColdStartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.coldStartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSocialHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.socialHomeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartUpView({
    _i3.Key? key,
    bool? invokeLogin,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.startUpView,
        arguments: StartUpViewArguments(key: key, invokeLogin: invokeLogin),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignUpView({
    _i3.Key? key,
    String? countryNm = "Rwanda",
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.signUpView,
        arguments: SignUpViewArguments(key: key, countryNm: countryNm),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFlipperApp([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.flipperApp,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddProductView({
    _i3.Key? key,
    int? productId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addProductView,
        arguments: AddProductViewArguments(key: key, productId: productId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddDiscount({
    _i3.Key? key,
    _i4.Discount? discount,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addDiscount,
        arguments: AddDiscountArguments(key: key, discount: discount),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithListCategories({
    _i3.Key? key,
    required List<_i4.Category> categories,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.listCategories,
        arguments: ListCategoriesArguments(key: key, categories: categories),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithColorTile([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.colorTile,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithReceiveStock({
    _i3.Key? key,
    required int variantId,
    String? existingStock,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.receiveStock,
        arguments: ReceiveStockArguments(
            key: key, variantId: variantId, existingStock: existingStock),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddVariation({
    _i3.Key? key,
    required int productId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addVariation,
        arguments: AddVariationArguments(key: key, productId: productId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddCategory([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addCategory,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithListUnits({
    _i3.Key? key,
    required String type,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.listUnits,
        arguments: ListUnitsArguments(key: key, type: type),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSell({
    _i3.Key? key,
    required _i4.Product product,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.sell,
        arguments: SellArguments(key: key, product: product),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPayments({
    _i3.Key? key,
    required _i4.Order order,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.payments,
        arguments: PaymentsArguments(key: key, order: order),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCollectCashView({
    _i3.Key? key,
    required String paymentType,
    required _i4.Order order,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.collectCashView,
        arguments: CollectCashViewArguments(
            key: key, paymentType: paymentType, order: order),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAfterSale({
    _i3.Key? key,
    required double totalOrderAmount,
    required _i4.Order order,
    String? receiptType = "ns",
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.afterSale,
        arguments: AfterSaleArguments(
            key: key,
            totalOrderAmount: totalOrderAmount,
            order: order,
            receiptType: receiptType),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTransactionDetail({
    _i3.Key? key,
    required _i4.Order order,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.transactionDetail,
        arguments: TransactionDetailArguments(key: key, order: order),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsScreen([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsScreen,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSwitchBranchView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.switchBranchView,
        arguments: SwitchBranchViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithScannView({
    _i3.Key? key,
    String intent = 'selling',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.scannView,
        arguments: ScannViewArguments(key: key, intent: intent),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderView({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderView,
        arguments: OrderViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithInAppBrowser([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.inAppBrowser,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCustomers({
    _i3.Key? key,
    required int orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.customers,
        arguments: CustomersArguments(key: key, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNoNet([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.noNet,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPinLogin({
    _i3.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.pinLogin,
        arguments: PinLoginArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDevices({
    _i3.Key? key,
    int? pin,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.devices,
        arguments: DevicesArguments(key: key, pin: pin),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTaxConfiguration([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.taxConfiguration,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPrinting([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.printing,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBackUp([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.backUp,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginChoices([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginChoices,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTenantAdd([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.tenantAdd,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithColdStartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.coldStartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSocialHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.socialHomeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
