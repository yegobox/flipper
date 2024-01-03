// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i7;

import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as _i5;
import 'package:flipper_models/isar_models.dart' as _i8;
import 'package:flutter/material.dart' as _i4;
import 'package:stacked/stacked.dart' as _i3;
import 'package:stacked_services/stacked_services.dart' as _i2;

import 'all_routes.dart' as _i1;

final stackedRouter =
    StackedRouterWeb(navigatorKey: _i2.StackedService.navigatorKey);

class StackedRouterWeb extends _i3.RootStackRouter {
  StackedRouterWeb({_i4.GlobalKey<_i4.NavigatorState>? navigatorKey})
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    StartUpViewRoute.name: (routeData) {
      final args = routeData.argsAs<StartUpViewArgs>(
          orElse: () => const StartUpViewArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.StartUpView(
          key: args.key,
          invokeLogin: args.invokeLogin,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SignUpViewRoute.name: (routeData) {
      final args = routeData.argsAs<SignUpViewArgs>(
          orElse: () => const SignUpViewArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SignUpView(
          key: args.key,
          countryNm: args.countryNm,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    FlipperAppRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.FlipperApp(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginViewRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.LoginView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CountryPickerRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.CountryPicker(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PhoneInputScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneInputScreenArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PhoneInputScreen(
          key: args.key,
          action: args.action,
          actions: args.actions,
          auth: args.auth,
          countryCode: args.countryCode,
          subtitleBuilder: args.subtitleBuilder,
          footerBuilder: args.footerBuilder,
          headerBuilder: args.headerBuilder,
          headerMaxExtent: args.headerMaxExtent,
          sideBuilder: args.sideBuilder,
          desktopLayoutDirection: args.desktopLayoutDirection,
          breakpoint: args.breakpoint,
          multiFactorSession: args.multiFactorSession,
          mfaHint: args.mfaHint,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AuthOptionPageRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AuthOptionPage(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddProductViewRoute.name: (routeData) {
      final args = routeData.argsAs<AddProductViewArgs>(
          orElse: () => const AddProductViewArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddProductView(
          key: args.key,
          productId: args.productId,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddToFavoritesRoute.name: (routeData) {
      final args = routeData.argsAs<AddToFavoritesArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddToFavorites(
          key: args.key,
          favoriteIndex: args.favoriteIndex,
          existingFavs: args.existingFavs,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddDiscountRoute.name: (routeData) {
      final args = routeData.argsAs<AddDiscountArgs>(
          orElse: () => const AddDiscountArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddDiscount(
          key: args.key,
          discount: args.discount,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ListCategoriesRoute.name: (routeData) {
      final args = routeData.argsAs<ListCategoriesArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ListCategories(
          key: args.key,
          categories: args.categories,
          modeOfOperation: args.modeOfOperation,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ColorTileRoute.name: (routeData) {
      final args =
          routeData.argsAs<ColorTileArgs>(orElse: () => const ColorTileArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ColorTile(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ReceiveStockRoute.name: (routeData) {
      final args = routeData.argsAs<ReceiveStockArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ReceiveStock(
          key: args.key,
          variantId: args.variantId,
          existingStock: args.existingStock,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddVariationRoute.name: (routeData) {
      final args = routeData.argsAs<AddVariationArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddVariation(
          key: args.key,
          productId: args.productId,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddCategoryRoute.name: (routeData) {
      final args = routeData.argsAs<AddCategoryArgs>(
          orElse: () => const AddCategoryArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddCategory(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ListUnitsRoute.name: (routeData) {
      final args = routeData.argsAs<ListUnitsArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ListUnits(
          key: args.key,
          type: args.type,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SellRoute.name: (routeData) {
      final args = routeData.argsAs<SellArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Sell(
          key: args.key,
          product: args.product,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PaymentsRoute.name: (routeData) {
      final args = routeData.argsAs<PaymentsArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Payments(
          key: args.key,
          transaction: args.transaction,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PaymentConfirmationRoute.name: (routeData) {
      final args = routeData.argsAs<PaymentConfirmationArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PaymentConfirmation(
          key: args.key,
          totalTransactionAmount: args.totalTransactionAmount,
          transaction: args.transaction,
          paymentType: args.paymentType,
          receiptType: args.receiptType,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TransactionDetailRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionDetailArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.TransactionDetail(
          key: args.key,
          transaction: args.transaction,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SettingsScreenRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SettingsScreen(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SwitchBranchViewRoute.name: (routeData) {
      final args = routeData.argsAs<SwitchBranchViewArgs>(
          orElse: () => const SwitchBranchViewArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SwitchBranchView(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ScannViewRoute.name: (routeData) {
      final args =
          routeData.argsAs<ScannViewArgs>(orElse: () => const ScannViewArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ScannView(
          key: args.key,
          intent: args.intent,
          useLatestImplementation: args.useLatestImplementation,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    OrderViewRoute.name: (routeData) {
      final args =
          routeData.argsAs<OrderViewArgs>(orElse: () => const OrderViewArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.OrderView(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    OrdersRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Orders(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    InAppBrowserRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.InAppBrowser(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CustomersRoute.name: (routeData) {
      final args =
          routeData.argsAs<CustomersArgs>(orElse: () => const CustomersArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Customers(
          key: args.key,
          transactionId: args.transactionId,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    NoNetRoute.name: (routeData) {
      final args = routeData.argsAs<NoNetArgs>(orElse: () => const NoNetArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.NoNet(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PinLoginRoute.name: (routeData) {
      final args =
          routeData.argsAs<PinLoginArgs>(orElse: () => const PinLoginArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PinLogin(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    DevicesRoute.name: (routeData) {
      final args =
          routeData.argsAs<DevicesArgs>(orElse: () => const DevicesArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Devices(
          key: args.key,
          pin: args.pin,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TaxConfigurationRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.TaxConfiguration(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PrintingRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Printing(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    BackUpRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.BackUp(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginChoicesRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.LoginChoices(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TenantAddRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.TenantAdd(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SocialHomeViewRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.SocialHomeView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    DrawerScreenRoute.name: (routeData) {
      final args = routeData.argsAs<DrawerScreenArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.DrawerScreen(
          key: args.key,
          open: args.open,
          drawer: args.drawer,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ChatListViewRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.ChatListView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ConversationHistoryRoute.name: (routeData) {
      final args = routeData.argsAs<ConversationHistoryArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ConversationHistory(
          key: args.key,
          conversationId: args.conversationId,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TicketsRoute.name: (routeData) {
      final args =
          routeData.argsAs<TicketsArgs>(orElse: () => const TicketsArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Tickets(
          key: args.key,
          transaction: args.transaction,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    NewTicketRoute.name: (routeData) {
      final args = routeData.argsAs<NewTicketArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.NewTicket(
          key: args.key,
          transaction: args.transaction,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AppsRoute.name: (routeData) {
      final args = routeData.argsAs<AppsArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Apps(
          key: args.key,
          controller: args.controller,
          isBigScreen: args.isBigScreen,
          model: args.model,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CheckOutRoute.name: (routeData) {
      final args = routeData.argsAs<CheckOutArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.CheckOut(
          key: args.key,
          isBigScreen: args.isBigScreen,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CashbookRoute.name: (routeData) {
      final args = routeData.argsAs<CashbookArgs>();
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Cashbook(
          key: args.key,
          isBigScreen: args.isBigScreen,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SettingPageRoute.name: (routeData) {
      final args = routeData.argsAs<SettingPageArgs>(
          orElse: () => const SettingPageArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SettingPage(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TransactionsRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Transactions(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SecurityRoute.name: (routeData) {
      final args =
          routeData.argsAs<SecurityArgs>(orElse: () => const SecurityArgs());
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Security(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ComfirmRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Comfirm(),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(
          StartUpViewRoute.name,
          path: '/',
        ),
        _i3.RouteConfig(
          SignUpViewRoute.name,
          path: '/sign-up-view',
        ),
        _i3.RouteConfig(
          FlipperAppRoute.name,
          path: '/flipper-app',
        ),
        _i3.RouteConfig(
          LoginViewRoute.name,
          path: '/login-view',
        ),
        _i3.RouteConfig(
          CountryPickerRoute.name,
          path: '/country-picker',
        ),
        _i3.RouteConfig(
          PhoneInputScreenRoute.name,
          path: '/phone-input-screen',
        ),
        _i3.RouteConfig(
          AuthOptionPageRoute.name,
          path: '/auth-option-page',
        ),
        _i3.RouteConfig(
          AddProductViewRoute.name,
          path: '/add-product-view',
        ),
        _i3.RouteConfig(
          AddToFavoritesRoute.name,
          path: '/add-to-favorites',
        ),
        _i3.RouteConfig(
          AddDiscountRoute.name,
          path: '/add-discount',
        ),
        _i3.RouteConfig(
          ListCategoriesRoute.name,
          path: '/list-categories',
        ),
        _i3.RouteConfig(
          ColorTileRoute.name,
          path: '/color-tile',
        ),
        _i3.RouteConfig(
          ReceiveStockRoute.name,
          path: '/receive-stock',
        ),
        _i3.RouteConfig(
          AddVariationRoute.name,
          path: '/add-variation',
        ),
        _i3.RouteConfig(
          AddCategoryRoute.name,
          path: '/add-category',
        ),
        _i3.RouteConfig(
          ListUnitsRoute.name,
          path: '/list-units',
        ),
        _i3.RouteConfig(
          SellRoute.name,
          path: '/Sell',
        ),
        _i3.RouteConfig(
          PaymentsRoute.name,
          path: '/Payments',
        ),
        _i3.RouteConfig(
          PaymentConfirmationRoute.name,
          path: '/payment-confirmation',
        ),
        _i3.RouteConfig(
          TransactionDetailRoute.name,
          path: '/transaction-detail',
        ),
        _i3.RouteConfig(
          SettingsScreenRoute.name,
          path: '/settings-screen',
        ),
        _i3.RouteConfig(
          SwitchBranchViewRoute.name,
          path: '/switch-branch-view',
        ),
        _i3.RouteConfig(
          ScannViewRoute.name,
          path: '/scann-view',
        ),
        _i3.RouteConfig(
          OrderViewRoute.name,
          path: '/order-view',
        ),
        _i3.RouteConfig(
          OrdersRoute.name,
          path: '/Orders',
        ),
        _i3.RouteConfig(
          InAppBrowserRoute.name,
          path: '/in-app-browser',
        ),
        _i3.RouteConfig(
          CustomersRoute.name,
          path: '/Customers',
        ),
        _i3.RouteConfig(
          NoNetRoute.name,
          path: '/no-net',
        ),
        _i3.RouteConfig(
          PinLoginRoute.name,
          path: '/pin-login',
        ),
        _i3.RouteConfig(
          DevicesRoute.name,
          path: '/Devices',
        ),
        _i3.RouteConfig(
          TaxConfigurationRoute.name,
          path: '/tax-configuration',
        ),
        _i3.RouteConfig(
          PrintingRoute.name,
          path: '/Printing',
        ),
        _i3.RouteConfig(
          BackUpRoute.name,
          path: '/back-up',
        ),
        _i3.RouteConfig(
          LoginChoicesRoute.name,
          path: '/login-choices',
        ),
        _i3.RouteConfig(
          TenantAddRoute.name,
          path: '/tenant-add',
        ),
        _i3.RouteConfig(
          SocialHomeViewRoute.name,
          path: '/social-home-view',
        ),
        _i3.RouteConfig(
          DrawerScreenRoute.name,
          path: '/drawer-screen',
        ),
        _i3.RouteConfig(
          ChatListViewRoute.name,
          path: '/chat-list-view',
        ),
        _i3.RouteConfig(
          ConversationHistoryRoute.name,
          path: '/conversation-history',
        ),
        _i3.RouteConfig(
          TicketsRoute.name,
          path: '/Tickets',
        ),
        _i3.RouteConfig(
          NewTicketRoute.name,
          path: '/new-ticket',
        ),
        _i3.RouteConfig(
          AppsRoute.name,
          path: '/Apps',
        ),
        _i3.RouteConfig(
          CheckOutRoute.name,
          path: '/check-out',
        ),
        _i3.RouteConfig(
          CashbookRoute.name,
          path: '/Cashbook',
        ),
        _i3.RouteConfig(
          SettingPageRoute.name,
          path: '/setting-page',
        ),
        _i3.RouteConfig(
          TransactionsRoute.name,
          path: '/Transactions',
        ),
        _i3.RouteConfig(
          SecurityRoute.name,
          path: '/Security',
        ),
        _i3.RouteConfig(
          ComfirmRoute.name,
          path: '/Comfirm',
        ),
      ];
}

/// generated route for
/// [_i1.StartUpView]
class StartUpViewRoute extends _i3.PageRouteInfo<StartUpViewArgs> {
  StartUpViewRoute({
    _i4.Key? key,
    bool? invokeLogin,
  }) : super(
          StartUpViewRoute.name,
          path: '/',
          args: StartUpViewArgs(
            key: key,
            invokeLogin: invokeLogin,
          ),
        );

  static const String name = 'StartUpView';
}

class StartUpViewArgs {
  const StartUpViewArgs({
    this.key,
    this.invokeLogin,
  });

  final _i4.Key? key;

  final bool? invokeLogin;

  @override
  String toString() {
    return 'StartUpViewArgs{key: $key, invokeLogin: $invokeLogin}';
  }
}

/// generated route for
/// [_i1.SignUpView]
class SignUpViewRoute extends _i3.PageRouteInfo<SignUpViewArgs> {
  SignUpViewRoute({
    _i4.Key? key,
    String? countryNm = "Rwanda",
  }) : super(
          SignUpViewRoute.name,
          path: '/sign-up-view',
          args: SignUpViewArgs(
            key: key,
            countryNm: countryNm,
          ),
        );

  static const String name = 'SignUpView';
}

class SignUpViewArgs {
  const SignUpViewArgs({
    this.key,
    this.countryNm = "Rwanda",
  });

  final _i4.Key? key;

  final String? countryNm;

  @override
  String toString() {
    return 'SignUpViewArgs{key: $key, countryNm: $countryNm}';
  }
}

/// generated route for
/// [_i1.FlipperApp]
class FlipperAppRoute extends _i3.PageRouteInfo<void> {
  const FlipperAppRoute()
      : super(
          FlipperAppRoute.name,
          path: '/flipper-app',
        );

  static const String name = 'FlipperApp';
}

/// generated route for
/// [_i1.LoginView]
class LoginViewRoute extends _i3.PageRouteInfo<void> {
  const LoginViewRoute()
      : super(
          LoginViewRoute.name,
          path: '/login-view',
        );

  static const String name = 'LoginView';
}

/// generated route for
/// [_i1.CountryPicker]
class CountryPickerRoute extends _i3.PageRouteInfo<void> {
  const CountryPickerRoute()
      : super(
          CountryPickerRoute.name,
          path: '/country-picker',
        );

  static const String name = 'CountryPicker';
}

/// generated route for
/// [_i1.PhoneInputScreen]
class PhoneInputScreenRoute extends _i3.PageRouteInfo<PhoneInputScreenArgs> {
  PhoneInputScreenRoute({
    _i4.Key? key,
    _i5.AuthAction? action,
    List<_i5.FirebaseUIAction>? actions,
    _i6.FirebaseAuth? auth,
    required String countryCode,
    _i4.Widget Function(_i4.BuildContext)? subtitleBuilder,
    _i4.Widget Function(_i4.BuildContext)? footerBuilder,
    _i4.Widget Function(
      _i4.BuildContext,
      _i4.BoxConstraints,
      double,
    )? headerBuilder,
    double? headerMaxExtent,
    _i4.Widget Function(
      _i4.BuildContext,
      _i4.BoxConstraints,
    )? sideBuilder,
    _i7.TextDirection? desktopLayoutDirection,
    double breakpoint = 500,
    _i6.MultiFactorSession? multiFactorSession,
    _i6.PhoneMultiFactorInfo? mfaHint,
  }) : super(
          PhoneInputScreenRoute.name,
          path: '/phone-input-screen',
          args: PhoneInputScreenArgs(
            key: key,
            action: action,
            actions: actions,
            auth: auth,
            countryCode: countryCode,
            subtitleBuilder: subtitleBuilder,
            footerBuilder: footerBuilder,
            headerBuilder: headerBuilder,
            headerMaxExtent: headerMaxExtent,
            sideBuilder: sideBuilder,
            desktopLayoutDirection: desktopLayoutDirection,
            breakpoint: breakpoint,
            multiFactorSession: multiFactorSession,
            mfaHint: mfaHint,
          ),
        );

  static const String name = 'PhoneInputScreen';
}

class PhoneInputScreenArgs {
  const PhoneInputScreenArgs({
    this.key,
    this.action,
    this.actions,
    this.auth,
    required this.countryCode,
    this.subtitleBuilder,
    this.footerBuilder,
    this.headerBuilder,
    this.headerMaxExtent,
    this.sideBuilder,
    this.desktopLayoutDirection,
    this.breakpoint = 500,
    this.multiFactorSession,
    this.mfaHint,
  });

  final _i4.Key? key;

  final _i5.AuthAction? action;

  final List<_i5.FirebaseUIAction>? actions;

  final _i6.FirebaseAuth? auth;

  final String countryCode;

  final _i4.Widget Function(_i4.BuildContext)? subtitleBuilder;

  final _i4.Widget Function(_i4.BuildContext)? footerBuilder;

  final _i4.Widget Function(
    _i4.BuildContext,
    _i4.BoxConstraints,
    double,
  )? headerBuilder;

  final double? headerMaxExtent;

  final _i4.Widget Function(
    _i4.BuildContext,
    _i4.BoxConstraints,
  )? sideBuilder;

  final _i7.TextDirection? desktopLayoutDirection;

  final double breakpoint;

  final _i6.MultiFactorSession? multiFactorSession;

  final _i6.PhoneMultiFactorInfo? mfaHint;

  @override
  String toString() {
    return 'PhoneInputScreenArgs{key: $key, action: $action, actions: $actions, auth: $auth, countryCode: $countryCode, subtitleBuilder: $subtitleBuilder, footerBuilder: $footerBuilder, headerBuilder: $headerBuilder, headerMaxExtent: $headerMaxExtent, sideBuilder: $sideBuilder, desktopLayoutDirection: $desktopLayoutDirection, breakpoint: $breakpoint, multiFactorSession: $multiFactorSession, mfaHint: $mfaHint}';
  }
}

/// generated route for
/// [_i1.AuthOptionPage]
class AuthOptionPageRoute extends _i3.PageRouteInfo<void> {
  const AuthOptionPageRoute()
      : super(
          AuthOptionPageRoute.name,
          path: '/auth-option-page',
        );

  static const String name = 'AuthOptionPage';
}

/// generated route for
/// [_i1.AddProductView]
class AddProductViewRoute extends _i3.PageRouteInfo<AddProductViewArgs> {
  AddProductViewRoute({
    _i4.Key? key,
    String? productId,
  }) : super(
          AddProductViewRoute.name,
          path: '/add-product-view',
          args: AddProductViewArgs(
            key: key,
            productId: productId,
          ),
        );

  static const String name = 'AddProductView';
}

class AddProductViewArgs {
  const AddProductViewArgs({
    this.key,
    this.productId,
  });

  final _i4.Key? key;

  final String? productId;

  @override
  String toString() {
    return 'AddProductViewArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i1.AddToFavorites]
class AddToFavoritesRoute extends _i3.PageRouteInfo<AddToFavoritesArgs> {
  AddToFavoritesRoute({
    _i4.Key? key,
    required int favoriteIndex,
    required List<String> existingFavs,
  }) : super(
          AddToFavoritesRoute.name,
          path: '/add-to-favorites',
          args: AddToFavoritesArgs(
            key: key,
            favoriteIndex: favoriteIndex,
            existingFavs: existingFavs,
          ),
        );

  static const String name = 'AddToFavorites';
}

class AddToFavoritesArgs {
  const AddToFavoritesArgs({
    this.key,
    required this.favoriteIndex,
    required this.existingFavs,
  });

  final _i4.Key? key;

  final int favoriteIndex;

  final List<String> existingFavs;

  @override
  String toString() {
    return 'AddToFavoritesArgs{key: $key, favoriteIndex: $favoriteIndex, existingFavs: $existingFavs}';
  }
}

/// generated route for
/// [_i1.AddDiscount]
class AddDiscountRoute extends _i3.PageRouteInfo<AddDiscountArgs> {
  AddDiscountRoute({
    _i4.Key? key,
    _i8.Discount? discount,
  }) : super(
          AddDiscountRoute.name,
          path: '/add-discount',
          args: AddDiscountArgs(
            key: key,
            discount: discount,
          ),
        );

  static const String name = 'AddDiscount';
}

class AddDiscountArgs {
  const AddDiscountArgs({
    this.key,
    this.discount,
  });

  final _i4.Key? key;

  final _i8.Discount? discount;

  @override
  String toString() {
    return 'AddDiscountArgs{key: $key, discount: $discount}';
  }
}

/// generated route for
/// [_i1.ListCategories]
class ListCategoriesRoute extends _i3.PageRouteInfo<ListCategoriesArgs> {
  ListCategoriesRoute({
    _i4.Key? key,
    required List<_i8.Category>? categories,
    required String? modeOfOperation,
  }) : super(
          ListCategoriesRoute.name,
          path: '/list-categories',
          args: ListCategoriesArgs(
            key: key,
            categories: categories,
            modeOfOperation: modeOfOperation,
          ),
        );

  static const String name = 'ListCategories';
}

class ListCategoriesArgs {
  const ListCategoriesArgs({
    this.key,
    required this.categories,
    required this.modeOfOperation,
  });

  final _i4.Key? key;

  final List<_i8.Category>? categories;

  final String? modeOfOperation;

  @override
  String toString() {
    return 'ListCategoriesArgs{key: $key, categories: $categories, modeOfOperation: $modeOfOperation}';
  }
}

/// generated route for
/// [_i1.ColorTile]
class ColorTileRoute extends _i3.PageRouteInfo<ColorTileArgs> {
  ColorTileRoute({_i4.Key? key})
      : super(
          ColorTileRoute.name,
          path: '/color-tile',
          args: ColorTileArgs(key: key),
        );

  static const String name = 'ColorTile';
}

class ColorTileArgs {
  const ColorTileArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'ColorTileArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ReceiveStock]
class ReceiveStockRoute extends _i3.PageRouteInfo<ReceiveStockArgs> {
  ReceiveStockRoute({
    _i4.Key? key,
    required String variantId,
    String? existingStock,
  }) : super(
          ReceiveStockRoute.name,
          path: '/receive-stock',
          args: ReceiveStockArgs(
            key: key,
            variantId: variantId,
            existingStock: existingStock,
          ),
        );

  static const String name = 'ReceiveStock';
}

class ReceiveStockArgs {
  const ReceiveStockArgs({
    this.key,
    required this.variantId,
    this.existingStock,
  });

  final _i4.Key? key;

  final String variantId;

  final String? existingStock;

  @override
  String toString() {
    return 'ReceiveStockArgs{key: $key, variantId: $variantId, existingStock: $existingStock}';
  }
}

/// generated route for
/// [_i1.AddVariation]
class AddVariationRoute extends _i3.PageRouteInfo<AddVariationArgs> {
  AddVariationRoute({
    _i4.Key? key,
    required String productId,
  }) : super(
          AddVariationRoute.name,
          path: '/add-variation',
          args: AddVariationArgs(
            key: key,
            productId: productId,
          ),
        );

  static const String name = 'AddVariation';
}

class AddVariationArgs {
  const AddVariationArgs({
    this.key,
    required this.productId,
  });

  final _i4.Key? key;

  final String productId;

  @override
  String toString() {
    return 'AddVariationArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i1.AddCategory]
class AddCategoryRoute extends _i3.PageRouteInfo<AddCategoryArgs> {
  AddCategoryRoute({_i4.Key? key})
      : super(
          AddCategoryRoute.name,
          path: '/add-category',
          args: AddCategoryArgs(key: key),
        );

  static const String name = 'AddCategory';
}

class AddCategoryArgs {
  const AddCategoryArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'AddCategoryArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ListUnits]
class ListUnitsRoute extends _i3.PageRouteInfo<ListUnitsArgs> {
  ListUnitsRoute({
    _i4.Key? key,
    required String type,
  }) : super(
          ListUnitsRoute.name,
          path: '/list-units',
          args: ListUnitsArgs(
            key: key,
            type: type,
          ),
        );

  static const String name = 'ListUnits';
}

class ListUnitsArgs {
  const ListUnitsArgs({
    this.key,
    required this.type,
  });

  final _i4.Key? key;

  final String type;

  @override
  String toString() {
    return 'ListUnitsArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [_i1.Sell]
class SellRoute extends _i3.PageRouteInfo<SellArgs> {
  SellRoute({
    _i4.Key? key,
    required _i8.Product product,
  }) : super(
          SellRoute.name,
          path: '/Sell',
          args: SellArgs(
            key: key,
            product: product,
          ),
        );

  static const String name = 'Sell';
}

class SellArgs {
  const SellArgs({
    this.key,
    required this.product,
  });

  final _i4.Key? key;

  final _i8.Product product;

  @override
  String toString() {
    return 'SellArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [_i1.Payments]
class PaymentsRoute extends _i3.PageRouteInfo<PaymentsArgs> {
  PaymentsRoute({
    _i4.Key? key,
    required _i8.ITransaction transaction,
  }) : super(
          PaymentsRoute.name,
          path: '/Payments',
          args: PaymentsArgs(
            key: key,
            transaction: transaction,
          ),
        );

  static const String name = 'Payments';
}

class PaymentsArgs {
  const PaymentsArgs({
    this.key,
    required this.transaction,
  });

  final _i4.Key? key;

  final _i8.ITransaction transaction;

  @override
  String toString() {
    return 'PaymentsArgs{key: $key, transaction: $transaction}';
  }
}

/// generated route for
/// [_i1.PaymentConfirmation]
class PaymentConfirmationRoute
    extends _i3.PageRouteInfo<PaymentConfirmationArgs> {
  PaymentConfirmationRoute({
    _i4.Key? key,
    required double totalTransactionAmount,
    required _i8.ITransaction transaction,
    required String paymentType,
    String? receiptType = "ns",
  }) : super(
          PaymentConfirmationRoute.name,
          path: '/payment-confirmation',
          args: PaymentConfirmationArgs(
            key: key,
            totalTransactionAmount: totalTransactionAmount,
            transaction: transaction,
            paymentType: paymentType,
            receiptType: receiptType,
          ),
        );

  static const String name = 'PaymentConfirmation';
}

class PaymentConfirmationArgs {
  const PaymentConfirmationArgs({
    this.key,
    required this.totalTransactionAmount,
    required this.transaction,
    required this.paymentType,
    this.receiptType = "ns",
  });

  final _i4.Key? key;

  final double totalTransactionAmount;

  final _i8.ITransaction transaction;

  final String paymentType;

  final String? receiptType;

  @override
  String toString() {
    return 'PaymentConfirmationArgs{key: $key, totalTransactionAmount: $totalTransactionAmount, transaction: $transaction, paymentType: $paymentType, receiptType: $receiptType}';
  }
}

/// generated route for
/// [_i1.TransactionDetail]
class TransactionDetailRoute extends _i3.PageRouteInfo<TransactionDetailArgs> {
  TransactionDetailRoute({
    _i4.Key? key,
    required _i8.ITransaction transaction,
  }) : super(
          TransactionDetailRoute.name,
          path: '/transaction-detail',
          args: TransactionDetailArgs(
            key: key,
            transaction: transaction,
          ),
        );

  static const String name = 'TransactionDetail';
}

class TransactionDetailArgs {
  const TransactionDetailArgs({
    this.key,
    required this.transaction,
  });

  final _i4.Key? key;

  final _i8.ITransaction transaction;

  @override
  String toString() {
    return 'TransactionDetailArgs{key: $key, transaction: $transaction}';
  }
}

/// generated route for
/// [_i1.SettingsScreen]
class SettingsScreenRoute extends _i3.PageRouteInfo<void> {
  const SettingsScreenRoute()
      : super(
          SettingsScreenRoute.name,
          path: '/settings-screen',
        );

  static const String name = 'SettingsScreen';
}

/// generated route for
/// [_i1.SwitchBranchView]
class SwitchBranchViewRoute extends _i3.PageRouteInfo<SwitchBranchViewArgs> {
  SwitchBranchViewRoute({_i4.Key? key})
      : super(
          SwitchBranchViewRoute.name,
          path: '/switch-branch-view',
          args: SwitchBranchViewArgs(key: key),
        );

  static const String name = 'SwitchBranchView';
}

class SwitchBranchViewArgs {
  const SwitchBranchViewArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'SwitchBranchViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ScannView]
class ScannViewRoute extends _i3.PageRouteInfo<ScannViewArgs> {
  ScannViewRoute({
    _i4.Key? key,
    String intent = 'selling',
    bool useLatestImplementation = false,
  }) : super(
          ScannViewRoute.name,
          path: '/scann-view',
          args: ScannViewArgs(
            key: key,
            intent: intent,
            useLatestImplementation: useLatestImplementation,
          ),
        );

  static const String name = 'ScannView';
}

class ScannViewArgs {
  const ScannViewArgs({
    this.key,
    this.intent = 'selling',
    this.useLatestImplementation = false,
  });

  final _i4.Key? key;

  final String intent;

  final bool useLatestImplementation;

  @override
  String toString() {
    return 'ScannViewArgs{key: $key, intent: $intent, useLatestImplementation: $useLatestImplementation}';
  }
}

/// generated route for
/// [_i1.OrderView]
class OrderViewRoute extends _i3.PageRouteInfo<OrderViewArgs> {
  OrderViewRoute({_i4.Key? key})
      : super(
          OrderViewRoute.name,
          path: '/order-view',
          args: OrderViewArgs(key: key),
        );

  static const String name = 'OrderView';
}

class OrderViewArgs {
  const OrderViewArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'OrderViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Orders]
class OrdersRoute extends _i3.PageRouteInfo<void> {
  const OrdersRoute()
      : super(
          OrdersRoute.name,
          path: '/Orders',
        );

  static const String name = 'Orders';
}

/// generated route for
/// [_i1.InAppBrowser]
class InAppBrowserRoute extends _i3.PageRouteInfo<void> {
  const InAppBrowserRoute()
      : super(
          InAppBrowserRoute.name,
          path: '/in-app-browser',
        );

  static const String name = 'InAppBrowser';
}

/// generated route for
/// [_i1.Customers]
class CustomersRoute extends _i3.PageRouteInfo<CustomersArgs> {
  CustomersRoute({
    _i4.Key? key,
    String? transactionId,
  }) : super(
          CustomersRoute.name,
          path: '/Customers',
          args: CustomersArgs(
            key: key,
            transactionId: transactionId,
          ),
        );

  static const String name = 'Customers';
}

class CustomersArgs {
  const CustomersArgs({
    this.key,
    this.transactionId,
  });

  final _i4.Key? key;

  final String? transactionId;

  @override
  String toString() {
    return 'CustomersArgs{key: $key, transactionId: $transactionId}';
  }
}

/// generated route for
/// [_i1.NoNet]
class NoNetRoute extends _i3.PageRouteInfo<NoNetArgs> {
  NoNetRoute({_i4.Key? key})
      : super(
          NoNetRoute.name,
          path: '/no-net',
          args: NoNetArgs(key: key),
        );

  static const String name = 'NoNet';
}

class NoNetArgs {
  const NoNetArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'NoNetArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.PinLogin]
class PinLoginRoute extends _i3.PageRouteInfo<PinLoginArgs> {
  PinLoginRoute({_i4.Key? key})
      : super(
          PinLoginRoute.name,
          path: '/pin-login',
          args: PinLoginArgs(key: key),
        );

  static const String name = 'PinLogin';
}

class PinLoginArgs {
  const PinLoginArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'PinLoginArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Devices]
class DevicesRoute extends _i3.PageRouteInfo<DevicesArgs> {
  DevicesRoute({
    _i4.Key? key,
    int? pin,
  }) : super(
          DevicesRoute.name,
          path: '/Devices',
          args: DevicesArgs(
            key: key,
            pin: pin,
          ),
        );

  static const String name = 'Devices';
}

class DevicesArgs {
  const DevicesArgs({
    this.key,
    this.pin,
  });

  final _i4.Key? key;

  final int? pin;

  @override
  String toString() {
    return 'DevicesArgs{key: $key, pin: $pin}';
  }
}

/// generated route for
/// [_i1.TaxConfiguration]
class TaxConfigurationRoute extends _i3.PageRouteInfo<void> {
  const TaxConfigurationRoute()
      : super(
          TaxConfigurationRoute.name,
          path: '/tax-configuration',
        );

  static const String name = 'TaxConfiguration';
}

/// generated route for
/// [_i1.Printing]
class PrintingRoute extends _i3.PageRouteInfo<void> {
  const PrintingRoute()
      : super(
          PrintingRoute.name,
          path: '/Printing',
        );

  static const String name = 'Printing';
}

/// generated route for
/// [_i1.BackUp]
class BackUpRoute extends _i3.PageRouteInfo<void> {
  const BackUpRoute()
      : super(
          BackUpRoute.name,
          path: '/back-up',
        );

  static const String name = 'BackUp';
}

/// generated route for
/// [_i1.LoginChoices]
class LoginChoicesRoute extends _i3.PageRouteInfo<void> {
  const LoginChoicesRoute()
      : super(
          LoginChoicesRoute.name,
          path: '/login-choices',
        );

  static const String name = 'LoginChoices';
}

/// generated route for
/// [_i1.TenantAdd]
class TenantAddRoute extends _i3.PageRouteInfo<void> {
  const TenantAddRoute()
      : super(
          TenantAddRoute.name,
          path: '/tenant-add',
        );

  static const String name = 'TenantAdd';
}

/// generated route for
/// [_i1.SocialHomeView]
class SocialHomeViewRoute extends _i3.PageRouteInfo<void> {
  const SocialHomeViewRoute()
      : super(
          SocialHomeViewRoute.name,
          path: '/social-home-view',
        );

  static const String name = 'SocialHomeView';
}

/// generated route for
/// [_i1.DrawerScreen]
class DrawerScreenRoute extends _i3.PageRouteInfo<DrawerScreenArgs> {
  DrawerScreenRoute({
    _i4.Key? key,
    required String open,
    required _i8.Drawers drawer,
  }) : super(
          DrawerScreenRoute.name,
          path: '/drawer-screen',
          args: DrawerScreenArgs(
            key: key,
            open: open,
            drawer: drawer,
          ),
        );

  static const String name = 'DrawerScreen';
}

class DrawerScreenArgs {
  const DrawerScreenArgs({
    this.key,
    required this.open,
    required this.drawer,
  });

  final _i4.Key? key;

  final String open;

  final _i8.Drawers drawer;

  @override
  String toString() {
    return 'DrawerScreenArgs{key: $key, open: $open, drawer: $drawer}';
  }
}

/// generated route for
/// [_i1.ChatListView]
class ChatListViewRoute extends _i3.PageRouteInfo<void> {
  const ChatListViewRoute()
      : super(
          ChatListViewRoute.name,
          path: '/chat-list-view',
        );

  static const String name = 'ChatListView';
}

/// generated route for
/// [_i1.ConversationHistory]
class ConversationHistoryRoute
    extends _i3.PageRouteInfo<ConversationHistoryArgs> {
  ConversationHistoryRoute({
    _i4.Key? key,
    required String conversationId,
  }) : super(
          ConversationHistoryRoute.name,
          path: '/conversation-history',
          args: ConversationHistoryArgs(
            key: key,
            conversationId: conversationId,
          ),
        );

  static const String name = 'ConversationHistory';
}

class ConversationHistoryArgs {
  const ConversationHistoryArgs({
    this.key,
    required this.conversationId,
  });

  final _i4.Key? key;

  final String conversationId;

  @override
  String toString() {
    return 'ConversationHistoryArgs{key: $key, conversationId: $conversationId}';
  }
}

/// generated route for
/// [_i1.Tickets]
class TicketsRoute extends _i3.PageRouteInfo<TicketsArgs> {
  TicketsRoute({
    _i4.Key? key,
    _i8.ITransaction? transaction,
  }) : super(
          TicketsRoute.name,
          path: '/Tickets',
          args: TicketsArgs(
            key: key,
            transaction: transaction,
          ),
        );

  static const String name = 'Tickets';
}

class TicketsArgs {
  const TicketsArgs({
    this.key,
    this.transaction,
  });

  final _i4.Key? key;

  final _i8.ITransaction? transaction;

  @override
  String toString() {
    return 'TicketsArgs{key: $key, transaction: $transaction}';
  }
}

/// generated route for
/// [_i1.NewTicket]
class NewTicketRoute extends _i3.PageRouteInfo<NewTicketArgs> {
  NewTicketRoute({
    _i4.Key? key,
    required _i8.ITransaction transaction,
  }) : super(
          NewTicketRoute.name,
          path: '/new-ticket',
          args: NewTicketArgs(
            key: key,
            transaction: transaction,
          ),
        );

  static const String name = 'NewTicket';
}

class NewTicketArgs {
  const NewTicketArgs({
    this.key,
    required this.transaction,
  });

  final _i4.Key? key;

  final _i8.ITransaction transaction;

  @override
  String toString() {
    return 'NewTicketArgs{key: $key, transaction: $transaction}';
  }
}

/// generated route for
/// [_i1.Apps]
class AppsRoute extends _i3.PageRouteInfo<AppsArgs> {
  AppsRoute({
    _i4.Key? key,
    required _i4.TextEditingController controller,
    required bool isBigScreen,
    required _i8.CoreViewModel model,
  }) : super(
          AppsRoute.name,
          path: '/Apps',
          args: AppsArgs(
            key: key,
            controller: controller,
            isBigScreen: isBigScreen,
            model: model,
          ),
        );

  static const String name = 'Apps';
}

class AppsArgs {
  const AppsArgs({
    this.key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
  });

  final _i4.Key? key;

  final _i4.TextEditingController controller;

  final bool isBigScreen;

  final _i8.CoreViewModel model;

  @override
  String toString() {
    return 'AppsArgs{key: $key, controller: $controller, isBigScreen: $isBigScreen, model: $model}';
  }
}

/// generated route for
/// [_i1.CheckOut]
class CheckOutRoute extends _i3.PageRouteInfo<CheckOutArgs> {
  CheckOutRoute({
    _i4.Key? key,
    required bool isBigScreen,
  }) : super(
          CheckOutRoute.name,
          path: '/check-out',
          args: CheckOutArgs(
            key: key,
            isBigScreen: isBigScreen,
          ),
        );

  static const String name = 'CheckOut';
}

class CheckOutArgs {
  const CheckOutArgs({
    this.key,
    required this.isBigScreen,
  });

  final _i4.Key? key;

  final bool isBigScreen;

  @override
  String toString() {
    return 'CheckOutArgs{key: $key, isBigScreen: $isBigScreen}';
  }
}

/// generated route for
/// [_i1.Cashbook]
class CashbookRoute extends _i3.PageRouteInfo<CashbookArgs> {
  CashbookRoute({
    _i4.Key? key,
    required bool isBigScreen,
  }) : super(
          CashbookRoute.name,
          path: '/Cashbook',
          args: CashbookArgs(
            key: key,
            isBigScreen: isBigScreen,
          ),
        );

  static const String name = 'Cashbook';
}

class CashbookArgs {
  const CashbookArgs({
    this.key,
    required this.isBigScreen,
  });

  final _i4.Key? key;

  final bool isBigScreen;

  @override
  String toString() {
    return 'CashbookArgs{key: $key, isBigScreen: $isBigScreen}';
  }
}

/// generated route for
/// [_i1.SettingPage]
class SettingPageRoute extends _i3.PageRouteInfo<SettingPageArgs> {
  SettingPageRoute({_i4.Key? key})
      : super(
          SettingPageRoute.name,
          path: '/setting-page',
          args: SettingPageArgs(key: key),
        );

  static const String name = 'SettingPage';
}

class SettingPageArgs {
  const SettingPageArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'SettingPageArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Transactions]
class TransactionsRoute extends _i3.PageRouteInfo<void> {
  const TransactionsRoute()
      : super(
          TransactionsRoute.name,
          path: '/Transactions',
        );

  static const String name = 'Transactions';
}

/// generated route for
/// [_i1.Security]
class SecurityRoute extends _i3.PageRouteInfo<SecurityArgs> {
  SecurityRoute({_i4.Key? key})
      : super(
          SecurityRoute.name,
          path: '/Security',
          args: SecurityArgs(key: key),
        );

  static const String name = 'Security';
}

class SecurityArgs {
  const SecurityArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'SecurityArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Comfirm]
class ComfirmRoute extends _i3.PageRouteInfo<void> {
  const ComfirmRoute()
      : super(
          ComfirmRoute.name,
          path: '/Comfirm',
        );

  static const String name = 'Comfirm';
}

extension RouterStateExtension on _i2.RouterService {
  Future<dynamic> navigateToStartUpView({
    _i4.Key? key,
    bool? invokeLogin,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      StartUpViewRoute(
        key: key,
        invokeLogin: invokeLogin,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSignUpView({
    _i4.Key? key,
    String? countryNm = "Rwanda",
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SignUpViewRoute(
        key: key,
        countryNm: countryNm,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToFlipperApp(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const FlipperAppRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToLoginView(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCountryPicker(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const CountryPickerRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPhoneInputScreen({
    _i4.Key? key,
    _i5.AuthAction? action,
    List<_i5.FirebaseUIAction>? actions,
    _i6.FirebaseAuth? auth,
    required String countryCode,
    _i4.Widget Function(_i4.BuildContext)? subtitleBuilder,
    _i4.Widget Function(_i4.BuildContext)? footerBuilder,
    _i4.Widget Function(
      _i4.BuildContext,
      _i4.BoxConstraints,
      double,
    )? headerBuilder,
    double? headerMaxExtent,
    _i4.Widget Function(
      _i4.BuildContext,
      _i4.BoxConstraints,
    )? sideBuilder,
    _i7.TextDirection? desktopLayoutDirection,
    double breakpoint = 500,
    _i6.MultiFactorSession? multiFactorSession,
    _i6.PhoneMultiFactorInfo? mfaHint,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PhoneInputScreenRoute(
        key: key,
        action: action,
        actions: actions,
        auth: auth,
        countryCode: countryCode,
        subtitleBuilder: subtitleBuilder,
        footerBuilder: footerBuilder,
        headerBuilder: headerBuilder,
        headerMaxExtent: headerMaxExtent,
        sideBuilder: sideBuilder,
        desktopLayoutDirection: desktopLayoutDirection,
        breakpoint: breakpoint,
        multiFactorSession: multiFactorSession,
        mfaHint: mfaHint,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAuthOptionPage(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const AuthOptionPageRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddProductView({
    _i4.Key? key,
    String? productId,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddProductViewRoute(
        key: key,
        productId: productId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddToFavorites({
    _i4.Key? key,
    required int favoriteIndex,
    required List<String> existingFavs,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddToFavoritesRoute(
        key: key,
        favoriteIndex: favoriteIndex,
        existingFavs: existingFavs,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddDiscount({
    _i4.Key? key,
    _i8.Discount? discount,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddDiscountRoute(
        key: key,
        discount: discount,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToListCategories({
    _i4.Key? key,
    required List<_i8.Category>? categories,
    required String? modeOfOperation,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ListCategoriesRoute(
        key: key,
        categories: categories,
        modeOfOperation: modeOfOperation,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToColorTile({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ColorTileRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToReceiveStock({
    _i4.Key? key,
    required String variantId,
    String? existingStock,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ReceiveStockRoute(
        key: key,
        variantId: variantId,
        existingStock: existingStock,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddVariation({
    _i4.Key? key,
    required String productId,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddVariationRoute(
        key: key,
        productId: productId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddCategory({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddCategoryRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToListUnits({
    _i4.Key? key,
    required String type,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ListUnitsRoute(
        key: key,
        type: type,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSell({
    _i4.Key? key,
    required _i8.Product product,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SellRoute(
        key: key,
        product: product,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPayments({
    _i4.Key? key,
    required _i8.ITransaction transaction,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PaymentsRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPaymentConfirmation({
    _i4.Key? key,
    required double totalTransactionAmount,
    required _i8.ITransaction transaction,
    required String paymentType,
    String? receiptType = "ns",
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PaymentConfirmationRoute(
        key: key,
        totalTransactionAmount: totalTransactionAmount,
        transaction: transaction,
        paymentType: paymentType,
        receiptType: receiptType,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTransactionDetail({
    _i4.Key? key,
    required _i8.ITransaction transaction,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      TransactionDetailRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSettingsScreen(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const SettingsScreenRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSwitchBranchView({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SwitchBranchViewRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToScannView({
    _i4.Key? key,
    String intent = 'selling',
    bool useLatestImplementation = false,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ScannViewRoute(
        key: key,
        intent: intent,
        useLatestImplementation: useLatestImplementation,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToOrderView({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      OrderViewRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToOrders(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const OrdersRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToInAppBrowser(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const InAppBrowserRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCustomers({
    _i4.Key? key,
    String? transactionId,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      CustomersRoute(
        key: key,
        transactionId: transactionId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToNoNet({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      NoNetRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPinLogin({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PinLoginRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToDevices({
    _i4.Key? key,
    int? pin,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      DevicesRoute(
        key: key,
        pin: pin,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTaxConfiguration(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const TaxConfigurationRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPrinting(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const PrintingRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToBackUp(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const BackUpRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToLoginChoices(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LoginChoicesRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTenantAdd(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const TenantAddRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSocialHomeView(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const SocialHomeViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToDrawerScreen({
    _i4.Key? key,
    required String open,
    required _i8.Drawers drawer,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      DrawerScreenRoute(
        key: key,
        open: open,
        drawer: drawer,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToChatListView(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ChatListViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToConversationHistory({
    _i4.Key? key,
    required String conversationId,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ConversationHistoryRoute(
        key: key,
        conversationId: conversationId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTickets({
    _i4.Key? key,
    _i8.ITransaction? transaction,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      TicketsRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToNewTicket({
    _i4.Key? key,
    required _i8.ITransaction transaction,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      NewTicketRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToApps({
    _i4.Key? key,
    required _i4.TextEditingController controller,
    required bool isBigScreen,
    required _i8.CoreViewModel model,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AppsRoute(
        key: key,
        controller: controller,
        isBigScreen: isBigScreen,
        model: model,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCheckOut({
    _i4.Key? key,
    required bool isBigScreen,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      CheckOutRoute(
        key: key,
        isBigScreen: isBigScreen,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCashbook({
    _i4.Key? key,
    required bool isBigScreen,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      CashbookRoute(
        key: key,
        isBigScreen: isBigScreen,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSettingPage({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SettingPageRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTransactions(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const TransactionsRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSecurity({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SecurityRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToComfirm(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ComfirmRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithStartUpView({
    _i4.Key? key,
    bool? invokeLogin,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      StartUpViewRoute(
        key: key,
        invokeLogin: invokeLogin,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSignUpView({
    _i4.Key? key,
    String? countryNm = "Rwanda",
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SignUpViewRoute(
        key: key,
        countryNm: countryNm,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithFlipperApp(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const FlipperAppRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithLoginView(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LoginViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCountryPicker(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const CountryPickerRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPhoneInputScreen({
    _i4.Key? key,
    _i5.AuthAction? action,
    List<_i5.FirebaseUIAction>? actions,
    _i6.FirebaseAuth? auth,
    required String countryCode,
    _i4.Widget Function(_i4.BuildContext)? subtitleBuilder,
    _i4.Widget Function(_i4.BuildContext)? footerBuilder,
    _i4.Widget Function(
      _i4.BuildContext,
      _i4.BoxConstraints,
      double,
    )? headerBuilder,
    double? headerMaxExtent,
    _i4.Widget Function(
      _i4.BuildContext,
      _i4.BoxConstraints,
    )? sideBuilder,
    _i7.TextDirection? desktopLayoutDirection,
    double breakpoint = 500,
    _i6.MultiFactorSession? multiFactorSession,
    _i6.PhoneMultiFactorInfo? mfaHint,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PhoneInputScreenRoute(
        key: key,
        action: action,
        actions: actions,
        auth: auth,
        countryCode: countryCode,
        subtitleBuilder: subtitleBuilder,
        footerBuilder: footerBuilder,
        headerBuilder: headerBuilder,
        headerMaxExtent: headerMaxExtent,
        sideBuilder: sideBuilder,
        desktopLayoutDirection: desktopLayoutDirection,
        breakpoint: breakpoint,
        multiFactorSession: multiFactorSession,
        mfaHint: mfaHint,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAuthOptionPage(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const AuthOptionPageRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddProductView({
    _i4.Key? key,
    String? productId,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddProductViewRoute(
        key: key,
        productId: productId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddToFavorites({
    _i4.Key? key,
    required int favoriteIndex,
    required List<String> existingFavs,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddToFavoritesRoute(
        key: key,
        favoriteIndex: favoriteIndex,
        existingFavs: existingFavs,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddDiscount({
    _i4.Key? key,
    _i8.Discount? discount,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddDiscountRoute(
        key: key,
        discount: discount,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithListCategories({
    _i4.Key? key,
    required List<_i8.Category>? categories,
    required String? modeOfOperation,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ListCategoriesRoute(
        key: key,
        categories: categories,
        modeOfOperation: modeOfOperation,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithColorTile({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ColorTileRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithReceiveStock({
    _i4.Key? key,
    required String variantId,
    String? existingStock,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ReceiveStockRoute(
        key: key,
        variantId: variantId,
        existingStock: existingStock,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddVariation({
    _i4.Key? key,
    required String productId,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddVariationRoute(
        key: key,
        productId: productId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddCategory({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddCategoryRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithListUnits({
    _i4.Key? key,
    required String type,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ListUnitsRoute(
        key: key,
        type: type,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSell({
    _i4.Key? key,
    required _i8.Product product,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SellRoute(
        key: key,
        product: product,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPayments({
    _i4.Key? key,
    required _i8.ITransaction transaction,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PaymentsRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPaymentConfirmation({
    _i4.Key? key,
    required double totalTransactionAmount,
    required _i8.ITransaction transaction,
    required String paymentType,
    String? receiptType = "ns",
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PaymentConfirmationRoute(
        key: key,
        totalTransactionAmount: totalTransactionAmount,
        transaction: transaction,
        paymentType: paymentType,
        receiptType: receiptType,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTransactionDetail({
    _i4.Key? key,
    required _i8.ITransaction transaction,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      TransactionDetailRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSettingsScreen(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const SettingsScreenRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSwitchBranchView({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SwitchBranchViewRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithScannView({
    _i4.Key? key,
    String intent = 'selling',
    bool useLatestImplementation = false,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ScannViewRoute(
        key: key,
        intent: intent,
        useLatestImplementation: useLatestImplementation,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithOrderView({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      OrderViewRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithOrders(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const OrdersRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithInAppBrowser(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const InAppBrowserRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCustomers({
    _i4.Key? key,
    String? transactionId,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      CustomersRoute(
        key: key,
        transactionId: transactionId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithNoNet({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      NoNetRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPinLogin({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PinLoginRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithDevices({
    _i4.Key? key,
    int? pin,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      DevicesRoute(
        key: key,
        pin: pin,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTaxConfiguration(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const TaxConfigurationRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPrinting(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const PrintingRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithBackUp(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const BackUpRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithLoginChoices(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LoginChoicesRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTenantAdd(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const TenantAddRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSocialHomeView(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const SocialHomeViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithDrawerScreen({
    _i4.Key? key,
    required String open,
    required _i8.Drawers drawer,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      DrawerScreenRoute(
        key: key,
        open: open,
        drawer: drawer,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithChatListView(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ChatListViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithConversationHistory({
    _i4.Key? key,
    required String conversationId,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ConversationHistoryRoute(
        key: key,
        conversationId: conversationId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTickets({
    _i4.Key? key,
    _i8.ITransaction? transaction,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      TicketsRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithNewTicket({
    _i4.Key? key,
    required _i8.ITransaction transaction,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      NewTicketRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithApps({
    _i4.Key? key,
    required _i4.TextEditingController controller,
    required bool isBigScreen,
    required _i8.CoreViewModel model,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AppsRoute(
        key: key,
        controller: controller,
        isBigScreen: isBigScreen,
        model: model,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCheckOut({
    _i4.Key? key,
    required bool isBigScreen,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      CheckOutRoute(
        key: key,
        isBigScreen: isBigScreen,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCashbook({
    _i4.Key? key,
    required bool isBigScreen,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      CashbookRoute(
        key: key,
        isBigScreen: isBigScreen,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSettingPage({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SettingPageRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTransactions(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const TransactionsRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSecurity({
    _i4.Key? key,
    void Function(_i3.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SecurityRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithComfirm(
      {void Function(_i3.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ComfirmRoute(),
      onFailure: onFailure,
    );
  }
}
