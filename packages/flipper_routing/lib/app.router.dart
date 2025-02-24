// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i8;

import 'package:firebase_auth/firebase_auth.dart' as _i7;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as _i6;
import 'package:flipper_dashboard/QuickSellingView.dart' as _i2;
import 'package:flipper_models/realm_model_export.dart' as _i9;
import 'package:flutter/material.dart' as _i5;
import 'package:stacked/stacked.dart' as _i4;
import 'package:stacked_services/stacked_services.dart' as _i3;

import 'all_routes.dart' as _i1;

final stackedRouter =
    StackedRouterWeb(navigatorKey: _i3.StackedService.navigatorKey);

class StackedRouterWeb extends _i4.RootStackRouter {
  StackedRouterWeb({_i5.GlobalKey<_i5.NavigatorState>? navigatorKey})
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    StartUpViewRoute.name: (routeData) {
      final args = routeData.argsAs<StartUpViewArgs>(
          orElse: () => const StartUpViewArgs());
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.FlipperApp(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    FailedPaymentRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.FailedPayment(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Login(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LandingRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Landing(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AuthRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Auth(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CountryPickerRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.CountryPicker(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PhoneInputScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneInputScreenArgs>();
      return _i4.CustomPage<dynamic>(
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
    InventoryRequestMobileViewRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.InventoryRequestMobileView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddProductViewRoute.name: (routeData) {
      final args = routeData.argsAs<AddProductViewArgs>(
          orElse: () => const AddProductViewArgs());
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ListCategories(
          key: args.key,
          modeOfOperation: args.modeOfOperation,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ColorTileRoute.name: (routeData) {
      final args =
          routeData.argsAs<ColorTileArgs>(orElse: () => const ColorTileArgs());
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ColorTile(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ReceiveStockRoute.name: (routeData) {
      final args = routeData.argsAs<ReceiveStockArgs>();
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddCategory(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ListUnitsRoute.name: (routeData) {
      final args = routeData.argsAs<ListUnitsArgs>();
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Payments(
          key: args.key,
          transaction: args.transaction,
          isIncome: args.isIncome,
          categoryId: args.categoryId,
          transactionType: args.transactionType,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PaymentConfirmationRoute.name: (routeData) {
      final args = routeData.argsAs<PaymentConfirmationArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PaymentConfirmation(
          key: args.key,
          transaction: args.transaction,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TransactionDetailRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionDetailArgs>();
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SettingsScreen(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SwitchBranchViewRoute.name: (routeData) {
      final args = routeData.argsAs<SwitchBranchViewArgs>(
          orElse: () => const SwitchBranchViewArgs());
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SwitchBranchView(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ScannViewRoute.name: (routeData) {
      final args =
          routeData.argsAs<ScannViewArgs>(orElse: () => const ScannViewArgs());
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.OrderView(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    OrdersRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Orders(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CustomersRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Customers(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    NoNetRoute.name: (routeData) {
      final args = routeData.argsAs<NoNetArgs>(orElse: () => const NoNetArgs());
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.NoNet(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PinLoginRoute.name: (routeData) {
      final args =
          routeData.argsAs<PinLoginArgs>(orElse: () => const PinLoginArgs());
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PinLogin(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    DevicesRoute.name: (routeData) {
      final args =
          routeData.argsAs<DevicesArgs>(orElse: () => const DevicesArgs());
      return _i4.CustomPage<dynamic>(
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
      final args = routeData.argsAs<TaxConfigurationArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.TaxConfiguration(
          key: args.key,
          showheader: args.showheader,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PrintingRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Printing(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    BackUpRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.BackUp(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginChoicesRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.LoginChoices(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TenantManagementRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.TenantManagement(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SocialHomeViewRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.SocialHomeView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    DrawerScreenRoute.name: (routeData) {
      final args = routeData.argsAs<DrawerScreenArgs>();
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.ChatListView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ConversationHistoryRoute.name: (routeData) {
      final args = routeData.argsAs<ConversationHistoryArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ConversationHistory(
          key: args.key,
          conversationId: args.conversationId,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TicketsListRoute.name: (routeData) {
      final args = routeData.argsAs<TicketsListArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.TicketsList(
          key: args.key,
          transaction: args.transaction,
          showAppBar: args.showAppBar,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    NewTicketRoute.name: (routeData) {
      final args = routeData.argsAs<NewTicketArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.NewTicket(
          key: args.key,
          transaction: args.transaction,
          onClose: args.onClose,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AppsRoute.name: (routeData) {
      final args = routeData.argsAs<AppsArgs>();
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
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
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SettingPage(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TransactionsRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Transactions(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SecurityRoute.name: (routeData) {
      final args =
          routeData.argsAs<SecurityArgs>(orElse: () => const SecurityArgs());
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Security(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ComfirmRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.Comfirm(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ReportsDashboardRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.ReportsDashboard(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AdminControlRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.AdminControl(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddBranchRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddBranch(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    QuickSellingViewRoute.name: (routeData) {
      final args = routeData.argsAs<QuickSellingViewArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i2.QuickSellingView(
          key: args.key,
          formKey: args.formKey,
          discountController: args.discountController,
          receivedAmountController: args.receivedAmountController,
          deliveryNoteCotroller: args.deliveryNoteCotroller,
          customerPhoneNumberController: args.customerPhoneNumberController,
          customerNameController: args.customerNameController,
          paymentTypeController: args.paymentTypeController,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PaymentPlanUIRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PaymentPlanUI(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PaymentFinalizeRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PaymentFinalize(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    WaitingOrdersPlacedRoute.name: (routeData) {
      final args = routeData.argsAs<WaitingOrdersPlacedArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.WaitingOrdersPlaced(
          args.orderId,
          key: args.key,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          StartUpViewRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          SignUpViewRoute.name,
          path: '/sign-up-view',
        ),
        _i4.RouteConfig(
          FlipperAppRoute.name,
          path: '/flipper-app',
        ),
        _i4.RouteConfig(
          FailedPaymentRoute.name,
          path: '/failed-payment',
        ),
        _i4.RouteConfig(
          LoginRoute.name,
          path: '/Login',
        ),
        _i4.RouteConfig(
          LandingRoute.name,
          path: '/Landing',
        ),
        _i4.RouteConfig(
          AuthRoute.name,
          path: '/Auth',
        ),
        _i4.RouteConfig(
          CountryPickerRoute.name,
          path: '/country-picker',
        ),
        _i4.RouteConfig(
          PhoneInputScreenRoute.name,
          path: '/phone-input-screen',
        ),
        _i4.RouteConfig(
          InventoryRequestMobileViewRoute.name,
          path: '/inventory-request-mobile-view',
        ),
        _i4.RouteConfig(
          AddProductViewRoute.name,
          path: '/add-product-view',
        ),
        _i4.RouteConfig(
          AddToFavoritesRoute.name,
          path: '/add-to-favorites',
        ),
        _i4.RouteConfig(
          AddDiscountRoute.name,
          path: '/add-discount',
        ),
        _i4.RouteConfig(
          ListCategoriesRoute.name,
          path: '/list-categories',
        ),
        _i4.RouteConfig(
          ColorTileRoute.name,
          path: '/color-tile',
        ),
        _i4.RouteConfig(
          ReceiveStockRoute.name,
          path: '/receive-stock',
        ),
        _i4.RouteConfig(
          AddVariationRoute.name,
          path: '/add-variation',
        ),
        _i4.RouteConfig(
          AddCategoryRoute.name,
          path: '/add-category',
        ),
        _i4.RouteConfig(
          ListUnitsRoute.name,
          path: '/list-units',
        ),
        _i4.RouteConfig(
          SellRoute.name,
          path: '/Sell',
        ),
        _i4.RouteConfig(
          PaymentsRoute.name,
          path: '/Payments',
        ),
        _i4.RouteConfig(
          PaymentConfirmationRoute.name,
          path: '/payment-confirmation',
        ),
        _i4.RouteConfig(
          TransactionDetailRoute.name,
          path: '/transaction-detail',
        ),
        _i4.RouteConfig(
          SettingsScreenRoute.name,
          path: '/settings-screen',
        ),
        _i4.RouteConfig(
          SwitchBranchViewRoute.name,
          path: '/switch-branch-view',
        ),
        _i4.RouteConfig(
          ScannViewRoute.name,
          path: '/scann-view',
        ),
        _i4.RouteConfig(
          OrderViewRoute.name,
          path: '/order-view',
        ),
        _i4.RouteConfig(
          OrdersRoute.name,
          path: '/Orders',
        ),
        _i4.RouteConfig(
          CustomersRoute.name,
          path: '/Customers',
        ),
        _i4.RouteConfig(
          NoNetRoute.name,
          path: '/no-net',
        ),
        _i4.RouteConfig(
          PinLoginRoute.name,
          path: '/pin-login',
        ),
        _i4.RouteConfig(
          DevicesRoute.name,
          path: '/Devices',
        ),
        _i4.RouteConfig(
          TaxConfigurationRoute.name,
          path: '/tax-configuration',
        ),
        _i4.RouteConfig(
          PrintingRoute.name,
          path: '/Printing',
        ),
        _i4.RouteConfig(
          BackUpRoute.name,
          path: '/back-up',
        ),
        _i4.RouteConfig(
          LoginChoicesRoute.name,
          path: '/login-choices',
        ),
        _i4.RouteConfig(
          TenantManagementRoute.name,
          path: '/tenant-management',
        ),
        _i4.RouteConfig(
          SocialHomeViewRoute.name,
          path: '/social-home-view',
        ),
        _i4.RouteConfig(
          DrawerScreenRoute.name,
          path: '/drawer-screen',
        ),
        _i4.RouteConfig(
          ChatListViewRoute.name,
          path: '/chat-list-view',
        ),
        _i4.RouteConfig(
          ConversationHistoryRoute.name,
          path: '/conversation-history',
        ),
        _i4.RouteConfig(
          TicketsListRoute.name,
          path: '/tickets-list',
        ),
        _i4.RouteConfig(
          NewTicketRoute.name,
          path: '/new-ticket',
        ),
        _i4.RouteConfig(
          AppsRoute.name,
          path: '/Apps',
        ),
        _i4.RouteConfig(
          CheckOutRoute.name,
          path: '/check-out',
        ),
        _i4.RouteConfig(
          CashbookRoute.name,
          path: '/Cashbook',
        ),
        _i4.RouteConfig(
          SettingPageRoute.name,
          path: '/setting-page',
        ),
        _i4.RouteConfig(
          TransactionsRoute.name,
          path: '/Transactions',
        ),
        _i4.RouteConfig(
          SecurityRoute.name,
          path: '/Security',
        ),
        _i4.RouteConfig(
          ComfirmRoute.name,
          path: '/Comfirm',
        ),
        _i4.RouteConfig(
          ReportsDashboardRoute.name,
          path: '/reports-dashboard',
        ),
        _i4.RouteConfig(
          AdminControlRoute.name,
          path: '/admin-control',
        ),
        _i4.RouteConfig(
          AddBranchRoute.name,
          path: '/add-branch',
        ),
        _i4.RouteConfig(
          QuickSellingViewRoute.name,
          path: '/quick-selling-view',
        ),
        _i4.RouteConfig(
          PaymentPlanUIRoute.name,
          path: '/payment-plan-uI',
        ),
        _i4.RouteConfig(
          PaymentFinalizeRoute.name,
          path: '/payment-finalize',
        ),
        _i4.RouteConfig(
          WaitingOrdersPlacedRoute.name,
          path: '/waiting-orders-placed',
        ),
      ];
}

/// generated route for
/// [_i1.StartUpView]
class StartUpViewRoute extends _i4.PageRouteInfo<StartUpViewArgs> {
  StartUpViewRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final bool? invokeLogin;

  @override
  String toString() {
    return 'StartUpViewArgs{key: $key, invokeLogin: $invokeLogin}';
  }
}

/// generated route for
/// [_i1.SignUpView]
class SignUpViewRoute extends _i4.PageRouteInfo<SignUpViewArgs> {
  SignUpViewRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final String? countryNm;

  @override
  String toString() {
    return 'SignUpViewArgs{key: $key, countryNm: $countryNm}';
  }
}

/// generated route for
/// [_i1.FlipperApp]
class FlipperAppRoute extends _i4.PageRouteInfo<void> {
  const FlipperAppRoute()
      : super(
          FlipperAppRoute.name,
          path: '/flipper-app',
        );

  static const String name = 'FlipperApp';
}

/// generated route for
/// [_i1.FailedPayment]
class FailedPaymentRoute extends _i4.PageRouteInfo<void> {
  const FailedPaymentRoute()
      : super(
          FailedPaymentRoute.name,
          path: '/failed-payment',
        );

  static const String name = 'FailedPayment';
}

/// generated route for
/// [_i1.Login]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/Login',
        );

  static const String name = 'Login';
}

/// generated route for
/// [_i1.Landing]
class LandingRoute extends _i4.PageRouteInfo<void> {
  const LandingRoute()
      : super(
          LandingRoute.name,
          path: '/Landing',
        );

  static const String name = 'Landing';
}

/// generated route for
/// [_i1.Auth]
class AuthRoute extends _i4.PageRouteInfo<void> {
  const AuthRoute()
      : super(
          AuthRoute.name,
          path: '/Auth',
        );

  static const String name = 'Auth';
}

/// generated route for
/// [_i1.CountryPicker]
class CountryPickerRoute extends _i4.PageRouteInfo<void> {
  const CountryPickerRoute()
      : super(
          CountryPickerRoute.name,
          path: '/country-picker',
        );

  static const String name = 'CountryPicker';
}

/// generated route for
/// [_i1.PhoneInputScreen]
class PhoneInputScreenRoute extends _i4.PageRouteInfo<PhoneInputScreenArgs> {
  PhoneInputScreenRoute({
    _i5.Key? key,
    _i6.AuthAction? action,
    List<_i6.FirebaseUIAction>? actions,
    _i7.FirebaseAuth? auth,
    required String countryCode,
    _i5.Widget Function(_i5.BuildContext)? subtitleBuilder,
    _i5.Widget Function(_i5.BuildContext)? footerBuilder,
    _i5.Widget Function(
      _i5.BuildContext,
      _i5.BoxConstraints,
      double,
    )? headerBuilder,
    double? headerMaxExtent,
    _i5.Widget Function(
      _i5.BuildContext,
      _i5.BoxConstraints,
    )? sideBuilder,
    _i8.TextDirection? desktopLayoutDirection,
    double breakpoint = 500,
    _i7.MultiFactorSession? multiFactorSession,
    _i7.PhoneMultiFactorInfo? mfaHint,
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

  final _i5.Key? key;

  final _i6.AuthAction? action;

  final List<_i6.FirebaseUIAction>? actions;

  final _i7.FirebaseAuth? auth;

  final String countryCode;

  final _i5.Widget Function(_i5.BuildContext)? subtitleBuilder;

  final _i5.Widget Function(_i5.BuildContext)? footerBuilder;

  final _i5.Widget Function(
    _i5.BuildContext,
    _i5.BoxConstraints,
    double,
  )? headerBuilder;

  final double? headerMaxExtent;

  final _i5.Widget Function(
    _i5.BuildContext,
    _i5.BoxConstraints,
  )? sideBuilder;

  final _i8.TextDirection? desktopLayoutDirection;

  final double breakpoint;

  final _i7.MultiFactorSession? multiFactorSession;

  final _i7.PhoneMultiFactorInfo? mfaHint;

  @override
  String toString() {
    return 'PhoneInputScreenArgs{key: $key, action: $action, actions: $actions, auth: $auth, countryCode: $countryCode, subtitleBuilder: $subtitleBuilder, footerBuilder: $footerBuilder, headerBuilder: $headerBuilder, headerMaxExtent: $headerMaxExtent, sideBuilder: $sideBuilder, desktopLayoutDirection: $desktopLayoutDirection, breakpoint: $breakpoint, multiFactorSession: $multiFactorSession, mfaHint: $mfaHint}';
  }
}

/// generated route for
/// [_i1.InventoryRequestMobileView]
class InventoryRequestMobileViewRoute extends _i4.PageRouteInfo<void> {
  const InventoryRequestMobileViewRoute()
      : super(
          InventoryRequestMobileViewRoute.name,
          path: '/inventory-request-mobile-view',
        );

  static const String name = 'InventoryRequestMobileView';
}

/// generated route for
/// [_i1.AddProductView]
class AddProductViewRoute extends _i4.PageRouteInfo<AddProductViewArgs> {
  AddProductViewRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final String? productId;

  @override
  String toString() {
    return 'AddProductViewArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i1.AddToFavorites]
class AddToFavoritesRoute extends _i4.PageRouteInfo<AddToFavoritesArgs> {
  AddToFavoritesRoute({
    _i5.Key? key,
    required String favoriteIndex,
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

  final _i5.Key? key;

  final String favoriteIndex;

  final List<String> existingFavs;

  @override
  String toString() {
    return 'AddToFavoritesArgs{key: $key, favoriteIndex: $favoriteIndex, existingFavs: $existingFavs}';
  }
}

/// generated route for
/// [_i1.AddDiscount]
class AddDiscountRoute extends _i4.PageRouteInfo<AddDiscountArgs> {
  AddDiscountRoute({
    _i5.Key? key,
    _i9.Discount? discount,
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

  final _i5.Key? key;

  final _i9.Discount? discount;

  @override
  String toString() {
    return 'AddDiscountArgs{key: $key, discount: $discount}';
  }
}

/// generated route for
/// [_i1.ListCategories]
class ListCategoriesRoute extends _i4.PageRouteInfo<ListCategoriesArgs> {
  ListCategoriesRoute({
    _i5.Key? key,
    required String? modeOfOperation,
  }) : super(
          ListCategoriesRoute.name,
          path: '/list-categories',
          args: ListCategoriesArgs(
            key: key,
            modeOfOperation: modeOfOperation,
          ),
        );

  static const String name = 'ListCategories';
}

class ListCategoriesArgs {
  const ListCategoriesArgs({
    this.key,
    required this.modeOfOperation,
  });

  final _i5.Key? key;

  final String? modeOfOperation;

  @override
  String toString() {
    return 'ListCategoriesArgs{key: $key, modeOfOperation: $modeOfOperation}';
  }
}

/// generated route for
/// [_i1.ColorTile]
class ColorTileRoute extends _i4.PageRouteInfo<ColorTileArgs> {
  ColorTileRoute({_i5.Key? key})
      : super(
          ColorTileRoute.name,
          path: '/color-tile',
          args: ColorTileArgs(key: key),
        );

  static const String name = 'ColorTile';
}

class ColorTileArgs {
  const ColorTileArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'ColorTileArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ReceiveStock]
class ReceiveStockRoute extends _i4.PageRouteInfo<ReceiveStockArgs> {
  ReceiveStockRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final String variantId;

  final String? existingStock;

  @override
  String toString() {
    return 'ReceiveStockArgs{key: $key, variantId: $variantId, existingStock: $existingStock}';
  }
}

/// generated route for
/// [_i1.AddVariation]
class AddVariationRoute extends _i4.PageRouteInfo<AddVariationArgs> {
  AddVariationRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final String productId;

  @override
  String toString() {
    return 'AddVariationArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i1.AddCategory]
class AddCategoryRoute extends _i4.PageRouteInfo<AddCategoryArgs> {
  AddCategoryRoute({_i5.Key? key})
      : super(
          AddCategoryRoute.name,
          path: '/add-category',
          args: AddCategoryArgs(key: key),
        );

  static const String name = 'AddCategory';
}

class AddCategoryArgs {
  const AddCategoryArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'AddCategoryArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ListUnits]
class ListUnitsRoute extends _i4.PageRouteInfo<ListUnitsArgs> {
  ListUnitsRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final String type;

  @override
  String toString() {
    return 'ListUnitsArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [_i1.Sell]
class SellRoute extends _i4.PageRouteInfo<SellArgs> {
  SellRoute({
    _i5.Key? key,
    required _i9.Product product,
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

  final _i5.Key? key;

  final _i9.Product product;

  @override
  String toString() {
    return 'SellArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [_i1.Payments]
class PaymentsRoute extends _i4.PageRouteInfo<PaymentsArgs> {
  PaymentsRoute({
    _i5.Key? key,
    required _i9.ITransaction transaction,
    required bool isIncome,
    required String categoryId,
    required String transactionType,
  }) : super(
          PaymentsRoute.name,
          path: '/Payments',
          args: PaymentsArgs(
            key: key,
            transaction: transaction,
            isIncome: isIncome,
            categoryId: categoryId,
            transactionType: transactionType,
          ),
        );

  static const String name = 'Payments';
}

class PaymentsArgs {
  const PaymentsArgs({
    this.key,
    required this.transaction,
    required this.isIncome,
    required this.categoryId,
    required this.transactionType,
  });

  final _i5.Key? key;

  final _i9.ITransaction transaction;

  final bool isIncome;

  final String categoryId;

  final String transactionType;

  @override
  String toString() {
    return 'PaymentsArgs{key: $key, transaction: $transaction, isIncome: $isIncome, categoryId: $categoryId, transactionType: $transactionType}';
  }
}

/// generated route for
/// [_i1.PaymentConfirmation]
class PaymentConfirmationRoute
    extends _i4.PageRouteInfo<PaymentConfirmationArgs> {
  PaymentConfirmationRoute({
    _i5.Key? key,
    required _i9.ITransaction transaction,
  }) : super(
          PaymentConfirmationRoute.name,
          path: '/payment-confirmation',
          args: PaymentConfirmationArgs(
            key: key,
            transaction: transaction,
          ),
        );

  static const String name = 'PaymentConfirmation';
}

class PaymentConfirmationArgs {
  const PaymentConfirmationArgs({
    this.key,
    required this.transaction,
  });

  final _i5.Key? key;

  final _i9.ITransaction transaction;

  @override
  String toString() {
    return 'PaymentConfirmationArgs{key: $key, transaction: $transaction}';
  }
}

/// generated route for
/// [_i1.TransactionDetail]
class TransactionDetailRoute extends _i4.PageRouteInfo<TransactionDetailArgs> {
  TransactionDetailRoute({
    _i5.Key? key,
    required _i9.ITransaction transaction,
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

  final _i5.Key? key;

  final _i9.ITransaction transaction;

  @override
  String toString() {
    return 'TransactionDetailArgs{key: $key, transaction: $transaction}';
  }
}

/// generated route for
/// [_i1.SettingsScreen]
class SettingsScreenRoute extends _i4.PageRouteInfo<void> {
  const SettingsScreenRoute()
      : super(
          SettingsScreenRoute.name,
          path: '/settings-screen',
        );

  static const String name = 'SettingsScreen';
}

/// generated route for
/// [_i1.SwitchBranchView]
class SwitchBranchViewRoute extends _i4.PageRouteInfo<SwitchBranchViewArgs> {
  SwitchBranchViewRoute({_i5.Key? key})
      : super(
          SwitchBranchViewRoute.name,
          path: '/switch-branch-view',
          args: SwitchBranchViewArgs(key: key),
        );

  static const String name = 'SwitchBranchView';
}

class SwitchBranchViewArgs {
  const SwitchBranchViewArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'SwitchBranchViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ScannView]
class ScannViewRoute extends _i4.PageRouteInfo<ScannViewArgs> {
  ScannViewRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final String intent;

  final bool useLatestImplementation;

  @override
  String toString() {
    return 'ScannViewArgs{key: $key, intent: $intent, useLatestImplementation: $useLatestImplementation}';
  }
}

/// generated route for
/// [_i1.OrderView]
class OrderViewRoute extends _i4.PageRouteInfo<OrderViewArgs> {
  OrderViewRoute({_i5.Key? key})
      : super(
          OrderViewRoute.name,
          path: '/order-view',
          args: OrderViewArgs(key: key),
        );

  static const String name = 'OrderView';
}

class OrderViewArgs {
  const OrderViewArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'OrderViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Orders]
class OrdersRoute extends _i4.PageRouteInfo<void> {
  const OrdersRoute()
      : super(
          OrdersRoute.name,
          path: '/Orders',
        );

  static const String name = 'Orders';
}

/// generated route for
/// [_i1.Customers]
class CustomersRoute extends _i4.PageRouteInfo<void> {
  const CustomersRoute()
      : super(
          CustomersRoute.name,
          path: '/Customers',
        );

  static const String name = 'Customers';
}

/// generated route for
/// [_i1.NoNet]
class NoNetRoute extends _i4.PageRouteInfo<NoNetArgs> {
  NoNetRoute({_i5.Key? key})
      : super(
          NoNetRoute.name,
          path: '/no-net',
          args: NoNetArgs(key: key),
        );

  static const String name = 'NoNet';
}

class NoNetArgs {
  const NoNetArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'NoNetArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.PinLogin]
class PinLoginRoute extends _i4.PageRouteInfo<PinLoginArgs> {
  PinLoginRoute({_i5.Key? key})
      : super(
          PinLoginRoute.name,
          path: '/pin-login',
          args: PinLoginArgs(key: key),
        );

  static const String name = 'PinLogin';
}

class PinLoginArgs {
  const PinLoginArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'PinLoginArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Devices]
class DevicesRoute extends _i4.PageRouteInfo<DevicesArgs> {
  DevicesRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final int? pin;

  @override
  String toString() {
    return 'DevicesArgs{key: $key, pin: $pin}';
  }
}

/// generated route for
/// [_i1.TaxConfiguration]
class TaxConfigurationRoute extends _i4.PageRouteInfo<TaxConfigurationArgs> {
  TaxConfigurationRoute({
    _i5.Key? key,
    required bool showheader,
  }) : super(
          TaxConfigurationRoute.name,
          path: '/tax-configuration',
          args: TaxConfigurationArgs(
            key: key,
            showheader: showheader,
          ),
        );

  static const String name = 'TaxConfiguration';
}

class TaxConfigurationArgs {
  const TaxConfigurationArgs({
    this.key,
    required this.showheader,
  });

  final _i5.Key? key;

  final bool showheader;

  @override
  String toString() {
    return 'TaxConfigurationArgs{key: $key, showheader: $showheader}';
  }
}

/// generated route for
/// [_i1.Printing]
class PrintingRoute extends _i4.PageRouteInfo<void> {
  const PrintingRoute()
      : super(
          PrintingRoute.name,
          path: '/Printing',
        );

  static const String name = 'Printing';
}

/// generated route for
/// [_i1.BackUp]
class BackUpRoute extends _i4.PageRouteInfo<void> {
  const BackUpRoute()
      : super(
          BackUpRoute.name,
          path: '/back-up',
        );

  static const String name = 'BackUp';
}

/// generated route for
/// [_i1.LoginChoices]
class LoginChoicesRoute extends _i4.PageRouteInfo<void> {
  const LoginChoicesRoute()
      : super(
          LoginChoicesRoute.name,
          path: '/login-choices',
        );

  static const String name = 'LoginChoices';
}

/// generated route for
/// [_i1.TenantManagement]
class TenantManagementRoute extends _i4.PageRouteInfo<void> {
  const TenantManagementRoute()
      : super(
          TenantManagementRoute.name,
          path: '/tenant-management',
        );

  static const String name = 'TenantManagement';
}

/// generated route for
/// [_i1.SocialHomeView]
class SocialHomeViewRoute extends _i4.PageRouteInfo<void> {
  const SocialHomeViewRoute()
      : super(
          SocialHomeViewRoute.name,
          path: '/social-home-view',
        );

  static const String name = 'SocialHomeView';
}

/// generated route for
/// [_i1.DrawerScreen]
class DrawerScreenRoute extends _i4.PageRouteInfo<DrawerScreenArgs> {
  DrawerScreenRoute({
    _i5.Key? key,
    required String open,
    required _i9.Drawers drawer,
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

  final _i5.Key? key;

  final String open;

  final _i9.Drawers drawer;

  @override
  String toString() {
    return 'DrawerScreenArgs{key: $key, open: $open, drawer: $drawer}';
  }
}

/// generated route for
/// [_i1.ChatListView]
class ChatListViewRoute extends _i4.PageRouteInfo<void> {
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
    extends _i4.PageRouteInfo<ConversationHistoryArgs> {
  ConversationHistoryRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final String conversationId;

  @override
  String toString() {
    return 'ConversationHistoryArgs{key: $key, conversationId: $conversationId}';
  }
}

/// generated route for
/// [_i1.TicketsList]
class TicketsListRoute extends _i4.PageRouteInfo<TicketsListArgs> {
  TicketsListRoute({
    _i5.Key? key,
    required _i9.ITransaction? transaction,
    bool showAppBar = true,
  }) : super(
          TicketsListRoute.name,
          path: '/tickets-list',
          args: TicketsListArgs(
            key: key,
            transaction: transaction,
            showAppBar: showAppBar,
          ),
        );

  static const String name = 'TicketsList';
}

class TicketsListArgs {
  const TicketsListArgs({
    this.key,
    required this.transaction,
    this.showAppBar = true,
  });

  final _i5.Key? key;

  final _i9.ITransaction? transaction;

  final bool showAppBar;

  @override
  String toString() {
    return 'TicketsListArgs{key: $key, transaction: $transaction, showAppBar: $showAppBar}';
  }
}

/// generated route for
/// [_i1.NewTicket]
class NewTicketRoute extends _i4.PageRouteInfo<NewTicketArgs> {
  NewTicketRoute({
    _i5.Key? key,
    required _i9.ITransaction transaction,
    required void Function() onClose,
  }) : super(
          NewTicketRoute.name,
          path: '/new-ticket',
          args: NewTicketArgs(
            key: key,
            transaction: transaction,
            onClose: onClose,
          ),
        );

  static const String name = 'NewTicket';
}

class NewTicketArgs {
  const NewTicketArgs({
    this.key,
    required this.transaction,
    required this.onClose,
  });

  final _i5.Key? key;

  final _i9.ITransaction transaction;

  final void Function() onClose;

  @override
  String toString() {
    return 'NewTicketArgs{key: $key, transaction: $transaction, onClose: $onClose}';
  }
}

/// generated route for
/// [_i1.Apps]
class AppsRoute extends _i4.PageRouteInfo<AppsArgs> {
  AppsRoute({
    _i5.Key? key,
    required _i5.TextEditingController controller,
    required bool isBigScreen,
    required _i9.CoreViewModel model,
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

  final _i5.Key? key;

  final _i5.TextEditingController controller;

  final bool isBigScreen;

  final _i9.CoreViewModel model;

  @override
  String toString() {
    return 'AppsArgs{key: $key, controller: $controller, isBigScreen: $isBigScreen, model: $model}';
  }
}

/// generated route for
/// [_i1.CheckOut]
class CheckOutRoute extends _i4.PageRouteInfo<CheckOutArgs> {
  CheckOutRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final bool isBigScreen;

  @override
  String toString() {
    return 'CheckOutArgs{key: $key, isBigScreen: $isBigScreen}';
  }
}

/// generated route for
/// [_i1.Cashbook]
class CashbookRoute extends _i4.PageRouteInfo<CashbookArgs> {
  CashbookRoute({
    _i5.Key? key,
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

  final _i5.Key? key;

  final bool isBigScreen;

  @override
  String toString() {
    return 'CashbookArgs{key: $key, isBigScreen: $isBigScreen}';
  }
}

/// generated route for
/// [_i1.SettingPage]
class SettingPageRoute extends _i4.PageRouteInfo<SettingPageArgs> {
  SettingPageRoute({_i5.Key? key})
      : super(
          SettingPageRoute.name,
          path: '/setting-page',
          args: SettingPageArgs(key: key),
        );

  static const String name = 'SettingPage';
}

class SettingPageArgs {
  const SettingPageArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'SettingPageArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Transactions]
class TransactionsRoute extends _i4.PageRouteInfo<void> {
  const TransactionsRoute()
      : super(
          TransactionsRoute.name,
          path: '/Transactions',
        );

  static const String name = 'Transactions';
}

/// generated route for
/// [_i1.Security]
class SecurityRoute extends _i4.PageRouteInfo<SecurityArgs> {
  SecurityRoute({_i5.Key? key})
      : super(
          SecurityRoute.name,
          path: '/Security',
          args: SecurityArgs(key: key),
        );

  static const String name = 'Security';
}

class SecurityArgs {
  const SecurityArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'SecurityArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Comfirm]
class ComfirmRoute extends _i4.PageRouteInfo<void> {
  const ComfirmRoute()
      : super(
          ComfirmRoute.name,
          path: '/Comfirm',
        );

  static const String name = 'Comfirm';
}

/// generated route for
/// [_i1.ReportsDashboard]
class ReportsDashboardRoute extends _i4.PageRouteInfo<void> {
  const ReportsDashboardRoute()
      : super(
          ReportsDashboardRoute.name,
          path: '/reports-dashboard',
        );

  static const String name = 'ReportsDashboard';
}

/// generated route for
/// [_i1.AdminControl]
class AdminControlRoute extends _i4.PageRouteInfo<void> {
  const AdminControlRoute()
      : super(
          AdminControlRoute.name,
          path: '/admin-control',
        );

  static const String name = 'AdminControl';
}

/// generated route for
/// [_i1.AddBranch]
class AddBranchRoute extends _i4.PageRouteInfo<void> {
  const AddBranchRoute()
      : super(
          AddBranchRoute.name,
          path: '/add-branch',
        );

  static const String name = 'AddBranch';
}

/// generated route for
/// [_i2.QuickSellingView]
class QuickSellingViewRoute extends _i4.PageRouteInfo<QuickSellingViewArgs> {
  QuickSellingViewRoute({
    _i5.Key? key,
    required _i5.GlobalKey<_i5.FormState> formKey,
    required _i5.TextEditingController discountController,
    required _i5.TextEditingController receivedAmountController,
    required _i5.TextEditingController deliveryNoteCotroller,
    required _i5.TextEditingController customerPhoneNumberController,
    required _i5.TextEditingController customerNameController,
    required _i5.TextEditingController paymentTypeController,
  }) : super(
          QuickSellingViewRoute.name,
          path: '/quick-selling-view',
          args: QuickSellingViewArgs(
            key: key,
            formKey: formKey,
            discountController: discountController,
            receivedAmountController: receivedAmountController,
            deliveryNoteCotroller: deliveryNoteCotroller,
            customerPhoneNumberController: customerPhoneNumberController,
            customerNameController: customerNameController,
            paymentTypeController: paymentTypeController,
          ),
        );

  static const String name = 'QuickSellingView';
}

class QuickSellingViewArgs {
  const QuickSellingViewArgs({
    this.key,
    required this.formKey,
    required this.discountController,
    required this.receivedAmountController,
    required this.deliveryNoteCotroller,
    required this.customerPhoneNumberController,
    required this.customerNameController,
    required this.paymentTypeController,
  });

  final _i5.Key? key;

  final _i5.GlobalKey<_i5.FormState> formKey;

  final _i5.TextEditingController discountController;

  final _i5.TextEditingController receivedAmountController;

  final _i5.TextEditingController deliveryNoteCotroller;

  final _i5.TextEditingController customerPhoneNumberController;

  final _i5.TextEditingController customerNameController;

  final _i5.TextEditingController paymentTypeController;

  @override
  String toString() {
    return 'QuickSellingViewArgs{key: $key, formKey: $formKey, discountController: $discountController, receivedAmountController: $receivedAmountController, deliveryNoteCotroller: $deliveryNoteCotroller, customerPhoneNumberController: $customerPhoneNumberController, customerNameController: $customerNameController, paymentTypeController: $paymentTypeController}';
  }
}

/// generated route for
/// [_i1.PaymentPlanUI]
class PaymentPlanUIRoute extends _i4.PageRouteInfo<void> {
  const PaymentPlanUIRoute()
      : super(
          PaymentPlanUIRoute.name,
          path: '/payment-plan-uI',
        );

  static const String name = 'PaymentPlanUI';
}

/// generated route for
/// [_i1.PaymentFinalize]
class PaymentFinalizeRoute extends _i4.PageRouteInfo<void> {
  const PaymentFinalizeRoute()
      : super(
          PaymentFinalizeRoute.name,
          path: '/payment-finalize',
        );

  static const String name = 'PaymentFinalize';
}

/// generated route for
/// [_i1.WaitingOrdersPlaced]
class WaitingOrdersPlacedRoute
    extends _i4.PageRouteInfo<WaitingOrdersPlacedArgs> {
  WaitingOrdersPlacedRoute({
    required int orderId,
    _i5.Key? key,
  }) : super(
          WaitingOrdersPlacedRoute.name,
          path: '/waiting-orders-placed',
          args: WaitingOrdersPlacedArgs(
            orderId: orderId,
            key: key,
          ),
        );

  static const String name = 'WaitingOrdersPlaced';
}

class WaitingOrdersPlacedArgs {
  const WaitingOrdersPlacedArgs({
    required this.orderId,
    this.key,
  });

  final int orderId;

  final _i5.Key? key;

  @override
  String toString() {
    return 'WaitingOrdersPlacedArgs{orderId: $orderId, key: $key}';
  }
}

extension RouterStateExtension on _i3.RouterService {
  Future<dynamic> navigateToStartUpView({
    _i5.Key? key,
    bool? invokeLogin,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    String? countryNm = "Rwanda",
    void Function(_i4.NavigationFailure)? onFailure,
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
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const FlipperAppRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToFailedPayment(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const FailedPaymentRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToLogin(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LoginRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToLanding(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LandingRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAuth(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const AuthRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCountryPicker(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const CountryPickerRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPhoneInputScreen({
    _i5.Key? key,
    _i6.AuthAction? action,
    List<_i6.FirebaseUIAction>? actions,
    _i7.FirebaseAuth? auth,
    required String countryCode,
    _i5.Widget Function(_i5.BuildContext)? subtitleBuilder,
    _i5.Widget Function(_i5.BuildContext)? footerBuilder,
    _i5.Widget Function(
      _i5.BuildContext,
      _i5.BoxConstraints,
      double,
    )? headerBuilder,
    double? headerMaxExtent,
    _i5.Widget Function(
      _i5.BuildContext,
      _i5.BoxConstraints,
    )? sideBuilder,
    _i8.TextDirection? desktopLayoutDirection,
    double breakpoint = 500,
    _i7.MultiFactorSession? multiFactorSession,
    _i7.PhoneMultiFactorInfo? mfaHint,
    void Function(_i4.NavigationFailure)? onFailure,
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

  Future<dynamic> navigateToInventoryRequestMobileView(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const InventoryRequestMobileViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddProductView({
    _i5.Key? key,
    String? productId,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required String favoriteIndex,
    required List<String> existingFavs,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    _i9.Discount? discount,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required String? modeOfOperation,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ListCategoriesRoute(
        key: key,
        modeOfOperation: modeOfOperation,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToColorTile({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ColorTileRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToReceiveStock({
    _i5.Key? key,
    required String variantId,
    String? existingStock,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required String productId,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddCategoryRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToListUnits({
    _i5.Key? key,
    required String type,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required _i9.Product product,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required _i9.ITransaction transaction,
    required bool isIncome,
    required String categoryId,
    required String transactionType,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PaymentsRoute(
        key: key,
        transaction: transaction,
        isIncome: isIncome,
        categoryId: categoryId,
        transactionType: transactionType,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPaymentConfirmation({
    _i5.Key? key,
    required _i9.ITransaction transaction,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PaymentConfirmationRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTransactionDetail({
    _i5.Key? key,
    required _i9.ITransaction transaction,
    void Function(_i4.NavigationFailure)? onFailure,
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
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const SettingsScreenRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSwitchBranchView({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SwitchBranchViewRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToScannView({
    _i5.Key? key,
    String intent = 'selling',
    bool useLatestImplementation = false,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      OrderViewRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToOrders(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const OrdersRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCustomers(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const CustomersRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToNoNet({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      NoNetRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPinLogin({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PinLoginRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToDevices({
    _i5.Key? key,
    int? pin,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      DevicesRoute(
        key: key,
        pin: pin,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTaxConfiguration({
    _i5.Key? key,
    required bool showheader,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      TaxConfigurationRoute(
        key: key,
        showheader: showheader,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPrinting(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const PrintingRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToBackUp(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const BackUpRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToLoginChoices(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const LoginChoicesRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTenantManagement(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const TenantManagementRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSocialHomeView(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const SocialHomeViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToDrawerScreen({
    _i5.Key? key,
    required String open,
    required _i9.Drawers drawer,
    void Function(_i4.NavigationFailure)? onFailure,
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
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ChatListViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToConversationHistory({
    _i5.Key? key,
    required String conversationId,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ConversationHistoryRoute(
        key: key,
        conversationId: conversationId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTicketsList({
    _i5.Key? key,
    required _i9.ITransaction? transaction,
    bool showAppBar = true,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      TicketsListRoute(
        key: key,
        transaction: transaction,
        showAppBar: showAppBar,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToNewTicket({
    _i5.Key? key,
    required _i9.ITransaction transaction,
    required void Function() onClose,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      NewTicketRoute(
        key: key,
        transaction: transaction,
        onClose: onClose,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToApps({
    _i5.Key? key,
    required _i5.TextEditingController controller,
    required bool isBigScreen,
    required _i9.CoreViewModel model,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required bool isBigScreen,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required bool isBigScreen,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SettingPageRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTransactions(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const TransactionsRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSecurity({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SecurityRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToComfirm(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ComfirmRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToReportsDashboard(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const ReportsDashboardRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAdminControl(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const AdminControlRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddBranch(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const AddBranchRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToQuickSellingView({
    _i5.Key? key,
    required _i5.GlobalKey<_i5.FormState> formKey,
    required _i5.TextEditingController discountController,
    required _i5.TextEditingController receivedAmountController,
    required _i5.TextEditingController deliveryNoteCotroller,
    required _i5.TextEditingController customerPhoneNumberController,
    required _i5.TextEditingController customerNameController,
    required _i5.TextEditingController paymentTypeController,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      QuickSellingViewRoute(
        key: key,
        formKey: formKey,
        discountController: discountController,
        receivedAmountController: receivedAmountController,
        deliveryNoteCotroller: deliveryNoteCotroller,
        customerPhoneNumberController: customerPhoneNumberController,
        customerNameController: customerNameController,
        paymentTypeController: paymentTypeController,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPaymentPlanUI(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const PaymentPlanUIRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPaymentFinalize(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const PaymentFinalizeRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToWaitingOrdersPlaced({
    required int orderId,
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      WaitingOrdersPlacedRoute(
        orderId: orderId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithStartUpView({
    _i5.Key? key,
    bool? invokeLogin,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    String? countryNm = "Rwanda",
    void Function(_i4.NavigationFailure)? onFailure,
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
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const FlipperAppRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithFailedPayment(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const FailedPaymentRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithLogin(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LoginRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithLanding(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LandingRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAuth(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const AuthRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCountryPicker(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const CountryPickerRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPhoneInputScreen({
    _i5.Key? key,
    _i6.AuthAction? action,
    List<_i6.FirebaseUIAction>? actions,
    _i7.FirebaseAuth? auth,
    required String countryCode,
    _i5.Widget Function(_i5.BuildContext)? subtitleBuilder,
    _i5.Widget Function(_i5.BuildContext)? footerBuilder,
    _i5.Widget Function(
      _i5.BuildContext,
      _i5.BoxConstraints,
      double,
    )? headerBuilder,
    double? headerMaxExtent,
    _i5.Widget Function(
      _i5.BuildContext,
      _i5.BoxConstraints,
    )? sideBuilder,
    _i8.TextDirection? desktopLayoutDirection,
    double breakpoint = 500,
    _i7.MultiFactorSession? multiFactorSession,
    _i7.PhoneMultiFactorInfo? mfaHint,
    void Function(_i4.NavigationFailure)? onFailure,
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

  Future<dynamic> replaceWithInventoryRequestMobileView(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const InventoryRequestMobileViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddProductView({
    _i5.Key? key,
    String? productId,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required String favoriteIndex,
    required List<String> existingFavs,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    _i9.Discount? discount,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required String? modeOfOperation,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ListCategoriesRoute(
        key: key,
        modeOfOperation: modeOfOperation,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithColorTile({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ColorTileRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithReceiveStock({
    _i5.Key? key,
    required String variantId,
    String? existingStock,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required String productId,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddCategoryRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithListUnits({
    _i5.Key? key,
    required String type,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required _i9.Product product,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required _i9.ITransaction transaction,
    required bool isIncome,
    required String categoryId,
    required String transactionType,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PaymentsRoute(
        key: key,
        transaction: transaction,
        isIncome: isIncome,
        categoryId: categoryId,
        transactionType: transactionType,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPaymentConfirmation({
    _i5.Key? key,
    required _i9.ITransaction transaction,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PaymentConfirmationRoute(
        key: key,
        transaction: transaction,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTransactionDetail({
    _i5.Key? key,
    required _i9.ITransaction transaction,
    void Function(_i4.NavigationFailure)? onFailure,
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
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const SettingsScreenRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSwitchBranchView({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SwitchBranchViewRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithScannView({
    _i5.Key? key,
    String intent = 'selling',
    bool useLatestImplementation = false,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      OrderViewRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithOrders(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const OrdersRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCustomers(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const CustomersRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithNoNet({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      NoNetRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPinLogin({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PinLoginRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithDevices({
    _i5.Key? key,
    int? pin,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      DevicesRoute(
        key: key,
        pin: pin,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTaxConfiguration({
    _i5.Key? key,
    required bool showheader,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      TaxConfigurationRoute(
        key: key,
        showheader: showheader,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPrinting(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const PrintingRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithBackUp(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const BackUpRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithLoginChoices(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const LoginChoicesRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTenantManagement(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const TenantManagementRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSocialHomeView(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const SocialHomeViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithDrawerScreen({
    _i5.Key? key,
    required String open,
    required _i9.Drawers drawer,
    void Function(_i4.NavigationFailure)? onFailure,
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
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ChatListViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithConversationHistory({
    _i5.Key? key,
    required String conversationId,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ConversationHistoryRoute(
        key: key,
        conversationId: conversationId,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTicketsList({
    _i5.Key? key,
    required _i9.ITransaction? transaction,
    bool showAppBar = true,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      TicketsListRoute(
        key: key,
        transaction: transaction,
        showAppBar: showAppBar,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithNewTicket({
    _i5.Key? key,
    required _i9.ITransaction transaction,
    required void Function() onClose,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      NewTicketRoute(
        key: key,
        transaction: transaction,
        onClose: onClose,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithApps({
    _i5.Key? key,
    required _i5.TextEditingController controller,
    required bool isBigScreen,
    required _i9.CoreViewModel model,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required bool isBigScreen,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    required bool isBigScreen,
    void Function(_i4.NavigationFailure)? onFailure,
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
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SettingPageRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTransactions(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const TransactionsRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSecurity({
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SecurityRoute(
        key: key,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithComfirm(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ComfirmRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithReportsDashboard(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const ReportsDashboardRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAdminControl(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const AdminControlRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddBranch(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const AddBranchRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithQuickSellingView({
    _i5.Key? key,
    required _i5.GlobalKey<_i5.FormState> formKey,
    required _i5.TextEditingController discountController,
    required _i5.TextEditingController receivedAmountController,
    required _i5.TextEditingController deliveryNoteCotroller,
    required _i5.TextEditingController customerPhoneNumberController,
    required _i5.TextEditingController customerNameController,
    required _i5.TextEditingController paymentTypeController,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      QuickSellingViewRoute(
        key: key,
        formKey: formKey,
        discountController: discountController,
        receivedAmountController: receivedAmountController,
        deliveryNoteCotroller: deliveryNoteCotroller,
        customerPhoneNumberController: customerPhoneNumberController,
        customerNameController: customerNameController,
        paymentTypeController: paymentTypeController,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPaymentPlanUI(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const PaymentPlanUIRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPaymentFinalize(
      {void Function(_i4.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const PaymentFinalizeRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithWaitingOrdersPlaced({
    required int orderId,
    _i5.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      WaitingOrdersPlacedRoute(
        orderId: orderId,
        key: key,
      ),
      onFailure: onFailure,
    );
  }
}
