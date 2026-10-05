import 'package:flipper_services/customer_display/customer_display_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomerDisplayProtocol frames', () {
    test('init and clear', () {
      expect(CustomerDisplayProtocol.init(), [0x1B, 0x40]);
      expect(CustomerDisplayProtocol.clear(), [0x0C]);
    });

    test('lamps are ESC s followed by an ASCII digit', () {
      expect(CustomerDisplayProtocol.lamp(CustomerDisplayLamp.off), [
        0x1B,
        0x73,
        0x30,
      ]);
      expect(CustomerDisplayProtocol.lamp(CustomerDisplayLamp.total), [
        0x1B,
        0x73,
        0x32,
      ]);
      expect(CustomerDisplayProtocol.lamp(CustomerDisplayLamp.change), [
        0x1B,
        0x73,
        0x34,
      ]);
    });

    test('show is ESC Q A, the digits, CR', () {
      expect(CustomerDisplayProtocol.show('12500'), [
        0x1B, 0x51, 0x41, //
        0x31, 0x32, 0x35, 0x30, 0x30,
        0x0D,
      ]);
    });

    test('show drops characters a 7-segment display cannot draw', () {
      expect(
        CustomerDisplayProtocol.show('RWF 1,250'),
        CustomerDisplayProtocol.show('1250'),
      );
    });

    test('frame is the lamp then the amount', () {
      expect(CustomerDisplayProtocol.frame(1500, CustomerDisplayLamp.total), [
        ...CustomerDisplayProtocol.lamp(CustomerDisplayLamp.total),
        ...CustomerDisplayProtocol.show('1500'),
      ]);
    });
  });

  group('CustomerDisplayProtocol.formatAmount', () {
    test('whole amounts (RWF) have no decimals', () {
      expect(CustomerDisplayProtocol.formatAmount(12500), '12500');
      expect(CustomerDisplayProtocol.formatAmount(12500.0), '12500');
    });

    test('fractional amounts keep two decimals', () {
      expect(CustomerDisplayProtocol.formatAmount(12.5), '12.50');
    });

    test('cents are dropped before digits when it does not fit', () {
      expect(CustomerDisplayProtocol.formatAmount(1234567.25), '1234567');
    });

    test('an amount too large shows all nines, never a truncated number', () {
      expect(CustomerDisplayProtocol.formatAmount(123456789), '99999999');
    });

    test('negative amounts keep their sign within eight digits', () {
      expect(CustomerDisplayProtocol.formatAmount(-500), '-500');
      expect(CustomerDisplayProtocol.formatAmount(-123456789), '-9999999');
    });
  });
}
