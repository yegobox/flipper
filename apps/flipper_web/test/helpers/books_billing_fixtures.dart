import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/application/books_subscription_controller.dart';
import 'package:flipper_web/models/user_profile.dart';

Business testBusiness({
  String id = 'biz-1',
  String name = 'Kigali Traders',
  String phoneNumber = '0788123456',
  int businessTypeId = 1,
  bool isDefault = true,
}) =>
    Business(
      id: id,
      name: name,
      country: 'Rwanda',
      currency: 'RWF',
      latitude: '0',
      longitude: '0',
      active: true,
      userId: 'user-1',
      phoneNumber: phoneNumber,
      lastSeen: 0,
      backUpEnabled: false,
      fullName: 'Kigali Traders Ltd',
      tinNumber: 999909695,
      taxEnabled: false,
      businessTypeId: businessTypeId,
      serverId: 1,
      isDefault: isDefault,
      lastSubscriptionPaymentSucceeded: false,
    );

const mobileTemplate = SubscriptionPlanTemplate(
  id: 'tpl-mobile',
  slug: 'mobile',
  name: 'Mobile',
  monthlyPrice: 30000,
  yearlyDiscountPercent: 20,
  addons: [
    SubscriptionPlanAddonTemplate(
      id: 'addon-reports',
      planTemplateId: 'tpl-mobile',
      slug: 'reports',
      name: 'Reports',
      monthlyPrice: 5000,
      sortOrder: 0,
    ),
  ],
);

BooksPlanSelection monthlyMobile({List<String> addons = const []}) =>
    BooksPlanSelection(
      template: mobileTemplate,
      cadence: BillingCadence.monthly,
      addonSlugs: addons,
    );
