import 'dart:convert';

import 'package:flipper_ai_feature/src/services/local_flo_service.dart';
import 'package:flipper_models/providers/local_inference_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ready, RAG-less engine that records the prompt it was given.
class _EchoEngine implements LocalInferenceEngine {
  String? lastPrompt;

  @override
  bool get isSupported => true;

  @override
  bool get isReady => true;

  @override
  bool get supportsRag => false;

  @override
  Stream<String> generate(String prompt,
      {double? temperature, int? maxTokens}) async* {
    lastPrompt = prompt;
    yield 'Sold RWF 4200.';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('on-device prompts carry the shared sales context', () async {
    final engine = _EchoEngine();
    LocalInferenceRegistry.register(engine);

    final events = await const LocalFloService().streamChat(
      branchId: 'b1',
      message: 'How much today?',
      currency: 'RWF',
      deviceSales: {
        'period_label': 'today',
        'transaction_count': 2,
        'total_revenue': 4200,
        'top_items': [
          {'name': 'Milk', 'qty': 3, 'revenue': 4200},
        ],
      },
    ).toList();

    expect(engine.lastPrompt, contains('Sales for today (from this device):'));
    expect(engine.lastPrompt, contains('- Milk — 3 units, RWF 4200'));
    final blocks =
        jsonDecode(events.firstWhere((e) => e.event == 'blocks').data) as List;
    expect(blocks.single['html'], 'Sold RWF 4200.');
  });
}
