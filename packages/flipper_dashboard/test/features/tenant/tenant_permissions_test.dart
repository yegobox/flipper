import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_dashboard/features/tenant/mixins/tenant_permissions_mixin.dart';
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
  });
}
