import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/BusinessInfo.dart';

Map<String, dynamic> _info(Object? vatTyCd) => {
      'tin': '999909695',
      'taxprNm': 'YEGOBOX',
      'bhfId': '00',
      'bhfNm': 'Headquarter',
      'bhfOpenDt': '20210927',
      'prvncNm': 'SOUTH',
      'dstrtNm': 'KAMONYI',
      'sctrNm': 'NYARUBAKA',
      'locDesc': 'RRA',
      'hqYn': 'Y',
      'mgrNm': 'TESTING COMPANY 14 LTD',
      'mgrTelNo': '0788000000',
      'mgrEmail': 'ebm@example.com',
      'dvcId': '1036147990000001',
      'lastPchsInvcNo': 54,
      'vatTyCd': vatTyCd,
    };

void main() {
  test(
    'vatTyCd is read as text whether the EBM sends a number, a string or null',
    () {
      expect(BusinessInfo.fromJson(_info(1)).vatTyCd, '1');
      expect(BusinessInfo.fromJson(_info('2')).vatTyCd, '2');
      expect(BusinessInfo.fromJson(_info(null)).vatTyCd, isNull);
    },
  );
}
