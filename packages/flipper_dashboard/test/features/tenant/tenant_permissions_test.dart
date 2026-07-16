import 'package:flipper_dashboard/features/tenant/mixins/tenant_operations_mixin.dart';
import 'package:flipper_dashboard/features/tenant/mixins/tenant_permissions_mixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TenantPermissionsMixin', () {
    late TextEditingController nameController;
    late TextEditingController phoneController;
    late GlobalKey<FormState> formKey;
    late Map<String, String> tenantAllowedFeatures;
    late Map<String, bool> activeFeatures;

    setUp(() {
      nameController = TextEditingController();
      phoneController = TextEditingController();
      formKey = GlobalKey<FormState>();
      tenantAllowedFeatures = {};
      activeFeatures = {};
    });

    testWidgets(
      'fillFormWithTenantDataStatic populates name and phone from tenant',
      (tester) async {
        final tenant = Tenant(
          id: '1',
          name: 'Test Tenant',
          phoneNumber: '1234567890',
          businessId: '1',
          nfcEnabled: false,
          isDefault: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(controller: nameController),
                    TextFormField(controller: phoneController),
                  ],
                ),
              ),
            ),
          ),
        );

        TenantPermissionsMixin.fillFormWithTenantDataStatic(
          tenant,
          [],
          (fn) => fn(), // Mock setState
          tenantAllowedFeatures,
          activeFeatures,
          'Agent',
          nameController,
          phoneController,
          formKey,
        );

        expect(
          nameController.text,
          'Test Tenant',
          reason: 'Name should be populated',
        );
        expect(
          phoneController.text,
          '1234567890',
          reason: 'Phone should be populated',
        );
      },
    );

    testWidgets('fillFormWithTenantDataStatic uses email if phone is null', (
      tester,
    ) async {
      final tenant = Tenant(
        id: '2',
        name: 'Email Tenant',
        phoneNumber: null,
        email: 'test@example.com',
        businessId: '1',
        nfcEnabled: false,
        isDefault: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(controller: nameController),
                  TextFormField(controller: phoneController),
                ],
              ),
            ),
          ),
        ),
      );

      TenantPermissionsMixin.fillFormWithTenantDataStatic(
        tenant,
        [],
        (fn) => fn(),
        tenantAllowedFeatures,
        activeFeatures,
        'Agent',
        nameController,
        phoneController,
        formKey,
      );

      expect(nameController.text, 'Email Tenant');
      expect(
        phoneController.text,
        'test@example.com',
        reason: 'Email should be used as fallback',
      );
    });

    test(
      'applyActiveToggle upgrades No Access to write when turning Active on',
      () {
        // Mirrors TenantManagement.initState pre-fill.
        for (final feature in features) {
          tenantAllowedFeatures[feature] = 'No Access';
          activeFeatures[feature] = false;
        }

        TenantPermissionsMixin.applyActiveToggle(
          AppFeature.Sales,
          true,
          tenantAllowedFeatures,
          activeFeatures,
        );

        expect(activeFeatures[AppFeature.Sales], isTrue);
        expect(tenantAllowedFeatures[AppFeature.Sales], 'write');
      },
    );

    test('applyAccessLevelChange enables Active for real levels', () {
      tenantAllowedFeatures[AppFeature.Sales] = 'No Access';
      activeFeatures[AppFeature.Sales] = false;

      TenantPermissionsMixin.applyAccessLevelChange(
        AppFeature.Sales,
        'admin',
        tenantAllowedFeatures,
        activeFeatures,
      );

      expect(tenantAllowedFeatures[AppFeature.Sales], 'admin');
      expect(activeFeatures[AppFeature.Sales], isTrue);
    });

    test('applyAccessLevelChange disables Active for No Access', () {
      tenantAllowedFeatures[AppFeature.Sales] = 'write';
      activeFeatures[AppFeature.Sales] = true;

      TenantPermissionsMixin.applyAccessLevelChange(
        AppFeature.Sales,
        'No Access',
        tenantAllowedFeatures,
        activeFeatures,
      );

      expect(tenantAllowedFeatures[AppFeature.Sales], 'No Access');
      expect(activeFeatures[AppFeature.Sales], isFalse);
    });
  });

  group('TenantOperationsMixin.buildAccessPermissionsPayload', () {
    test('create includes modules activated via Active toggle alone', () {
      final allowed = <String, String>{
        for (final f in features) f: 'No Access',
      };
      final active = <String, bool>{for (final f in features) f: false};

      // Simulate fixed UI: toggle Sales Active on → write + active.
      TenantPermissionsMixin.applyActiveToggle(
        AppFeature.Sales,
        true,
        allowed,
        active,
      );
      TenantPermissionsMixin.applyActiveToggle(
        AppFeature.Tickets,
        true,
        allowed,
        active,
      );

      final payload = TenantOperationsMixin.buildAccessPermissionsPayload(
        editMode: false,
        tenantAllowedFeatures: allowed,
        activeFeatures: active,
      );

      expect(payload, hasLength(2));
      expect(
        payload,
        containsAll([
          {
            'feature_name': AppFeature.Sales,
            'access_level': 'write',
            'status': 'active',
          },
          {
            'feature_name': AppFeature.Tickets,
            'access_level': 'write',
            'status': 'active',
          },
        ]),
      );
    });

    test(
      'create recovers Active-on + No Access (legacy pre-fill without UI sync)',
      () {
        final allowed = <String, String>{
          for (final f in features) f: 'No Access',
        };
        final active = <String, bool>{
          for (final f in features) f: false,
          AppFeature.Inventory: true, // toggled without upgrading level
        };

        final payload = TenantOperationsMixin.buildAccessPermissionsPayload(
          editMode: false,
          tenantAllowedFeatures: allowed,
          activeFeatures: active,
        );

        expect(payload, [
          {
            'feature_name': AppFeature.Inventory,
            'access_level': 'write',
            'status': 'active',
          },
        ]);
      },
    );

    test('edit sends only changed rows including deactivation', () {
      final baselineAllowed = <String, String>{
        for (final f in features) f: 'No Access',
        AppFeature.Sales: 'write',
      };
      final baselineActive = <String, bool>{
        for (final f in features) f: false,
        AppFeature.Sales: true,
      };
      final allowed = Map<String, String>.from(baselineAllowed)
        ..[AppFeature.Sales] = 'No Access'
        ..[AppFeature.Reports] = 'read';
      final active = Map<String, bool>.from(baselineActive)
        ..[AppFeature.Sales] = false
        ..[AppFeature.Reports] = true;

      final payload = TenantOperationsMixin.buildAccessPermissionsPayload(
        editMode: true,
        tenantAllowedFeatures: allowed,
        activeFeatures: active,
        permissionsBaseline: baselineAllowed,
        activeFeaturesBaseline: baselineActive,
      );

      expect(
        payload,
        containsAll([
          {
            'feature_name': AppFeature.Sales,
            'access_level': 'read',
            'status': 'inactive',
          },
          {
            'feature_name': AppFeature.Reports,
            'access_level': 'read',
            'status': 'active',
          },
        ]),
      );
      expect(payload, hasLength(2));
    });
  });
}
