import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Agent login modes', () {
    test('Tenant defaults allowBusinessLogin to false for new agents', () {
      final tenant = Tenant(name: 'Agent One', type: 'Agent');
      expect(tenant.allowBusinessLogin, isFalse);
    });

    test('AppFeature.Commission is defined and not in admin features list', () {
      expect(AppFeature.Commission, 'Commission');
      expect(features, isNot(contains(AppFeature.Commission)));
    });
  });

  test('agent branch name controller can mirror full name', () {
    final name = TextEditingController(text: 'Agent King');
    final branch = TextEditingController();
    name.addListener(() {
      branch.text = name.text.trim();
    });
    expect(branch.text, 'Agent King');
    name.dispose();
    branch.dispose();
  });
}
