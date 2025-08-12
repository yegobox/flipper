import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:flipper_services/local_notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:record/record.dart';
import 'package:supabase_models/brick/models/business.model.dart';
import 'package:supabase_models/brick/models/pin.model.dart';
import 'package:supabase_models/brick/models/plans.model.dart';
import 'package:supabase_models/brick/models/retryable.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class MockRepository extends Mock implements Repository {}

class MockRetryable extends Mock implements Retryable {}

class FakeHttpClient extends Fake implements HttpClientInterface {}

class MockPlan extends Mock implements Plan {}

class MockBusiness extends Mock implements Business {}

class MockSyncStrategy extends Mock implements SyncStrategy {}

class MockFlipperHttpClient extends Mock implements FlipperHttpClient {}

class GeminiBusinessAnalyticsMock extends Mock
    implements GeminiBusinessAnalytics {
  @override
  Future<String> build(int branchId, String userPrompt,
      {String? filePath, List<Content>? history}) async {
    return 'Mocked response';
  }
}

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

class MockBox extends Mock implements LocalStorage {
  @override
  String defaultCurrency() => 'USD';
}

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

class MockAudioRecorder extends Mock implements AudioRecorder {}

void setupPathProviderMock() {
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getTemporaryDirectory':
        return '/tmp';
      case 'getApplicationDocumentsDirectory':
        return '/tmp/documents';
      default:
        return null;
    }
  });
}
