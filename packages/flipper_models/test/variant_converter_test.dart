import 'dart:convert';

import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VariantConverter via RwApiResponse', () {
    test('parses RRA import itemList without branchId or name', () async {
      final jsonString = await rootBundle.loadString(
        'packages/flipper_models/jsons/import.json',
      );
      final response = RwApiResponse.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

      expect(response.data?.itemList, isNotNull);
      expect(response.data!.itemList!, hasLength(1));

      final item = response.data!.itemList!.first;
      expect(item.branchId, '');
      expect(item.name, 'MUVURA-002');
      expect(item.itemNm, 'MUVURA-002');
      expect(item.taskCd, '2276822');
    });
  });
}
