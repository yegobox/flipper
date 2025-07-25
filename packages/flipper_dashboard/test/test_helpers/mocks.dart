import 'package:flipper_services/local_notification_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class MockSyncStrategy extends Mock implements SyncStrategy {}

class MockDatabaseSync extends Mock implements DatabaseSyncInterface {}

class MockBox extends Mock implements LocalStorage {}

class MockTaxApi extends Mock implements TaxApi {}

class MockLNotification extends Mock implements LNotification {}
