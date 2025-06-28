import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:get_it/get_it.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/sync/interfaces/database_sync_interface.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';

import 'TestApp.dart';

class MockPathProviderPlatform extends PathProviderPlatform with Mock {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return './test/temp'; // Return a dummy path for testing
  }
}

// Mock classes for dependencies
class MockLocalStorage implements LocalStorage {
  @override
  String? customerTin() => '123456789';

  @override
  int? getBranchId() => 1;

  @override
  String defaultCurrency() => 'RWF';

  @override
  bool isOrdering() => false;

  @override
  bool readBool({required String key}) => false;

  @override
  Future<void> writeBool({required String key, required bool value}) async {}

  @override
  Future<void> writeString(
      {required String key, required String value}) async {}

  @override
  Future<void> writeDouble(
      {required String key, required double value}) async {}

  @override
  Future<bool> clear() async => true;

  @override
  bool? enableDebug() => false;

  @override
  bool pinLogin() => false;

  @override
  int? dbVersion() => 3;

  @override
  bool doneMigrateToLocal() => true;

  @override
  String encryptionKey() => "";

  @override
  bool forceUPSERT() => false;

  @override
  int? currentOrderId() => 12345;

  @override
  String? gdID() => "";

  @override
  String? getBearerToken() => "";

  @override
  int? getBusinessId() => 100;

  @override
  String getDefaultApp() => "";

  @override
  bool? getIsTokenRegistered() => true;

  @override
  bool getNeedAccountLinkWithPhone() => true;

  @override
  Future<String?> getServerUrl() async => "";

  @override
  int? getUserId() => 24300;

  @override
  String? getUserPhone() => "";

  @override
  bool hasSignedInForAutoBackup() => true;

  @override
  bool isAnonymous() => false;

  @override
  bool isAutoBackupEnabled() => true;

  @override
  bool isAutoPrintEnabled() => false;

  @override
  bool isProformaMode() => false;

  @override
  bool isTrainingMode() => true;

  @override
  String? paginationCreatedAt() => "";

  @override
  int? paginationId() => 67890;

  @override
  int? readInt({required String key}) => 42;

  @override
  String? readString({required String key}) => "";

  @override
  Future<bool> remove({required String key}) async => true;

  @override
  String? whatsAppToken() => "";

  @override
  Future<bool> authComplete() async => true;

  @override
  String uid() => "";

  @override
  Future<String> bhfId() async => "";

  @override
  int tin() => 1234567890;

  @override
  String? currentSaleCustomerPhoneNumber() => "";

  @override
  String? getRefundReason() => "";

  @override
  String? mrc() => "";

  @override
  bool? isPosDefault() => true;

  @override
  bool? isOrdersDefault() => false;

  @override
  int? itemPerPage() => 20;

  @override
  String? couponCode() => "";

  @override
  double? discountRate() => 1.0;

  @override
  String? paymentType() => "";

  @override
  String? yegoboxLoggedInUserPermission() => "";

  @override
  bool doneDownloadingAsset() => false;

  @override
  String? customerName() => "";

  @override
  bool? stopTaxService() => false;

  @override
  bool? switchToCloudSync() => true;

  @override
  bool? useInHouseSyncGateway() => true;

  @override
  String customPhoneNumberForPayment() => "";

  @override
  String? purchaseCode() => "";

  @override
  bool A4() => false;

  @override
  int? numberOfPayments() => 1;

  @override
  bool exportAsPdf() => false;

  @override
  String transactionId() => "";

  @override
  int? getBranchServerId() => 1;

  @override
  int? getBusinessServerId() => 1;

  @override
  bool transactionInProgress() => false;

  @override
  String stockInOutType() => "";

  @override
  String getDatabaseFilename() => "";

  @override
  Future<void> setDatabaseFilename(String filename) async {}

  @override
  String getQueueFilename() => "";

  @override
  Future<void> setQueueFilename(String filename) async {}

  @override
  bool getForceLogout() => false;

  @override
  Future<void> setForceLogout(bool value) async {}

  @override
  String? branchIdString() => "";

  @override
  String paymentMethodCode(String paymentMethod) => "";

  @override
  String pmtTyCd() => "";

  @override
  double? getCashReceived() => 0.0;

  @override
  String? getReceiptFileName() => "";

  @override
  bool vatEnabled() => false;

  @override
  Future<void> writeInt({required String key, required int value}) async {}

  @override
  bool lockPatching() => false;
}

class MockKeyPadService implements KeyPadService {
  @override
  void addListener(listener) {}

  @override
  void removeListener(listener) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockDatabaseSyncInterface implements DatabaseSyncInterface {
  @override
  Stream<ITransaction> pendingTransaction({
    int? branchId,
    required String transactionType,
    required bool isExpense,
    bool forceRealData = true,
  }) =>
      Stream.value(ITransaction(
        id: 'testTransactionId',
        branchId: 1,
        transactionType: 'Sale',
        createdAt: DateTime.now().toUtc(),
        status: 'PENDING',
        paymentType: 'cash',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now().toUtc(),
        isIncome: false,
        isExpense: false,
      ));

  @override
  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    bool includePending = false,
    DateTime? startDate,
    DateTime? endDate,
    required bool removeAdjustmentTransactions,
    bool forceRealData = true,
  }) =>
      Stream.value([]);

  // Implement all other abstract methods from DatabaseSyncInterface if they are called in the tested code
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockRepository extends Mock implements Repository {
  @override
  Future<void> initialize() async {
    // Do nothing or mock specific behavior if needed
  }
}

void main() {
  group('QuickSellingView Tests', () {
    late GlobalKey<FormState> formKey;
    late TextEditingController discountController;
    late TextEditingController deliveryNoteCotroller;
    late TextEditingController customerNameController;
    late TextEditingController receivedAmountController;
    late TextEditingController customerPhoneNumberController;
    late TextEditingController paymentTypeController;

    late MockLocalStorage mockLocalStorage;
    late MockDatabaseSyncInterface mockDatabaseSyncInterface;
    late MockKeyPadService mockKeyPadService;

    setUpAll(() async {
      await initializeDependenciesForTest();
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
              const MethodChannel('plugins.flutter.io/firebase_core'),
              (MethodCall methodCall) async {
        return null;
      });
      mockLocalStorage = MockLocalStorage();
      mockDatabaseSyncInterface = MockDatabaseSyncInterface();
      mockKeyPadService = MockKeyPadService();
      PathProviderPlatform.instance = MockPathProviderPlatform();
      SharedPreferences.setMockInitialValues({});
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      loc.setupLocator(stackedRouter: stackedRouter);
      setupDialogUi();
      setupBottomSheetUi();
      GetIt.I.registerSingleton<Repository>(MockRepository());
      GetIt.I.registerSingleton<LocalStorage>(mockLocalStorage);
      GetIt.I
          .registerSingleton<DatabaseSyncInterface>(mockDatabaseSyncInterface);
      GetIt.I.registerSingleton<KeyPadService>(mockKeyPadService);
    });

    setUp(() {
      // Reset GetIt registrations before each test
      GetIt.I.reset();

      formKey = GlobalKey<FormState>();
      discountController = TextEditingController();
      receivedAmountController = TextEditingController();
      customerNameController = TextEditingController();
      customerPhoneNumberController = TextEditingController();
      paymentTypeController = TextEditingController();
      deliveryNoteCotroller = TextEditingController();
    });

    tearDown(() {
      // Clean up controllers
      discountController.dispose();
      deliveryNoteCotroller.dispose();
      receivedAmountController.dispose();
      customerNameController.dispose();
      customerPhoneNumberController.dispose();
      paymentTypeController.dispose();
    });

    testWidgets('QuickSellingView displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: QuickSellingView(
            deliveryNoteCotroller: deliveryNoteCotroller,
            formKey: formKey,
            customerNameController: customerNameController,
            discountController: discountController,
            receivedAmountController: receivedAmountController,
            customerPhoneNumberController: customerPhoneNumberController,
            paymentTypeController: paymentTypeController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure that the initial values of the text fields are shown
      expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                widget.decoration?.labelText == 'Received Amount',
          ),
          findsOneWidget);
      expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                widget.decoration?.labelText == 'Customer Phone number',
          ),
          findsOneWidget);
    });

    testWidgets('QuickSellingView validates form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: QuickSellingView(
            deliveryNoteCotroller: deliveryNoteCotroller,
            formKey: formKey,
            customerNameController: customerNameController,
            discountController: discountController,
            receivedAmountController: receivedAmountController,
            customerPhoneNumberController: customerPhoneNumberController,
            paymentTypeController: paymentTypeController,
          ),
        ),
      );

      // Set an invalid phone number to trigger format validation
      customerPhoneNumberController.text = '123';
      receivedAmountController.text = ''; // Set to empty to trigger validation

      // Trigger form validation
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      // Verify error messages for invalid inputs
      expect(find.text('Please enter received amount'), findsOneWidget);
      expect(
          find.text(
              'Please enter a valid 9-digit phone number without a leading zero'),
          findsOneWidget);
    });

    // Additional tests for user interactions and state updates can be added here
  });
}
