import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_services/local_notification_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:supabase_models/brick/models/pin.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class MockSyncStrategy extends Mock implements SyncStrategy {}

class MockFlipperHttpClient extends Mock implements FlipperHttpClient {}

class MockDatabaseSync extends Mock implements DatabaseSyncInterface {
  @override
  Future<Map<String, dynamic>> handleLoginError(dynamic e, StackTrace s,
          {String? responseChannel}) =>
      Future.value({'errorMessage': ''});

  @override
  Future<void> saveLog(dynamic log) => Future.value();

  @override
  Future<IPin?> getPin(
          {required String pinString,
          required HttpClientInterface flipperHttpClient}) =>
      Future.value(null);

  @override
  Future<void> completeLogin(Pin thePin) => Future.value();

  
}

class MockBox extends Mock implements LocalStorage {}

class MockTaxApi extends Mock implements TaxApi {}

class MockLNotification extends Mock implements LNotification {}

class MockProxyService extends Mock implements DatabaseSyncInterface {
  final MockBox mockBox = MockBox();
  final MockSyncStrategy mockStrategy = MockSyncStrategy();

  @override
  MockBox get box => mockBox;
}

class MockRouterService extends Mock implements RouterService {}

class MockStartupViewModel extends Mock implements StartupViewModel {}

class MockUser extends Mock implements IUser {}
