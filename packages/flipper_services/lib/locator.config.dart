// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************
//
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i16;

import 'abstractions/analytic.dart' as _i3;
import 'abstractions/api.dart' as _i4;
import 'abstractions/dynamic_link.dart' as _i7;
import 'abstractions/location.dart' as _i9;
import 'abstractions/platform.dart' as _i15;
import 'abstractions/printer.dart' as _i19;
import 'abstractions/remote.dart' as _i21;
import 'abstractions/share.dart' as _i25;
import 'abstractions/storage.dart' as _i14;
import 'abstractions/upload.dart' as _i26;
import 'app_service.dart' as _i5;
import 'FirebaseCrashlyticService.dart' as _i6;
import 'firestore_api.dart' as _i8;
import 'force_data_service.dart' as _i10;
import 'http_api.dart' as _i11;
import 'in_app_review.dart' as _i23;
import 'keypad_service.dart' as _i12;
import 'local_notification_service.dart' as _i13;
import 'pdf_api.dart' as _i17;
import 'pdf_invoice_api.dart' as _i18;
import 'product_service.dart' as _i20;
import 'report_service.dart' as _i22;
import 'setting_service.dart' as _i24;
import 'third_party_services_module.dart'
    as _i27; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.Analytic>(
      () => thirdPartyServicesModule.analyticService);
  gh.lazySingleton<_i4.Api<dynamic>>(() => thirdPartyServicesModule.apiService);
  gh.lazySingleton<_i5.AppService>(() => thirdPartyServicesModule.appService);
  gh.lazySingleton<_i6.Crash>(() => thirdPartyServicesModule.crash);
  gh.lazySingleton<_i7.DynamicLink>(() => thirdPartyServicesModule.dynamicLink);
  gh.lazySingleton<_i8.Firestore>(() => thirdPartyServicesModule.firestore);
  gh.lazySingleton<_i9.FlipperLocation>(
      () => thirdPartyServicesModule.location);
  gh.lazySingleton<_i10.ForceDataEntryService>(
      () => thirdPartyServicesModule.forcedataEntry);
  gh.lazySingleton<_i11.HttpApi<dynamic>>(() => _i11.HttpApi<dynamic>());
  gh.lazySingleton<_i12.KeyPadService>(
      () => thirdPartyServicesModule.keypadService);
  gh.lazySingleton<_i13.LNotification>(
      () => thirdPartyServicesModule.notification);
  gh.lazySingleton<_i14.LocalStorage>(() => thirdPartyServicesModule.box);
  gh.lazySingleton<_i15.LoginStandard>(
      () => thirdPartyServicesModule.flipperFire);
  gh.lazySingleton<_i16.NavigationService>(() => thirdPartyServicesModule.nav);
  gh.lazySingleton<_i17.PdfApi>(() => thirdPartyServicesModule.pdfApi);
  gh.lazySingleton<_i18.PdfInvoiceApi>(
      () => thirdPartyServicesModule.pdfInvoice);
  gh.lazySingleton<_i19.Printer>(() => thirdPartyServicesModule.printService);
  gh.lazySingleton<_i20.ProductService>(
      () => thirdPartyServicesModule.productService);
  gh.lazySingleton<_i21.Remote>(() => thirdPartyServicesModule.remote);
  gh.lazySingleton<_i22.ReportService>(() => thirdPartyServicesModule.report);
  gh.lazySingleton<_i23.Review>(() => thirdPartyServicesModule.review);
  gh.lazySingleton<_i24.SettingsService>(
      () => thirdPartyServicesModule.settings);
  gh.lazySingleton<_i25.Shareble>(() => thirdPartyServicesModule.share);
  gh.lazySingleton<_i26.UploadT>(() => thirdPartyServicesModule.upload);
  return get;
}

class _$ThirdPartyServicesModule extends _i27.ThirdPartyServicesModule {
  @override
  _i5.AppService get appService => _i5.AppService();
  @override
  _i10.ForceDataEntryService get forcedataEntry => _i10.ForceDataEntryService();
  @override
  _i12.KeyPadService get keypadService => _i12.KeyPadService();
  @override
  _i16.NavigationService get nav => _i16.NavigationService();
  @override
  _i17.PdfApi get pdfApi => _i17.PdfApi();
  @override
  _i18.PdfInvoiceApi get pdfInvoice => _i18.PdfInvoiceApi();
  @override
  _i20.ProductService get productService => _i20.ProductService();
  @override
  _i22.ReportService get report => _i22.ReportService();
  @override
  _i24.SettingsService get settings => _i24.SettingsService();
}
