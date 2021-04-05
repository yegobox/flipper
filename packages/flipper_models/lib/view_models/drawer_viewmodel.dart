import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/fuser.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:stacked/stacked.dart';

class DrawerViewModel extends ReactiveViewModel {
  final state = locator<SharedStateService>();
  final DatabaseService _db = ProxyService.database;

  FUser get user => state.user;
  Business get business => state.business;

  final List<Branch> _branches = <Branch>[];

  List<Branch> get branches => _branches;

  final List<Business> _businesses = <Business>[];

  List<Business> get businesses => _businesses;

  Future getBranches() async {
    final q = Query(_db.db,
        'SELECT id,businessId,createdAt,name,mapLatitude,mapLongitude,updatedAt,description,active,channels,location WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.branch};

    final results = q.execute();

    for (Map map in results.allResults) {
      if (!_branches.contains(Branch.fromMap(map))) {
        _branches.add(Branch.fromMap(map));
        state.setBranch(branch: Branch.fromMap(map));
      }
    }
    notifyListeners();
  }

  Future getBusiness() async {
    assert(user.id != null);
    print(user.id);
    final Logger log = Logging.getLogger('get business:');

    final q = Query(ProxyService.database.db,
        'SELECT id,name,active,currency,categoryId,latitude,longitude,userId,typeId,timeZone,createdAt,updatedAt,channels,country,businessUrl,hexColor,image,type,table WHERE table=\$VALUE AND userId=\$USERID');

    q.parameters = {'VALUE': AppTables.business, 'USERID': user.id};

    final business = q.execute();

    for (Map map in business.allResults) {
      if (!_businesses.contains(Business.fromMap(map))) {
        if (Business.fromMap(map).active) {
          state.setBusiness(business: Business.fromMap(map));
        }
        _businesses.add(Business.fromMap(map));
      }
    }
    notifyListeners();
  }

  Future<void> desktopLogin({BuildContext context, String code}) async {
    final Store<AppState> store = StoreProvider.of<AppState>(context);

    await http.post('https://flipper.yegobox.com/api/ws', body: {
      'code': code,
      'token': store.state.user.token
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer  ${store.state.user.token}',
    });
  }

  Future<void> scanQR(BuildContext context) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    await desktopLogin(context: context, code: barcodeScanRes);
  }

  Future<void> loginWithQr({BuildContext context}) async {
    setBusy(true);

    await scanQR(context);

    setBusy(false);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [state];

  Future<void> switchBusiness(
      {@required Business from, @required Business to}) async {
    final Logger log = Logging.getLogger('Switch Business:');

    final Document fromBusiness = ProxyService.database.getById(id: from.id);

    if (from != to) {
      fromBusiness.properties['active'] = false;
      ProxyService.database.update(document: fromBusiness);
    }

    final Document toBusiness = ProxyService.database.getById(id: to.id);

    toBusiness.properties['active'] = !Business.fromMap(toBusiness.map).active;

    final k = ProxyService.database.update(document: toBusiness);

    state.setBusiness(business: Business.fromMap(k.map));

    notifyListeners();
  }
}
