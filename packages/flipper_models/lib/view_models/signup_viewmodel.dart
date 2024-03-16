library flipper_models;

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart' as found;
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/mocks.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'gate.dart';

import 'package:http/http.dart' as http;

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

      List<Tenant> tenants = await registerTenant(referralCode);

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

  Future<List<Tenant>> registerTenant(String? referralCode) {
    return  await ProxyService.isar.signup(business: {
      'name': kName,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': ProxyService.box.getUserPhone(),
      'currency': 'RWF',
      'createdAt': DateTime.now().toIso8601String(),
      'userId': ProxyService.box.getUserId(),
      "tinNumber": tin != null ? int.parse(tin!) : 1111,
      'businessTypeId': "1", //businessType.id, // default to 1 for now
      'type': 'Business',
      'referredBy': referralCode ?? 'Organic',
      'fullName': kFullName,
      'country': kCountry
    });
  }

  Future<void> postRegistrationTasks(List<Tenant> tenants) async {
    await pocketDbRegistration();

    if (businessType.id == "2") {
      await registerOnSocial();
    }

    await saveBusinessId(tenants);
    Business? business = await getBusiness(tenants);
    List<Branch> branches = await getBranches(business);
    await saveBranchId(branches);

    appService.appInit();
    await createDefaultCategory(branches);
    await createDefaultColor(branches);
    await addDefaultUnits();
    bootstrapData();

    LoginInfo().isLoggedIn = true;
    LoginInfo().redirecting = false;
    LoginInfo().needSignUp = false;
    _routerService.navigateTo(StartUpViewRoute(invokeLogin: true));
  }

  Future<void> registerOnSocial() {
    return ProxyService.isar.registerOnSocial(
      password: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
      phoneNumberOrEmail: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
    );
  }

  Future<void> saveBusinessId(List<Tenant> tenants) {
    return ProxyService.box.writeInt(
      key: 'businessId',
      value: tenants.first.businesses.first.id,
    );
  }

  Future<Business?> getBusiness(List<Tenant> tenants) {
    return ProxyService.isar
        .getBusiness(businessId: tenants.first.businesses.first.id);
  }

  Future<List<Branch>> getBranches(Business? business) {
    return ProxyService.isar.branches(businessId: business!.id);
  }

  Future<void> saveBranchId(List<Branch> branches) {
    return ProxyService.box.writeInt(key: 'branchId', value: branches[0].id);
  }

  Future<void> createDefaultCategory(List<Branch> branches) async {
    final Category category = Category(
      active: true,
      focused: true,
      name: "NONE",
      id: randomString(),
      branchId: branches[0].id,
    );
    ProxyService.isar.create<Category>(data: category);
  }

  Future<void> createDefaultColor(List<Branch> branches) async {
    final PColor color = PColor(
      id: randomString(),
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
      branchId: branches[0].id,
      name: 'color',
    );
    ProxyService.isar.create<PColor>(data: color);
  }

  Future<void> addDefaultUnits() {
    return ProxyService.isar.addUnits(units: mockUnits);
  }

  void bootstrapData() {
    ProxyService.forceDateEntry.dataBootstrapper();
  }

  Future<void> pocketDbRegistration() async {
    String? pocketDbToken;
    if (found.kDebugMode) {
      pocketDbToken = await ProxyService.remote.getToken(AppSecrets.apiUrlDebug,
          AppSecrets.debugPassword, AppSecrets.debugEmail);
    } else {
      pocketDbToken = await ProxyService.remote.getToken(
          AppSecrets.apiUrlProd, AppSecrets.prodPassword, AppSecrets.prodEmail);
    }
    firebase.User? firebaseUser = firebase.FirebaseAuth.instance.currentUser;
    var headers = {
      'Authorization':
          'Bearer ' + (pocketDbToken ?? ''), // Ensure pocketDbToken is not null
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppSecrets.apiUrlDebug + '/api/collections/users/records'),
    );

    String? userEmail = firebaseUser?.email;
    String? userPhoneNumber = firebaseUser?.phoneNumber;

    String? email;

    if (userEmail != null) {
      email = userEmail;
    } else if (userPhoneNumber != null) {
      email = userPhoneNumber.replaceAll(RegExp(r'[^0-9]'), '') + '@gmail.com';
    } else {
      email = null; // Handle this case as needed
    }
    // Handle null cases and provide non-nullable values
    request.fields.addAll({
      'password': firebaseUser?.email ?? firebaseUser?.phoneNumber ?? '',
      'passwordConfirm': firebaseUser?.email ?? firebaseUser?.phoneNumber ?? '',
      'email': email!,
      'username': firebaseUser?.displayName ?? '',
      'verified': 'true', // Assuming 'verified' is expected to be a string
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
