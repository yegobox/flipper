library flipper_models;

import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:realm/realm.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'gate.dart';

class SignupViewModel extends ReactiveViewModel {
  final appService = loc.getIt<AppService>();
  final _routerService = locator<RouterService>();
  bool registerStart = false;

  String? longitude = '1';
  String? latitude = '1';

  String? kName;
  void setName({String? name}) {
    kName = name;
  }

  String? kFullName;
  void setFullName({String? name}) {
    kFullName = name;
  }

  String? kCountry;
  void setCountry({String? country}) {
    kCountry = country;
  }

  String? _tin;
  String? get tin => _tin;
  set tin(String? value) {
    _tin = value;
    notifyListeners();
  }

  var _businessType = null;
  BusinessType get businessType => _businessType;
  set businessType(BusinessType value) {
    _businessType = value;
    notifyListeners();
  }

  void registerLocation() async {
    final permission = await ProxyService.location.hasLocationPermission();
    if (permission) {
      final Map<String, String> location =
          await ProxyService.location.getLocations();
      longitude = location['longitude'];
      latitude = location['latitude'];

      notifyListeners();
    } else {
      final Map<String, String> location =
          await ProxyService.location.getLocations();
      longitude = location['longitude'];
      latitude = location['latitude'];
      notifyListeners();
    }
  }

  BuildContext? context;
  Future<void> signup() async {
    try {
      startRegistering();
      setDefaultApp();

      String? referralCode = getReferralCode();

      List<ITenant> tenants = await registerTenant(referralCode);

      if (tenants.isNotEmpty) {
        await postRegistrationTasks(tenants);
      }
    } catch (e, stackTrace) {
      stopRegistering();
      log(e.toString());
      throw Exception(stackTrace);
    }
  }

  void startRegistering() {
    registerStart = true;
    notifyListeners();
  }

  void stopRegistering() {
    registerStart = false;
    notifyListeners();
  }

  void setDefaultApp() {
    ProxyService.box.writeString(key: defaultApp, value: businessType.id);
  }

  String? getReferralCode() {
    return ProxyService.box.readString(key: 'referralCode');
  }

  Future<List<ITenant>> registerTenant(String? referralCode) async {
    try {
      int userId = ProxyService.box.getUserId()!;
      String phoneNumber = ProxyService.box.getUserPhone()!;
      return await ProxyService.local.signup(business: {
        'name': kName,
        'latitude': latitude,
        'longitude': longitude,
        'phoneNumber': phoneNumber,
        'currency': 'RWF',
        'createdAt': DateTime.now().toIso8601String(),
        'userId': userId,
        "tinNumber": tin != null ? int.parse(tin!) : 1111,
        'businessTypeId': "1", //businessType.id, // default to 1 for now
        'type': 'Business',
        'bhfid': '00',
        'referredBy': referralCode ?? 'Organic',
        'fullName': kFullName,
        'country': kCountry
      }, flipperHttpClient: ProxyService.http);
    } catch (e, s) {
      talker.error(s);
      talker.error(e);
      rethrow;
    }
  }

  Future<void> postRegistrationTasks(List<ITenant> tenants) async {
    if (businessType.id == "2") {
      await registerOnSocial();
    }

    await saveBusinessId(tenants);
    Business business = await getBusiness(tenants);
    List<Branch> branches = await getBranches(business);
    await saveBranchId(branches);

    appService.appInit();
    await createDefaultCategory(branches);
    await createDefaultColor(branches);
    // save default Access permission as admin on key features
    // await addDefaultUnits();
    ProxyService.forceDateEntry.dataBootstrapper();

    LoginInfo().isLoggedIn = true;
    LoginInfo().redirecting = false;
    LoginInfo().needSignUp = false;
    _routerService.navigateTo(StartUpViewRoute(invokeLogin: true));
  }

  Future<void> registerOnSocial() {
    return ProxyService.local.registerOnSocial(
      password: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
      phoneNumberOrEmail: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
    );
  }

  Future<void> saveBusinessId(List<ITenant> tenants) {
    return ProxyService.box.writeInt(
      key: 'businessId',
      value: tenants.first.businesses.first.id!,
    );
  }

  Future<Business> getBusiness(List<ITenant> tenants) {
    return ProxyService.local
        .getBusinessFuture(businessId: tenants.first.businesses.first.id);
  }

  List<Branch> getBranches(Business business) {
    return ProxyService.local.branches(businessId: business.serverId);
  }

  Future<void> saveBranchId(List<Branch> branches) {
    return ProxyService.box
        .writeInt(key: 'branchId', value: branches[0].serverId!);
  }

  Future<void> createDefaultCategory(List<Branch> branches) async {
    final Category category = Category(
      ObjectId(),
      active: true,
      focused: true,
      name: "NONE",
      id: randomNumber(),
      branchId: branches[0].serverId!,
    );
    ProxyService.local.create<Category>(data: category);
  }

  Future<void> createDefaultColor(List<Branch> branches) async {
    final PColor color = PColor(
      ObjectId(),
      id: randomNumber(),
      colors: [
        '#d63031',
        '#0984e3',
        '#e84393',
        '#2d3436',
        '#6c5ce7',
        '#74b9ff',
        '#ff7675',
        '#a29bfe'
      ],
      active: false,
      lastTouched: DateTime.now(),
      action: AppActions.created,
      branchId: branches[0].serverId,
      name: 'color',
    );
    ProxyService.local.create<PColor>(data: color);
  }
}
