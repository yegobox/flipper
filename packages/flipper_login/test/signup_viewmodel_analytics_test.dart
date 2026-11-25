import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_login/viewmodels/signup_viewmodel.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/business.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _Recorder implements ProductAnalytics {
  final tracked = <(String, Map<String, Object?>)>[];

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async {
    tracked.add((eventName, properties));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Box extends Fake implements LocalStorage {
  @override
  String? getUserPhone() => null;
}

class _Http extends Fake implements HttpClientInterface {}

/// The server: creates [business], or fails with [error].
class _Server extends Fake implements DatabaseSyncInterface {
  _Server({this.business, this.error});

  final Business? business;
  final Object? error;
  Map? sent;

  @override
  Future<Business?> signup({
    required Map business,
    required HttpClientInterface flipperHttpClient,
  }) async {
    sent = business;
    if (error != null) throw error!;
    return this.business;
  }
}

void main() {
  late _Recorder analytics;

  Future<void> register(_Server server) async {
    await getIt.reset();
    getIt.registerSingleton<LocalStorage>(_Box());
    getIt.registerSingleton<HttpClientInterface>(_Http());
    getIt.registerSingleton<SyncStrategy>(
      SyncStrategy(capella: server, cloudSync: server),
      instanceName: 'strategy',
    );
  }

  /// A filled-in form, as the signup bloc hands it over. No names, so the
  /// best-effort profile name write has nothing to do.
  SignupViewModel form() => SignupViewModel(analytics: analytics)
    ..country = 'Rwanda'
    ..tin = '999909695'
    ..businessType = BusinessType(id: '2', typeName: 'Shop');

  setUp(() => analytics = _Recorder());
  tearDown(() => getIt.reset());

  test(
      'a finished signup sends signup_completed once, grouped by its '
      'business and with no contact details', () async {
    await register(
      _Server(
        business: Business(id: 'biz-1', name: 'Kamali Shop', serverId: 1),
      ),
    );
    final model = form()..accountMode = AccountMode.personal;

    await model.signup();
    await Future<void>.delayed(Duration.zero);

    expect(analytics.tracked, hasLength(1));
    final (event, properties) = analytics.tracked.single;
    expect(event, AnalyticsEvents.signupCompleted);
    expect(properties, {
      'source': 'signup_view',
      'business_id': 'biz-1',
      r'$groups': {'business': 'biz-1'},
      'business_type_id': 2,
      'country': 'Rwanda',
      'local_mode': false,
      'account_mode': 'personal',
    });
  });

  test('a failed signup sends nothing', () async {
    await register(_Server(error: Exception('server down')));

    await expectLater(form().signup(), throwsException);
    await Future<void>.delayed(Duration.zero);

    expect(analytics.tracked, isEmpty);
  });

  test('no business back from the server sends nothing', () async {
    await register(_Server());

    await form().signup();
    await Future<void>.delayed(Duration.zero);

    expect(analytics.tracked, isEmpty);
  });
}
