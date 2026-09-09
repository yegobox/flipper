// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flipper_dashboard/QuickSellingView.dart' as _i2;
import 'package:flipper_models/db_model_export.dart' as _i7;
import 'package:flutter/foundation.dart' as _i6;
import 'package:flutter/material.dart' as _i5;
import 'package:stacked/stacked.dart' as _i4;
import 'package:stacked_services/stacked_services.dart' as _i3;

import 'all_routes.dart' as _i1;

final stackedRouter = StackedRouterWeb(
  navigatorKey: _i3.StackedService.navigatorKey,
);

class StackedRouterWeb extends _i4.RootStackRouter {
  StackedRouterWeb({_i5.GlobalKey<_i5.NavigatorState>? navigatorKey})
    : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    StartUpViewRoute.name: (routeData) {
      final args = routeData.argsAs<StartUpViewArgs>(
        orElse: () => const StartUpViewArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.StartUpView(key: args.key, invokeLogin: args.invokeLogin),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SignUpViewRoute.name: (routeData) {
      final args = routeData.argsAs<SignUpViewArgs>(
        orElse: () => const SignUpViewArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SignUpView(key: args.key, countryNm: args.countryNm),
        opaque: true,
        barrierDismissible: false,
      );
    },
    FlipperAppRoute.name: (routeData) {
      final args = routeData.argsAs<FlipperAppArgs>(
        orElse: () => const FlipperAppArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.FlipperApp(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    FailedPaymentRoute.name: (routeData) {
      final args = routeData.argsAs<FailedPaymentArgs>(
        orElse: () => const FailedPaymentArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.FailedPayment(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginArgs>(orElse: () => const LoginArgs());
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Login(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LandingRoute.name: (routeData) {
      final args = routeData.argsAs<LandingArgs>(
        orElse: () => const LandingArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Landing(key: args.key),
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
      final args = routeData.argsAs<CountryPickerArgs>(
        orElse: () => const CountryPickerArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.CountryPicker(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AiScreenRoute.name: (routeData) {
      final args = routeData.argsAs<AiScreenArgs>(
        orElse: () => const AiScreenArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AiScreen(
          key: args.key,
          onPurchaseCredits: args.onPurchaseCredits,
        ),
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
          countryCode: args.countryCode,
          subtitleBuilder: args.subtitleBuilder,
          footerBuilder: args.footerBuilder,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    InventoryRequestMobileViewRoute.name: (routeData) {
      final args = routeData.argsAs<InventoryRequestMobileViewArgs>(
        orElse: () => const InventoryRequestMobileViewArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.InventoryRequestMobileView(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddProductViewRoute.name: (routeData) {
      final args = routeData.argsAs<AddProductViewArgs>(
        orElse: () => const AddProductViewArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddProductView(key: args.key, productId: args.productId),
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
        orElse: () => const AddDiscountArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AddDiscount(key: args.key, discount: args.discount),
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
      final args = routeData.argsAs<ColorTileArgs>(
        orElse: () => const ColorTileArgs(),
      );
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
        child: _i1.AddVariation(key: args.key, productId: args.productId),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddCategoryRoute.name: (routeData) {
      final args = routeData.argsAs<AddCategoryArgs>(
        orElse: () => const AddCategoryArgs(),
      );
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
        child: _i1.ListUnits(key: args.key, type: args.type),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SellRoute.name: (routeData) {
      final args = routeData.argsAs<SellArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Sell(key: args.key, product: args.product),
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
        orElse: () => const SwitchBranchViewArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SwitchBranchView(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    OrderViewRoute.name: (routeData) {
      final args = routeData.argsAs<OrderViewArgs>(
        orElse: () => const OrderViewArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.OrderView(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    OrdersRoute.name: (routeData) {
      final args = routeData.argsAs<OrdersArgs>(
        orElse: () => const OrdersArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Orders(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CustomersRoute.name: (routeData) {
      final args = routeData.argsAs<CustomersArgs>(
        orElse: () => const CustomersArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Customers(key: args.key),
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
      final args = routeData.argsAs<PinLoginArgs>(
        orElse: () => const PinLoginArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PinLogin(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    DevicesRoute.name: (routeData) {
      final args = routeData.argsAs<DevicesArgs>(
        orElse: () => const DevicesArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Devices(key: args.key, pin: args.pin),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SystemConfigRoute.name: (routeData) {
      final args = routeData.argsAs<SystemConfigArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SystemConfig(key: args.key, showheader: args.showheader),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PrintingRoute.name: (routeData) {
      final args = routeData.argsAs<PrintingArgs>(
        orElse: () => const PrintingArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Printing(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    BackUpRoute.name: (routeData) {
      final args = routeData.argsAs<BackUpArgs>(
        orElse: () => const BackUpArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.BackUp(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginChoicesRoute.name: (routeData) {
      final args = routeData.argsAs<LoginChoicesArgs>(
        orElse: () => const LoginChoicesArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.LoginChoices(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TenantManagementRoute.name: (routeData) {
      final args = routeData.argsAs<TenantManagementArgs>(
        orElse: () => const TenantManagementArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.TenantManagement(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AgentCommissionScreenRoute.name: (routeData) {
      final args = routeData.argsAs<AgentCommissionScreenArgs>(
        orElse: () => const AgentCommissionScreenArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AgentCommissionScreen(
          key: args.key,
          embeddedInDashboard: args.embeddedInDashboard,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    DrawerScreenRoute.name: (routeData) {
      final args = routeData.argsAs<DrawerScreenArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.DrawerScreen(key: args.key, open: args.open),
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
    MobileViewRoute.name: (routeData) {
      final args = routeData.argsAs<MobileViewArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.MobileView(
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
      final args = routeData.argsAs<CheckOutArgs>(
        orElse: () => const CheckOutArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.CheckOut(key: args.key, isBigScreen: args.isBigScreen),
        opaque: true,
        barrierDismissible: false,
      );
    },
    BarModeHostRoute.name: (routeData) {
      final args = routeData.argsAs<BarModeHostArgs>(
        orElse: () => const BarModeHostArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.BarModeHost(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    HotelModeHostRoute.name: (routeData) {
      final args = routeData.argsAs<HotelModeHostArgs>(
        orElse: () => const HotelModeHostArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.HotelModeHost(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CashbookRoute.name: (routeData) {
      final args = routeData.argsAs<CashbookArgs>();
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Cashbook(key: args.key, isBigScreen: args.isBigScreen),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SettingPageRoute.name: (routeData) {
      final args = routeData.argsAs<SettingPageArgs>(
        orElse: () => const SettingPageArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.SettingPage(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    TransactionsRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionsArgs>(
        orElse: () => const TransactionsArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Transactions(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    SecurityRoute.name: (routeData) {
      final args = routeData.argsAs<SecurityArgs>(
        orElse: () => const SecurityArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.Security(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ReportsDashboardRoute.name: (routeData) {
      final args = routeData.argsAs<ReportsDashboardArgs>(
        orElse: () => const ReportsDashboardArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ReportsDashboard(key: args.key, isInDialog: args.isInDialog),
        opaque: true,
        barrierDismissible: false,
      );
    },
    AdminControlRoute.name: (routeData) {
      final args = routeData.argsAs<AdminControlArgs>(
        orElse: () => const AdminControlArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.AdminControl(key: args.key),
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
          paymentTypeController: args.paymentTypeController,
          countryCodeController: args.countryCodeController,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PaymentPlanUIRoute.name: (routeData) {
      final args = routeData.argsAs<PaymentPlanUIArgs>(
        orElse: () => const PaymentPlanUIArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PaymentPlanUI(
          key: args.key,
          skipPaymentStatusCheck: args.skipPaymentStatusCheck,
        ),
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
        child: _i1.WaitingOrdersPlaced(args.orderId, key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CreditAppRoute.name: (routeData) {
      final args = routeData.argsAs<CreditAppArgs>(
        orElse: () => const CreditAppArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.CreditApp(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
    ShiftHistoryViewRoute.name: (routeData) {
      final args = routeData.argsAs<ShiftHistoryViewArgs>(
        orElse: () => const ShiftHistoryViewArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.ShiftHistoryView(key: args.key, onBack: args.onBack),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PersonalHomeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PersonalHomeScreenArgs>(
        orElse: () => const PersonalHomeScreenArgs(),
      );
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: _i1.PersonalHomeScreen(key: args.key),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
    _i4.RouteConfig(StartUpViewRoute.name, path: '/'),
    _i4.RouteConfig(SignUpViewRoute.name, path: '/sign-up-view'),
    _i4.RouteConfig(FlipperAppRoute.name, path: '/flipper-app'),
    _i4.RouteConfig(FailedPaymentRoute.name, path: '/failed-payment'),
    _i4.RouteConfig(LoginRoute.name, path: '/Login'),
    _i4.RouteConfig(LandingRoute.name, path: '/Landing'),
    _i4.RouteConfig(AuthRoute.name, path: '/Auth'),
    _i4.RouteConfig(CountryPickerRoute.name, path: '/country-picker'),
    _i4.RouteConfig(AiScreenRoute.name, path: '/ai-screen'),
    _i4.RouteConfig(PhoneInputScreenRoute.name, path: '/phone-input-screen'),
    _i4.RouteConfig(
      InventoryRequestMobileViewRoute.name,
      path: '/inventory-request-mobile-view',
    ),
    _i4.RouteConfig(AddProductViewRoute.name, path: '/add-product-view'),
    _i4.RouteConfig(AddToFavoritesRoute.name, path: '/add-to-favorites'),
    _i4.RouteConfig(AddDiscountRoute.name, path: '/add-discount'),
    _i4.RouteConfig(ListCategoriesRoute.name, path: '/list-categories'),
    _i4.RouteConfig(ColorTileRoute.name, path: '/color-tile'),
    _i4.RouteConfig(ReceiveStockRoute.name, path: '/receive-stock'),
    _i4.RouteConfig(AddVariationRoute.name, path: '/add-variation'),
    _i4.RouteConfig(AddCategoryRoute.name, path: '/add-category'),
    _i4.RouteConfig(ListUnitsRoute.name, path: '/list-units'),
    _i4.RouteConfig(SellRoute.name, path: '/Sell'),
    _i4.RouteConfig(PaymentsRoute.name, path: '/Payments'),
    _i4.RouteConfig(
      PaymentConfirmationRoute.name,
      path: '/payment-confirmation',
    ),
    _i4.RouteConfig(TransactionDetailRoute.name, path: '/transaction-detail'),
    _i4.RouteConfig(SettingsScreenRoute.name, path: '/settings-screen'),
    _i4.RouteConfig(SwitchBranchViewRoute.name, path: '/switch-branch-view'),
    _i4.RouteConfig(OrderViewRoute.name, path: '/order-view'),
    _i4.RouteConfig(OrdersRoute.name, path: '/Orders'),
    _i4.RouteConfig(CustomersRoute.name, path: '/Customers'),
    _i4.RouteConfig(NoNetRoute.name, path: '/no-net'),
    _i4.RouteConfig(PinLoginRoute.name, path: '/pin-login'),
    _i4.RouteConfig(DevicesRoute.name, path: '/Devices'),
    _i4.RouteConfig(SystemConfigRoute.name, path: '/system-config'),
    _i4.RouteConfig(PrintingRoute.name, path: '/Printing'),
    _i4.RouteConfig(BackUpRoute.name, path: '/back-up'),
    _i4.RouteConfig(LoginChoicesRoute.name, path: '/login-choices'),
    _i4.RouteConfig(TenantManagementRoute.name, path: '/tenant-management'),
    _i4.RouteConfig(
      AgentCommissionScreenRoute.name,
      path: '/agent-commission-screen',
    ),
    _i4.RouteConfig(DrawerScreenRoute.name, path: '/drawer-screen'),
    _i4.RouteConfig(TicketsListRoute.name, path: '/tickets-list'),
    _i4.RouteConfig(NewTicketRoute.name, path: '/new-ticket'),
    _i4.RouteConfig(MobileViewRoute.name, path: '/mobile-view'),
    _i4.RouteConfig(CheckOutRoute.name, path: '/check-out'),
    _i4.RouteConfig(BarModeHostRoute.name, path: '/bar-mode-host'),
    _i4.RouteConfig(HotelModeHostRoute.name, path: '/hotel-mode-host'),
    _i4.RouteConfig(CashbookRoute.name, path: '/Cashbook'),
    _i4.RouteConfig(SettingPageRoute.name, path: '/setting-page'),
    _i4.RouteConfig(TransactionsRoute.name, path: '/Transactions'),
    _i4.RouteConfig(SecurityRoute.name, path: '/Security'),
    _i4.RouteConfig(ReportsDashboardRoute.name, path: '/reports-dashboard'),
    _i4.RouteConfig(AdminControlRoute.name, path: '/admin-control'),
    _i4.RouteConfig(AddBranchRoute.name, path: '/add-branch'),
    _i4.RouteConfig(QuickSellingViewRoute.name, path: '/quick-selling-view'),
    _i4.RouteConfig(PaymentPlanUIRoute.name, path: '/payment-plan-uI'),
    _i4.RouteConfig(PaymentFinalizeRoute.name, path: '/payment-finalize'),
    _i4.RouteConfig(
      WaitingOrdersPlacedRoute.name,
      path: '/waiting-orders-placed',
    ),
    _i4.RouteConfig(CreditAppRoute.name, path: '/credit-app'),
    _i4.RouteConfig(ShiftHistoryViewRoute.name, path: '/shift-history-view'),
    _i4.RouteConfig(
      PersonalHomeScreenRoute.name,
      path: '/personal-home-screen',
    ),
  ];
}

/// generated route for
/// [_i1.StartUpView]
class StartUpViewRoute extends _i4.PageRouteInfo<StartUpViewArgs> {
  StartUpViewRoute({_i6.Key? key, bool? invokeLogin})
    : super(
        StartUpViewRoute.name,
        path: '/',
        args: StartUpViewArgs(key: key, invokeLogin: invokeLogin),
      );

  static const String name = 'StartUpView';
}

class StartUpViewArgs {
  const StartUpViewArgs({this.key, this.invokeLogin});

  final _i6.Key? key;

  final bool? invokeLogin;

  @override
  String toString() {
    return 'StartUpViewArgs{key: $key, invokeLogin: $invokeLogin}';
  }
}

/// generated route for
/// [_i1.SignUpView]
class SignUpViewRoute extends _i4.PageRouteInfo<SignUpViewArgs> {
  SignUpViewRoute({_i6.Key? key, String? countryNm = "Rwanda"})
    : super(
        SignUpViewRoute.name,
        path: '/sign-up-view',
        args: SignUpViewArgs(key: key, countryNm: countryNm),
      );

  static const String name = 'SignUpView';
}

class SignUpViewArgs {
  const SignUpViewArgs({this.key, this.countryNm = "Rwanda"});

  final _i6.Key? key;

  final String? countryNm;

  @override
  String toString() {
    return 'SignUpViewArgs{key: $key, countryNm: $countryNm}';
  }
}

/// generated route for
/// [_i1.FlipperApp]
class FlipperAppRoute extends _i4.PageRouteInfo<FlipperAppArgs> {
  FlipperAppRoute({_i6.Key? key})
    : super(
        FlipperAppRoute.name,
        path: '/flipper-app',
        args: FlipperAppArgs(key: key),
      );

  static const String name = 'FlipperApp';
}

class FlipperAppArgs {
  const FlipperAppArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'FlipperAppArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.FailedPayment]
class FailedPaymentRoute extends _i4.PageRouteInfo<FailedPaymentArgs> {
  FailedPaymentRoute({_i6.Key? key})
    : super(
        FailedPaymentRoute.name,
        path: '/failed-payment',
        args: FailedPaymentArgs(key: key),
      );

  static const String name = 'FailedPayment';
}

class FailedPaymentArgs {
  const FailedPaymentArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'FailedPaymentArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Login]
class LoginRoute extends _i4.PageRouteInfo<LoginArgs> {
  LoginRoute({_i6.Key? key})
    : super(
        LoginRoute.name,
        path: '/Login',
        args: LoginArgs(key: key),
      );

  static const String name = 'Login';
}

class LoginArgs {
  const LoginArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'LoginArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Landing]
class LandingRoute extends _i4.PageRouteInfo<LandingArgs> {
  LandingRoute({_i6.Key? key})
    : super(
        LandingRoute.name,
        path: '/Landing',
        args: LandingArgs(key: key),
      );

  static const String name = 'Landing';
}

class LandingArgs {
  const LandingArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'LandingArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Auth]
class AuthRoute extends _i4.PageRouteInfo<void> {
  const AuthRoute() : super(AuthRoute.name, path: '/Auth');

  static const String name = 'Auth';
}

/// generated route for
/// [_i1.CountryPicker]
class CountryPickerRoute extends _i4.PageRouteInfo<CountryPickerArgs> {
  CountryPickerRoute({_i6.Key? key})
    : super(
        CountryPickerRoute.name,
        path: '/country-picker',
        args: CountryPickerArgs(key: key),
      );

  static const String name = 'CountryPicker';
}

class CountryPickerArgs {
  const CountryPickerArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'CountryPickerArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.AiScreen]
class AiScreenRoute extends _i4.PageRouteInfo<AiScreenArgs> {
  AiScreenRoute({_i6.Key? key, void Function()? onPurchaseCredits})
    : super(
        AiScreenRoute.name,
        path: '/ai-screen',
        args: AiScreenArgs(key: key, onPurchaseCredits: onPurchaseCredits),
      );

  static const String name = 'AiScreen';
}

class AiScreenArgs {
  const AiScreenArgs({this.key, this.onPurchaseCredits});

  final _i6.Key? key;

  final void Function()? onPurchaseCredits;

  @override
  String toString() {
    return 'AiScreenArgs{key: $key, onPurchaseCredits: $onPurchaseCredits}';
  }
}

/// generated route for
/// [_i1.PhoneInputScreen]
class PhoneInputScreenRoute extends _i4.PageRouteInfo<PhoneInputScreenArgs> {
  PhoneInputScreenRoute({
    _i6.Key? key,
    required String countryCode,
    _i5.Widget Function(_i5.BuildContext)? subtitleBuilder,
    _i5.Widget Function(_i5.BuildContext)? footerBuilder,
  }) : super(
         PhoneInputScreenRoute.name,
         path: '/phone-input-screen',
         args: PhoneInputScreenArgs(
           key: key,
           countryCode: countryCode,
           subtitleBuilder: subtitleBuilder,
           footerBuilder: footerBuilder,
         ),
       );

  static const String name = 'PhoneInputScreen';
}

class PhoneInputScreenArgs {
  const PhoneInputScreenArgs({
    this.key,
    required this.countryCode,
    this.subtitleBuilder,
    this.footerBuilder,
  });

  final _i6.Key? key;

  final String countryCode;

  final _i5.Widget Function(_i5.BuildContext)? subtitleBuilder;

  final _i5.Widget Function(_i5.BuildContext)? footerBuilder;

  @override
  String toString() {
    return 'PhoneInputScreenArgs{key: $key, countryCode: $countryCode, subtitleBuilder: $subtitleBuilder, footerBuilder: $footerBuilder}';
  }
}

/// generated route for
/// [_i1.InventoryRequestMobileView]
class InventoryRequestMobileViewRoute
    extends _i4.PageRouteInfo<InventoryRequestMobileViewArgs> {
  InventoryRequestMobileViewRoute({_i6.Key? key})
    : super(
        InventoryRequestMobileViewRoute.name,
        path: '/inventory-request-mobile-view',
        args: InventoryRequestMobileViewArgs(key: key),
      );

  static const String name = 'InventoryRequestMobileView';
}

class InventoryRequestMobileViewArgs {
  const InventoryRequestMobileViewArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'InventoryRequestMobileViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.AddProductView]
class AddProductViewRoute extends _i4.PageRouteInfo<AddProductViewArgs> {
  AddProductViewRoute({_i6.Key? key, String? productId})
    : super(
        AddProductViewRoute.name,
        path: '/add-product-view',
        args: AddProductViewArgs(key: key, productId: productId),
      );

  static const String name = 'AddProductView';
}

class AddProductViewArgs {
  const AddProductViewArgs({this.key, this.productId});

  final _i6.Key? key;

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
    _i6.Key? key,
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

  final _i6.Key? key;

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
  AddDiscountRoute({_i6.Key? key, _i7.Discount? discount})
    : super(
        AddDiscountRoute.name,
        path: '/add-discount',
        args: AddDiscountArgs(key: key, discount: discount),
      );

  static const String name = 'AddDiscount';
}

class AddDiscountArgs {
  const AddDiscountArgs({this.key, this.discount});

  final _i6.Key? key;

  final _i7.Discount? discount;

  @override
  String toString() {
    return 'AddDiscountArgs{key: $key, discount: $discount}';
  }
}

/// generated route for
/// [_i1.ListCategories]
class ListCategoriesRoute extends _i4.PageRouteInfo<ListCategoriesArgs> {
  ListCategoriesRoute({_i6.Key? key, required String? modeOfOperation})
    : super(
        ListCategoriesRoute.name,
        path: '/list-categories',
        args: ListCategoriesArgs(key: key, modeOfOperation: modeOfOperation),
      );

  static const String name = 'ListCategories';
}

class ListCategoriesArgs {
  const ListCategoriesArgs({this.key, required this.modeOfOperation});

  final _i6.Key? key;

  final String? modeOfOperation;

  @override
  String toString() {
    return 'ListCategoriesArgs{key: $key, modeOfOperation: $modeOfOperation}';
  }
}

/// generated route for
/// [_i1.ColorTile]
class ColorTileRoute extends _i4.PageRouteInfo<ColorTileArgs> {
  ColorTileRoute({_i6.Key? key})
    : super(
        ColorTileRoute.name,
        path: '/color-tile',
        args: ColorTileArgs(key: key),
      );

  static const String name = 'ColorTile';
}

class ColorTileArgs {
  const ColorTileArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'ColorTileArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ReceiveStock]
class ReceiveStockRoute extends _i4.PageRouteInfo<ReceiveStockArgs> {
  ReceiveStockRoute({
    _i6.Key? key,
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

  final _i6.Key? key;

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
  AddVariationRoute({_i6.Key? key, required String productId})
    : super(
        AddVariationRoute.name,
        path: '/add-variation',
        args: AddVariationArgs(key: key, productId: productId),
      );

  static const String name = 'AddVariation';
}

class AddVariationArgs {
  const AddVariationArgs({this.key, required this.productId});

  final _i6.Key? key;

  final String productId;

  @override
  String toString() {
    return 'AddVariationArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [_i1.AddCategory]
class AddCategoryRoute extends _i4.PageRouteInfo<AddCategoryArgs> {
  AddCategoryRoute({_i6.Key? key})
    : super(
        AddCategoryRoute.name,
        path: '/add-category',
        args: AddCategoryArgs(key: key),
      );

  static const String name = 'AddCategory';
}

class AddCategoryArgs {
  const AddCategoryArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'AddCategoryArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ListUnits]
class ListUnitsRoute extends _i4.PageRouteInfo<ListUnitsArgs> {
  ListUnitsRoute({_i6.Key? key, required String type})
    : super(
        ListUnitsRoute.name,
        path: '/list-units',
        args: ListUnitsArgs(key: key, type: type),
      );

  static const String name = 'ListUnits';
}

class ListUnitsArgs {
  const ListUnitsArgs({this.key, required this.type});

  final _i6.Key? key;

  final String type;

  @override
  String toString() {
    return 'ListUnitsArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [_i1.Sell]
class SellRoute extends _i4.PageRouteInfo<SellArgs> {
  SellRoute({_i6.Key? key, required _i7.Product product})
    : super(
        SellRoute.name,
        path: '/Sell',
        args: SellArgs(key: key, product: product),
      );

  static const String name = 'Sell';
}

class SellArgs {
  const SellArgs({this.key, required this.product});

  final _i6.Key? key;

  final _i7.Product product;

  @override
  String toString() {
    return 'SellArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [_i1.Payments]
class PaymentsRoute extends _i4.PageRouteInfo<PaymentsArgs> {
  PaymentsRoute({
    _i6.Key? key,
    required _i7.ITransaction transaction,
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

  final _i6.Key? key;

  final _i7.ITransaction transaction;

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
    _i6.Key? key,
    required _i7.ITransaction transaction,
  }) : super(
         PaymentConfirmationRoute.name,
         path: '/payment-confirmation',
         args: PaymentConfirmationArgs(key: key, transaction: transaction),
       );

  static const String name = 'PaymentConfirmation';
}

class PaymentConfirmationArgs {
  const PaymentConfirmationArgs({this.key, required this.transaction});

  final _i6.Key? key;

  final _i7.ITransaction transaction;

  @override
  String toString() {
    return 'PaymentConfirmationArgs{key: $key, transaction: $transaction}';
  }
}

/// generated route for
/// [_i1.TransactionDetail]
class TransactionDetailRoute extends _i4.PageRouteInfo<TransactionDetailArgs> {
  TransactionDetailRoute({_i6.Key? key, required _i7.ITransaction transaction})
    : super(
        TransactionDetailRoute.name,
        path: '/transaction-detail',
        args: TransactionDetailArgs(key: key, transaction: transaction),
      );

  static const String name = 'TransactionDetail';
}

class TransactionDetailArgs {
  const TransactionDetailArgs({this.key, required this.transaction});

  final _i6.Key? key;

  final _i7.ITransaction transaction;

  @override
  String toString() {
    return 'TransactionDetailArgs{key: $key, transaction: $transaction}';
  }
}

/// generated route for
/// [_i1.SettingsScreen]
class SettingsScreenRoute extends _i4.PageRouteInfo<void> {
  const SettingsScreenRoute()
    : super(SettingsScreenRoute.name, path: '/settings-screen');

  static const String name = 'SettingsScreen';
}

/// generated route for
/// [_i1.SwitchBranchView]
class SwitchBranchViewRoute extends _i4.PageRouteInfo<SwitchBranchViewArgs> {
  SwitchBranchViewRoute({_i6.Key? key})
    : super(
        SwitchBranchViewRoute.name,
        path: '/switch-branch-view',
        args: SwitchBranchViewArgs(key: key),
      );

  static const String name = 'SwitchBranchView';
}

class SwitchBranchViewArgs {
  const SwitchBranchViewArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'SwitchBranchViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.OrderView]
class OrderViewRoute extends _i4.PageRouteInfo<OrderViewArgs> {
  OrderViewRoute({_i6.Key? key})
    : super(
        OrderViewRoute.name,
        path: '/order-view',
        args: OrderViewArgs(key: key),
      );

  static const String name = 'OrderView';
}

class OrderViewArgs {
  const OrderViewArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'OrderViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Orders]
class OrdersRoute extends _i4.PageRouteInfo<OrdersArgs> {
  OrdersRoute({_i6.Key? key})
    : super(
        OrdersRoute.name,
        path: '/Orders',
        args: OrdersArgs(key: key),
      );

  static const String name = 'Orders';
}

class OrdersArgs {
  const OrdersArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'OrdersArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Customers]
class CustomersRoute extends _i4.PageRouteInfo<CustomersArgs> {
  CustomersRoute({_i6.Key? key})
    : super(
        CustomersRoute.name,
        path: '/Customers',
        args: CustomersArgs(key: key),
      );

  static const String name = 'Customers';
}

class CustomersArgs {
  const CustomersArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'CustomersArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.NoNet]
class NoNetRoute extends _i4.PageRouteInfo<NoNetArgs> {
  NoNetRoute({_i6.Key? key})
    : super(
        NoNetRoute.name,
        path: '/no-net',
        args: NoNetArgs(key: key),
      );

  static const String name = 'NoNet';
}

class NoNetArgs {
  const NoNetArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'NoNetArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.PinLogin]
class PinLoginRoute extends _i4.PageRouteInfo<PinLoginArgs> {
  PinLoginRoute({_i6.Key? key})
    : super(
        PinLoginRoute.name,
        path: '/pin-login',
        args: PinLoginArgs(key: key),
      );

  static const String name = 'PinLogin';
}

class PinLoginArgs {
  const PinLoginArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'PinLoginArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Devices]
class DevicesRoute extends _i4.PageRouteInfo<DevicesArgs> {
  DevicesRoute({_i6.Key? key, int? pin})
    : super(
        DevicesRoute.name,
        path: '/Devices',
        args: DevicesArgs(key: key, pin: pin),
      );

  static const String name = 'Devices';
}

class DevicesArgs {
  const DevicesArgs({this.key, this.pin});

  final _i6.Key? key;

  final int? pin;

  @override
  String toString() {
    return 'DevicesArgs{key: $key, pin: $pin}';
  }
}

/// generated route for
/// [_i1.SystemConfig]
class SystemConfigRoute extends _i4.PageRouteInfo<SystemConfigArgs> {
  SystemConfigRoute({_i6.Key? key, required bool showheader})
    : super(
        SystemConfigRoute.name,
        path: '/system-config',
        args: SystemConfigArgs(key: key, showheader: showheader),
      );

  static const String name = 'SystemConfig';
}

class SystemConfigArgs {
  const SystemConfigArgs({this.key, required this.showheader});

  final _i6.Key? key;

  final bool showheader;

  @override
  String toString() {
    return 'SystemConfigArgs{key: $key, showheader: $showheader}';
  }
}

/// generated route for
/// [_i1.Printing]
class PrintingRoute extends _i4.PageRouteInfo<PrintingArgs> {
  PrintingRoute({_i6.Key? key})
    : super(
        PrintingRoute.name,
        path: '/Printing',
        args: PrintingArgs(key: key),
      );

  static const String name = 'Printing';
}

class PrintingArgs {
  const PrintingArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'PrintingArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.BackUp]
class BackUpRoute extends _i4.PageRouteInfo<BackUpArgs> {
  BackUpRoute({_i6.Key? key})
    : super(
        BackUpRoute.name,
        path: '/back-up',
        args: BackUpArgs(key: key),
      );

  static const String name = 'BackUp';
}

class BackUpArgs {
  const BackUpArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'BackUpArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.LoginChoices]
class LoginChoicesRoute extends _i4.PageRouteInfo<LoginChoicesArgs> {
  LoginChoicesRoute({_i6.Key? key})
    : super(
        LoginChoicesRoute.name,
        path: '/login-choices',
        args: LoginChoicesArgs(key: key),
      );

  static const String name = 'LoginChoices';
}

class LoginChoicesArgs {
  const LoginChoicesArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'LoginChoicesArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.TenantManagement]
class TenantManagementRoute extends _i4.PageRouteInfo<TenantManagementArgs> {
  TenantManagementRoute({_i6.Key? key})
    : super(
        TenantManagementRoute.name,
        path: '/tenant-management',
        args: TenantManagementArgs(key: key),
      );

  static const String name = 'TenantManagement';
}

class TenantManagementArgs {
  const TenantManagementArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'TenantManagementArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.AgentCommissionScreen]
class AgentCommissionScreenRoute
    extends _i4.PageRouteInfo<AgentCommissionScreenArgs> {
  AgentCommissionScreenRoute({_i6.Key? key, bool embeddedInDashboard = false})
    : super(
        AgentCommissionScreenRoute.name,
        path: '/agent-commission-screen',
        args: AgentCommissionScreenArgs(
          key: key,
          embeddedInDashboard: embeddedInDashboard,
        ),
      );

  static const String name = 'AgentCommissionScreen';
}

class AgentCommissionScreenArgs {
  const AgentCommissionScreenArgs({this.key, this.embeddedInDashboard = false});

  final _i6.Key? key;

  final bool embeddedInDashboard;

  @override
  String toString() {
    return 'AgentCommissionScreenArgs{key: $key, embeddedInDashboard: $embeddedInDashboard}';
  }
}

/// generated route for
/// [_i1.DrawerScreen]
class DrawerScreenRoute extends _i4.PageRouteInfo<DrawerScreenArgs> {
  DrawerScreenRoute({_i6.Key? key, required String open})
    : super(
        DrawerScreenRoute.name,
        path: '/drawer-screen',
        args: DrawerScreenArgs(key: key, open: open),
      );

  static const String name = 'DrawerScreen';
}

class DrawerScreenArgs {
  const DrawerScreenArgs({this.key, required this.open});

  final _i6.Key? key;

  final String open;

  @override
  String toString() {
    return 'DrawerScreenArgs{key: $key, open: $open}';
  }
}

/// generated route for
/// [_i1.TicketsList]
class TicketsListRoute extends _i4.PageRouteInfo<TicketsListArgs> {
  TicketsListRoute({
    _i6.Key? key,
    required _i7.ITransaction? transaction,
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

  final _i6.Key? key;

  final _i7.ITransaction? transaction;

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
    _i6.Key? key,
    required _i7.ITransaction transaction,
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

  final _i6.Key? key;

  final _i7.ITransaction transaction;

  final void Function() onClose;

  @override
  String toString() {
    return 'NewTicketArgs{key: $key, transaction: $transaction, onClose: $onClose}';
  }
}

/// generated route for
/// [_i1.MobileView]
class MobileViewRoute extends _i4.PageRouteInfo<MobileViewArgs> {
  MobileViewRoute({
    _i6.Key? key,
    required _i5.TextEditingController controller,
    required bool isBigScreen,
    required _i7.CoreViewModel model,
  }) : super(
         MobileViewRoute.name,
         path: '/mobile-view',
         args: MobileViewArgs(
           key: key,
           controller: controller,
           isBigScreen: isBigScreen,
           model: model,
         ),
       );

  static const String name = 'MobileView';
}

class MobileViewArgs {
  const MobileViewArgs({
    this.key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
  });

  final _i6.Key? key;

  final _i5.TextEditingController controller;

  final bool isBigScreen;

  final _i7.CoreViewModel model;

  @override
  String toString() {
    return 'MobileViewArgs{key: $key, controller: $controller, isBigScreen: $isBigScreen, model: $model}';
  }
}

/// generated route for
/// [_i1.CheckOut]
class CheckOutRoute extends _i4.PageRouteInfo<CheckOutArgs> {
  CheckOutRoute({_i6.Key? key, bool isBigScreen = false})
    : super(
        CheckOutRoute.name,
        path: '/check-out',
        args: CheckOutArgs(key: key, isBigScreen: isBigScreen),
      );

  static const String name = 'CheckOut';
}

class CheckOutArgs {
  const CheckOutArgs({this.key, this.isBigScreen = false});

  final _i6.Key? key;

  final bool isBigScreen;

  @override
  String toString() {
    return 'CheckOutArgs{key: $key, isBigScreen: $isBigScreen}';
  }
}

/// generated route for
/// [_i1.BarModeHost]
class BarModeHostRoute extends _i4.PageRouteInfo<BarModeHostArgs> {
  BarModeHostRoute({_i6.Key? key})
    : super(
        BarModeHostRoute.name,
        path: '/bar-mode-host',
        args: BarModeHostArgs(key: key),
      );

  static const String name = 'BarModeHost';
}

class BarModeHostArgs {
  const BarModeHostArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'BarModeHostArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.HotelModeHost]
class HotelModeHostRoute extends _i4.PageRouteInfo<HotelModeHostArgs> {
  HotelModeHostRoute({_i6.Key? key})
    : super(
        HotelModeHostRoute.name,
        path: '/hotel-mode-host',
        args: HotelModeHostArgs(key: key),
      );

  static const String name = 'HotelModeHost';
}

class HotelModeHostArgs {
  const HotelModeHostArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'HotelModeHostArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Cashbook]
class CashbookRoute extends _i4.PageRouteInfo<CashbookArgs> {
  CashbookRoute({_i6.Key? key, required bool isBigScreen})
    : super(
        CashbookRoute.name,
        path: '/Cashbook',
        args: CashbookArgs(key: key, isBigScreen: isBigScreen),
      );

  static const String name = 'Cashbook';
}

class CashbookArgs {
  const CashbookArgs({this.key, required this.isBigScreen});

  final _i6.Key? key;

  final bool isBigScreen;

  @override
  String toString() {
    return 'CashbookArgs{key: $key, isBigScreen: $isBigScreen}';
  }
}

/// generated route for
/// [_i1.SettingPage]
class SettingPageRoute extends _i4.PageRouteInfo<SettingPageArgs> {
  SettingPageRoute({_i6.Key? key})
    : super(
        SettingPageRoute.name,
        path: '/setting-page',
        args: SettingPageArgs(key: key),
      );

  static const String name = 'SettingPage';
}

class SettingPageArgs {
  const SettingPageArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'SettingPageArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Transactions]
class TransactionsRoute extends _i4.PageRouteInfo<TransactionsArgs> {
  TransactionsRoute({_i6.Key? key})
    : super(
        TransactionsRoute.name,
        path: '/Transactions',
        args: TransactionsArgs(key: key),
      );

  static const String name = 'Transactions';
}

class TransactionsArgs {
  const TransactionsArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'TransactionsArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.Security]
class SecurityRoute extends _i4.PageRouteInfo<SecurityArgs> {
  SecurityRoute({_i6.Key? key})
    : super(
        SecurityRoute.name,
        path: '/Security',
        args: SecurityArgs(key: key),
      );

  static const String name = 'Security';
}

class SecurityArgs {
  const SecurityArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'SecurityArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ReportsDashboard]
class ReportsDashboardRoute extends _i4.PageRouteInfo<ReportsDashboardArgs> {
  ReportsDashboardRoute({_i6.Key? key, bool isInDialog = false})
    : super(
        ReportsDashboardRoute.name,
        path: '/reports-dashboard',
        args: ReportsDashboardArgs(key: key, isInDialog: isInDialog),
      );

  static const String name = 'ReportsDashboard';
}

class ReportsDashboardArgs {
  const ReportsDashboardArgs({this.key, this.isInDialog = false});

  final _i6.Key? key;

  final bool isInDialog;

  @override
  String toString() {
    return 'ReportsDashboardArgs{key: $key, isInDialog: $isInDialog}';
  }
}

/// generated route for
/// [_i1.AdminControl]
class AdminControlRoute extends _i4.PageRouteInfo<AdminControlArgs> {
  AdminControlRoute({_i6.Key? key})
    : super(
        AdminControlRoute.name,
        path: '/admin-control',
        args: AdminControlArgs(key: key),
      );

  static const String name = 'AdminControl';
}

class AdminControlArgs {
  const AdminControlArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'AdminControlArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.AddBranch]
class AddBranchRoute extends _i4.PageRouteInfo<void> {
  const AddBranchRoute() : super(AddBranchRoute.name, path: '/add-branch');

  static const String name = 'AddBranch';
}

/// generated route for
/// [_i2.QuickSellingView]
class QuickSellingViewRoute extends _i4.PageRouteInfo<QuickSellingViewArgs> {
  QuickSellingViewRoute({
    _i6.Key? key,
    required _i5.GlobalKey<_i5.FormState> formKey,
    required _i5.TextEditingController discountController,
    required _i5.TextEditingController receivedAmountController,
    required _i5.TextEditingController deliveryNoteCotroller,
    required _i5.TextEditingController customerPhoneNumberController,
    required _i5.TextEditingController paymentTypeController,
    required _i5.TextEditingController countryCodeController,
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
           paymentTypeController: paymentTypeController,
           countryCodeController: countryCodeController,
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
    required this.paymentTypeController,
    required this.countryCodeController,
  });

  final _i6.Key? key;

  final _i5.GlobalKey<_i5.FormState> formKey;

  final _i5.TextEditingController discountController;

  final _i5.TextEditingController receivedAmountController;

  final _i5.TextEditingController deliveryNoteCotroller;

  final _i5.TextEditingController customerPhoneNumberController;

  final _i5.TextEditingController paymentTypeController;

  final _i5.TextEditingController countryCodeController;

  @override
  String toString() {
    return 'QuickSellingViewArgs{key: $key, formKey: $formKey, discountController: $discountController, receivedAmountController: $receivedAmountController, deliveryNoteCotroller: $deliveryNoteCotroller, customerPhoneNumberController: $customerPhoneNumberController, paymentTypeController: $paymentTypeController, countryCodeController: $countryCodeController}';
  }
}

/// generated route for
/// [_i1.PaymentPlanUI]
class PaymentPlanUIRoute extends _i4.PageRouteInfo<PaymentPlanUIArgs> {
  PaymentPlanUIRoute({_i6.Key? key, bool skipPaymentStatusCheck = false})
    : super(
        PaymentPlanUIRoute.name,
        path: '/payment-plan-uI',
        args: PaymentPlanUIArgs(
          key: key,
          skipPaymentStatusCheck: skipPaymentStatusCheck,
        ),
      );

  static const String name = 'PaymentPlanUI';
}

class PaymentPlanUIArgs {
  const PaymentPlanUIArgs({this.key, this.skipPaymentStatusCheck = false});

  final _i6.Key? key;

  final bool skipPaymentStatusCheck;

  @override
  String toString() {
    return 'PaymentPlanUIArgs{key: $key, skipPaymentStatusCheck: $skipPaymentStatusCheck}';
  }
}

/// generated route for
/// [_i1.PaymentFinalize]
class PaymentFinalizeRoute extends _i4.PageRouteInfo<void> {
  const PaymentFinalizeRoute()
    : super(PaymentFinalizeRoute.name, path: '/payment-finalize');

  static const String name = 'PaymentFinalize';
}

/// generated route for
/// [_i1.WaitingOrdersPlaced]
class WaitingOrdersPlacedRoute
    extends _i4.PageRouteInfo<WaitingOrdersPlacedArgs> {
  WaitingOrdersPlacedRoute({required String orderId, _i6.Key? key})
    : super(
        WaitingOrdersPlacedRoute.name,
        path: '/waiting-orders-placed',
        args: WaitingOrdersPlacedArgs(orderId: orderId, key: key),
      );

  static const String name = 'WaitingOrdersPlaced';
}

class WaitingOrdersPlacedArgs {
  const WaitingOrdersPlacedArgs({required this.orderId, this.key});

  final String orderId;

  final _i6.Key? key;

  @override
  String toString() {
    return 'WaitingOrdersPlacedArgs{orderId: $orderId, key: $key}';
  }
}

/// generated route for
/// [_i1.CreditApp]
class CreditAppRoute extends _i4.PageRouteInfo<CreditAppArgs> {
  CreditAppRoute({_i6.Key? key})
    : super(
        CreditAppRoute.name,
        path: '/credit-app',
        args: CreditAppArgs(key: key),
      );

  static const String name = 'CreditApp';
}

class CreditAppArgs {
  const CreditAppArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'CreditAppArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.ShiftHistoryView]
class ShiftHistoryViewRoute extends _i4.PageRouteInfo<ShiftHistoryViewArgs> {
  ShiftHistoryViewRoute({_i6.Key? key, void Function()? onBack})
    : super(
        ShiftHistoryViewRoute.name,
        path: '/shift-history-view',
        args: ShiftHistoryViewArgs(key: key, onBack: onBack),
      );

  static const String name = 'ShiftHistoryView';
}

class ShiftHistoryViewArgs {
  const ShiftHistoryViewArgs({this.key, this.onBack});

  final _i6.Key? key;

  final void Function()? onBack;

  @override
  String toString() {
    return 'ShiftHistoryViewArgs{key: $key, onBack: $onBack}';
  }
}

/// generated route for
/// [_i1.PersonalHomeScreen]
class PersonalHomeScreenRoute
    extends _i4.PageRouteInfo<PersonalHomeScreenArgs> {
  PersonalHomeScreenRoute({_i6.Key? key})
    : super(
        PersonalHomeScreenRoute.name,
        path: '/personal-home-screen',
        args: PersonalHomeScreenArgs(key: key),
      );

  static const String name = 'PersonalHomeScreen';
}

class PersonalHomeScreenArgs {
  const PersonalHomeScreenArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'PersonalHomeScreenArgs{key: $key}';
  }
}

extension RouterStateExtension on _i3.RouterService {
  Future<dynamic> navigateToStartUpView({
    _i6.Key? key,
    bool? invokeLogin,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      StartUpViewRoute(key: key, invokeLogin: invokeLogin),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSignUpView({
    _i6.Key? key,
    String? countryNm = "Rwanda",
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SignUpViewRoute(key: key, countryNm: countryNm),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToFlipperApp({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(FlipperAppRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToFailedPayment({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(FailedPaymentRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToLogin({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(LoginRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToLanding({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(LandingRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToAuth({
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(const AuthRoute(), onFailure: onFailure);
  }

  Future<dynamic> navigateToCountryPicker({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(CountryPickerRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToAiScreen({
    _i6.Key? key,
    void Function()? onPurchaseCredits,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AiScreenRoute(key: key, onPurchaseCredits: onPurchaseCredits),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPhoneInputScreen({
    _i6.Key? key,
    required String countryCode,
    _i5.Widget Function(_i5.BuildContext)? subtitleBuilder,
    _i5.Widget Function(_i5.BuildContext)? footerBuilder,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PhoneInputScreenRoute(
        key: key,
        countryCode: countryCode,
        subtitleBuilder: subtitleBuilder,
        footerBuilder: footerBuilder,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToInventoryRequestMobileView({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      InventoryRequestMobileViewRoute(key: key),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddProductView({
    _i6.Key? key,
    String? productId,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddProductViewRoute(key: key, productId: productId),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddToFavorites({
    _i6.Key? key,
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
    _i6.Key? key,
    _i7.Discount? discount,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddDiscountRoute(key: key, discount: discount),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToListCategories({
    _i6.Key? key,
    required String? modeOfOperation,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ListCategoriesRoute(key: key, modeOfOperation: modeOfOperation),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToColorTile({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(ColorTileRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToReceiveStock({
    _i6.Key? key,
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
    _i6.Key? key,
    required String productId,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AddVariationRoute(key: key, productId: productId),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAddCategory({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(AddCategoryRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToListUnits({
    _i6.Key? key,
    required String type,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ListUnitsRoute(key: key, type: type),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSell({
    _i6.Key? key,
    required _i7.Product product,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SellRoute(key: key, product: product),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPayments({
    _i6.Key? key,
    required _i7.ITransaction transaction,
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
    _i6.Key? key,
    required _i7.ITransaction transaction,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PaymentConfirmationRoute(key: key, transaction: transaction),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTransactionDetail({
    _i6.Key? key,
    required _i7.ITransaction transaction,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      TransactionDetailRoute(key: key, transaction: transaction),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSettingsScreen({
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(const SettingsScreenRoute(), onFailure: onFailure);
  }

  Future<dynamic> navigateToSwitchBranchView({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(SwitchBranchViewRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToOrderView({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(OrderViewRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToOrders({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(OrdersRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToCustomers({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(CustomersRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToNoNet({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(NoNetRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToPinLogin({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(PinLoginRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToDevices({
    _i6.Key? key,
    int? pin,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      DevicesRoute(key: key, pin: pin),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSystemConfig({
    _i6.Key? key,
    required bool showheader,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      SystemConfigRoute(key: key, showheader: showheader),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPrinting({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(PrintingRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToBackUp({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(BackUpRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToLoginChoices({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(LoginChoicesRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToTenantManagement({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(TenantManagementRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToAgentCommissionScreen({
    _i6.Key? key,
    bool embeddedInDashboard = false,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      AgentCommissionScreenRoute(
        key: key,
        embeddedInDashboard: embeddedInDashboard,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToDrawerScreen({
    _i6.Key? key,
    required String open,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      DrawerScreenRoute(key: key, open: open),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToTicketsList({
    _i6.Key? key,
    required _i7.ITransaction? transaction,
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
    _i6.Key? key,
    required _i7.ITransaction transaction,
    required void Function() onClose,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      NewTicketRoute(key: key, transaction: transaction, onClose: onClose),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToMobileView({
    _i6.Key? key,
    required _i5.TextEditingController controller,
    required bool isBigScreen,
    required _i7.CoreViewModel model,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      MobileViewRoute(
        key: key,
        controller: controller,
        isBigScreen: isBigScreen,
        model: model,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCheckOut({
    _i6.Key? key,
    bool isBigScreen = false,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      CheckOutRoute(key: key, isBigScreen: isBigScreen),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToBarModeHost({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(BarModeHostRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToHotelModeHost({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(HotelModeHostRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToCashbook({
    _i6.Key? key,
    required bool isBigScreen,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      CashbookRoute(key: key, isBigScreen: isBigScreen),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToSettingPage({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(SettingPageRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToTransactions({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(TransactionsRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToSecurity({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(SecurityRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToReportsDashboard({
    _i6.Key? key,
    bool isInDialog = false,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ReportsDashboardRoute(key: key, isInDialog: isInDialog),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToAdminControl({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(AdminControlRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToAddBranch({
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(const AddBranchRoute(), onFailure: onFailure);
  }

  Future<dynamic> navigateToQuickSellingView({
    _i6.Key? key,
    required _i5.GlobalKey<_i5.FormState> formKey,
    required _i5.TextEditingController discountController,
    required _i5.TextEditingController receivedAmountController,
    required _i5.TextEditingController deliveryNoteCotroller,
    required _i5.TextEditingController customerPhoneNumberController,
    required _i5.TextEditingController paymentTypeController,
    required _i5.TextEditingController countryCodeController,
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
        paymentTypeController: paymentTypeController,
        countryCodeController: countryCodeController,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPaymentPlanUI({
    _i6.Key? key,
    bool skipPaymentStatusCheck = false,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      PaymentPlanUIRoute(
        key: key,
        skipPaymentStatusCheck: skipPaymentStatusCheck,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPaymentFinalize({
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(const PaymentFinalizeRoute(), onFailure: onFailure);
  }

  Future<dynamic> navigateToWaitingOrdersPlaced({
    required String orderId,
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      WaitingOrdersPlacedRoute(orderId: orderId, key: key),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToCreditApp({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(CreditAppRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> navigateToShiftHistoryView({
    _i6.Key? key,
    void Function()? onBack,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(
      ShiftHistoryViewRoute(key: key, onBack: onBack),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToPersonalHomeScreen({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return navigateTo(PersonalHomeScreenRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithStartUpView({
    _i6.Key? key,
    bool? invokeLogin,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      StartUpViewRoute(key: key, invokeLogin: invokeLogin),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSignUpView({
    _i6.Key? key,
    String? countryNm = "Rwanda",
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SignUpViewRoute(key: key, countryNm: countryNm),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithFlipperApp({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(FlipperAppRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithFailedPayment({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(FailedPaymentRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithLogin({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(LoginRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithLanding({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(LandingRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithAuth({
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(const AuthRoute(), onFailure: onFailure);
  }

  Future<dynamic> replaceWithCountryPicker({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(CountryPickerRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithAiScreen({
    _i6.Key? key,
    void Function()? onPurchaseCredits,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AiScreenRoute(key: key, onPurchaseCredits: onPurchaseCredits),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPhoneInputScreen({
    _i6.Key? key,
    required String countryCode,
    _i5.Widget Function(_i5.BuildContext)? subtitleBuilder,
    _i5.Widget Function(_i5.BuildContext)? footerBuilder,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PhoneInputScreenRoute(
        key: key,
        countryCode: countryCode,
        subtitleBuilder: subtitleBuilder,
        footerBuilder: footerBuilder,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithInventoryRequestMobileView({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      InventoryRequestMobileViewRoute(key: key),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddProductView({
    _i6.Key? key,
    String? productId,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddProductViewRoute(key: key, productId: productId),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddToFavorites({
    _i6.Key? key,
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
    _i6.Key? key,
    _i7.Discount? discount,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddDiscountRoute(key: key, discount: discount),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithListCategories({
    _i6.Key? key,
    required String? modeOfOperation,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ListCategoriesRoute(key: key, modeOfOperation: modeOfOperation),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithColorTile({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(ColorTileRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithReceiveStock({
    _i6.Key? key,
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
    _i6.Key? key,
    required String productId,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AddVariationRoute(key: key, productId: productId),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAddCategory({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(AddCategoryRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithListUnits({
    _i6.Key? key,
    required String type,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ListUnitsRoute(key: key, type: type),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSell({
    _i6.Key? key,
    required _i7.Product product,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SellRoute(key: key, product: product),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPayments({
    _i6.Key? key,
    required _i7.ITransaction transaction,
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
    _i6.Key? key,
    required _i7.ITransaction transaction,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PaymentConfirmationRoute(key: key, transaction: transaction),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTransactionDetail({
    _i6.Key? key,
    required _i7.ITransaction transaction,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      TransactionDetailRoute(key: key, transaction: transaction),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSettingsScreen({
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(const SettingsScreenRoute(), onFailure: onFailure);
  }

  Future<dynamic> replaceWithSwitchBranchView({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(SwitchBranchViewRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithOrderView({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(OrderViewRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithOrders({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(OrdersRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithCustomers({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(CustomersRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithNoNet({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(NoNetRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithPinLogin({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(PinLoginRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithDevices({
    _i6.Key? key,
    int? pin,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      DevicesRoute(key: key, pin: pin),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSystemConfig({
    _i6.Key? key,
    required bool showheader,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      SystemConfigRoute(key: key, showheader: showheader),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPrinting({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(PrintingRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithBackUp({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(BackUpRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithLoginChoices({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(LoginChoicesRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithTenantManagement({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(TenantManagementRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithAgentCommissionScreen({
    _i6.Key? key,
    bool embeddedInDashboard = false,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      AgentCommissionScreenRoute(
        key: key,
        embeddedInDashboard: embeddedInDashboard,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithDrawerScreen({
    _i6.Key? key,
    required String open,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      DrawerScreenRoute(key: key, open: open),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithTicketsList({
    _i6.Key? key,
    required _i7.ITransaction? transaction,
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
    _i6.Key? key,
    required _i7.ITransaction transaction,
    required void Function() onClose,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      NewTicketRoute(key: key, transaction: transaction, onClose: onClose),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithMobileView({
    _i6.Key? key,
    required _i5.TextEditingController controller,
    required bool isBigScreen,
    required _i7.CoreViewModel model,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      MobileViewRoute(
        key: key,
        controller: controller,
        isBigScreen: isBigScreen,
        model: model,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCheckOut({
    _i6.Key? key,
    bool isBigScreen = false,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      CheckOutRoute(key: key, isBigScreen: isBigScreen),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithBarModeHost({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(BarModeHostRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithHotelModeHost({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(HotelModeHostRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithCashbook({
    _i6.Key? key,
    required bool isBigScreen,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      CashbookRoute(key: key, isBigScreen: isBigScreen),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithSettingPage({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(SettingPageRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithTransactions({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(TransactionsRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithSecurity({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(SecurityRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithReportsDashboard({
    _i6.Key? key,
    bool isInDialog = false,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ReportsDashboardRoute(key: key, isInDialog: isInDialog),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithAdminControl({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(AdminControlRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithAddBranch({
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(const AddBranchRoute(), onFailure: onFailure);
  }

  Future<dynamic> replaceWithQuickSellingView({
    _i6.Key? key,
    required _i5.GlobalKey<_i5.FormState> formKey,
    required _i5.TextEditingController discountController,
    required _i5.TextEditingController receivedAmountController,
    required _i5.TextEditingController deliveryNoteCotroller,
    required _i5.TextEditingController customerPhoneNumberController,
    required _i5.TextEditingController paymentTypeController,
    required _i5.TextEditingController countryCodeController,
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
        paymentTypeController: paymentTypeController,
        countryCodeController: countryCodeController,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPaymentPlanUI({
    _i6.Key? key,
    bool skipPaymentStatusCheck = false,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      PaymentPlanUIRoute(
        key: key,
        skipPaymentStatusCheck: skipPaymentStatusCheck,
      ),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPaymentFinalize({
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(const PaymentFinalizeRoute(), onFailure: onFailure);
  }

  Future<dynamic> replaceWithWaitingOrdersPlaced({
    required String orderId,
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      WaitingOrdersPlacedRoute(orderId: orderId, key: key),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithCreditApp({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(CreditAppRoute(key: key), onFailure: onFailure);
  }

  Future<dynamic> replaceWithShiftHistoryView({
    _i6.Key? key,
    void Function()? onBack,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(
      ShiftHistoryViewRoute(key: key, onBack: onBack),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithPersonalHomeScreen({
    _i6.Key? key,
    void Function(_i4.NavigationFailure)? onFailure,
  }) async {
    return replaceWith(PersonalHomeScreenRoute(key: key), onFailure: onFailure);
  }
}
