import 'package:flipper_services/abstractions/platform.dart';
import 'package:flipper_services/app_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'abstractions/api.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/share.dart';
import 'abstractions/storage.dart';
import 'abstractions/upload.dart';
import 'locator.dart';
import 'product_service.dart';

final isWindows = UniversalPlatform.isWindows;

final Api _apiService = locator<Api>();
final DynamicLink _dynamicLink = locator<DynamicLink>();
final Shareble _share = locator<Shareble>();
final NavigationService _nav = locator<NavigationService>();
final LoginStandard _auth = locator<LoginStandard>();
final FlipperLocation _location = locator<FlipperLocation>();
// final DB<Business> _db = locator<DB<Business>>();
final LocalStorage _box = locator<LocalStorage>();
final UploadT _upload = locator<UploadT>();
final AppService _appService = locator<AppService>();
final ProductService _productService = locator<ProductService>();

abstract class ProxyService {
  static Api get api => _apiService;
  static Shareble get share => _share;
  static DynamicLink get dynamicLink => _dynamicLink;
  static NavigationService get nav => _nav;
  static FlipperLocation get location => _location;
  static LocalStorage get box => _box;
  static LoginStandard get auth => _auth;
  static AppService get appService => _appService;
  static ProductService get productService => _productService;
  static UploadT get upload => _upload;
}
