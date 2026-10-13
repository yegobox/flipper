import 'dart:async';

import 'package:flipper_services/printers/printer_directory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:printing/printing.dart';

void main() {
  late int lookups;
  late Completer<List<Printer>> pending;

  setUp(() {
    debugResetPrinterDirectory();
    lookups = 0;
    pending = Completer<List<Printer>>();
    debugPrinterLister = () {
      lookups++;
      return pending.future;
    };
  });

  tearDown(debugResetPrinterDirectory);

  const receipt = Printer(url: 'POS-80', name: 'POS-80');

  test('concurrent callers share one OS lookup', () async {
    final first = listPrintersSafely();
    final second = listPrintersSafely(refresh: true);
    pending.complete(const [receipt]);

    expect(await first, [receipt]);
    expect(await second, [receipt]);
    expect(lookups, 1);
  });

  test('a finished lookup is reused until refresh is asked for', () async {
    pending.complete(const [receipt]);
    await listPrintersSafely();
    await listPrintersSafely();
    expect(lookups, 1);

    await listPrintersSafely(refresh: true);
    expect(lookups, 2);
  });

  test('a failed lookup is not cached', () async {
    pending.completeError(StateError('spooler down'));
    await expectLater(listPrintersSafely(), throwsStateError);

    pending = Completer<List<Printer>>()..complete(const [receipt]);
    expect(await listPrintersSafely(), [receipt]);
    expect(lookups, 2);
  });
}
