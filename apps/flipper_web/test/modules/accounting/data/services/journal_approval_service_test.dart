import 'dart:convert';

import 'package:flipper_web/modules/accounting/data/services/journal_approval_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('JournalApprovalService', () {
    // Entries created before entry ids were slugified embed the human
    // reference, so the id carries a space and a '·'.
    const legacyId = 'je_biz-1_Auto · JE-9536_1758012345678';

    test('percent-encodes the entry id in the approve path', () async {
      late Uri seen;
      final client = MockClient((request) async {
        seen = request.url;
        return http.Response(
          jsonEncode({'posted': true, 'entryId': legacyId, 'status': 'posted'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final result = await JournalApprovalService(
        client: client,
        baseUrl: 'http://localhost:8084',
      ).approve(entryId: legacyId, businessId: 'biz-1');

      expect(seen.toString(), isNot(contains(' ')));
      expect(seen.pathSegments.last, 'approve');
      expect(seen.pathSegments[seen.pathSegments.length - 2], legacyId);
      expect(result.posted, isTrue);
    });

    test('surfaces the server error message', () async {
      final service = JournalApprovalService(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'error': 'invalid document id'}),
            500,
            headers: {'content-type': 'application/json'},
          ),
        ),
        baseUrl: 'http://localhost:8084',
      );

      expect(
        () => service.approve(entryId: legacyId),
        throwsA(
          isA<JournalApprovalException>()
              .having((e) => e.message, 'message', 'invalid document id')
              .having((e) => e.isOffline, 'isOffline', isFalse),
        ),
      );
    });
  });
}
