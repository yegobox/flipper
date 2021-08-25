// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i19;

import 'abstractions/analytic.dart' as _i3;
import 'abstractions/api.dart' as _i5;
import 'abstractions/dynamic_link.dart' as _i9;
import 'abstractions/location.dart' as _i11;
import 'abstractions/platform.dart' as _i18;
import 'abstractions/printer.dart' as _i22;
import 'abstractions/remote.dart' as _i24;
import 'abstractions/share.dart' as _i27;
import 'abstractions/storage.dart' as _i17;
import 'abstractions/upload.dart' as _i28;
import 'analytic_service.dart' as _i4;
import 'app_service.dart' as _i6;
import 'cron_service.dart' as _i8;
import 'FirebaseCrashlyticService.dart' as _i7;
import 'firestore_api.dart' as _i10;
import 'force_data_service.dart' as _i12;
import 'http_api.dart' as _i13;
import 'in_app_review.dart' as _i25;
import 'keypad_service.dart' as _i14;
import 'language_service.dart' as _i16;
import 'local_notification_service.dart' as _i15;
import 'pdf_api.dart' as _i20;
import 'pdf_invoice_api.dart' as _i21;
import 'product_service.dart' as _i23;
import 'setting_service.dart' as _i26;
import 'third_party_services_module.dart'
    as _i29; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.Analytic>(() => thirdPartyServicesModule.appAnalytic);
  gh.lazySingleton<_i4.AnalyticService>(
      () => thirdPartyServicesModule.analytic);
  gh.lazySingleton<_i5.Api<dynamic>>(() => thirdPartyServicesModule.apiService);
  gh.lazySingleton<_i6.AppService>(() => thirdPartyServicesModule.appService);
  gh.lazySingleton<_i7.Crash>(() => thirdPartyServicesModule.crash);
  gh.lazySingleton<_i8.CronService>(() => thirdPartyServicesModule.cron);
  gh.lazySingleton<_i9.DynamicLink>(() => thirdPartyServicesModule.dynamicLink);
  gh.lazySingleton<_i10.Firestore>(() => thirdPartyServicesModule.firestore);
  gh.lazySingleton<_i11.FlipperLocation>(
      () => thirdPartyServicesModule.location);
  gh.lazySingleton<_i12.ForceDataEntryService>(
      () => thirdPartyServicesModule.forcedataEntry);
  gh.lazySingleton<_i13.HttpApi<dynamic>>(() => _i13.HttpApi<dynamic>());
  gh.lazySingleton<_i14.KeyPadService>(
      () => thirdPartyServicesModule.keypadService);
  gh.lazySingleton<_i15.LNotification>(
      () => thirdPartyServicesModule.notification);
  gh.lazySingleton<_i16.LanguageService>(
      () => thirdPartyServicesModule.languageService);
  gh.lazySingleton<_i17.LocalStorage>(() => thirdPartyServicesModule.box);
  gh.lazySingleton<_i18.LoginStandard>(
      () => thirdPartyServicesModule.flipperFire);
  gh.lazySingleton<_i19.NavigationService>(() => thirdPartyServicesModule.nav);
  gh.lazySingleton<_i20.PdfApi>(() => thirdPartyServicesModule.pdfApi);
  gh.lazySingleton<_i21.PdfInvoiceApi>(
      () => thirdPartyServicesModule.pdfInvoice);
  gh.lazySingleton<_i22.Printer>(() => thirdPartyServicesModule.printService);
  gh.lazySingleton<_i23.ProductService>(
      () => thirdPartyServicesModule.productService);
  gh.lazySingleton<_i24.Remote>(() => thirdPartyServicesModule.remote);
  gh.lazySingleton<_i25.Review>(() => thirdPartyServicesModule.review);
  gh.lazySingleton<_i26.SettingsService>(
      () => thirdPartyServicesModule.settings);
  gh.lazySingleton<_i27.Shareble>(() => thirdPartyServicesModule.share);
  gh.lazySingleton<_i28.UploadT>(() => thirdPartyServicesModule.upload);
  return get;
}

class _$ThirdPartyServicesModule extends _i29.ThirdPartyServicesModule {
  @override
  _i4.AnalyticService get analytic => _i4.AnalyticService();
  @override
  _i6.AppService get appService => _i6.AppService();
  @override
  _i8.CronService get cron => _i8.CronService();
  @override
  _i12.ForceDataEntryService get forcedataEntry => _i12.ForceDataEntryService();
  @override
  _i14.KeyPadService get keypadService => _i14.KeyPadService();
  @override
  _i16.LanguageService get languageService => _i16.LanguageService();
  @override
  _i19.NavigationService get nav => _i19.NavigationService();
  @override
  _i20.PdfApi get pdfApi => _i20.PdfApi();
  @override
  _i21.PdfInvoiceApi get pdfInvoice => _i21.PdfInvoiceApi();
  @override
  _i23.ProductService get productService => _i23.ProductService();
  @override
  _i26.SettingsService get settings => _i26.SettingsService();
}
