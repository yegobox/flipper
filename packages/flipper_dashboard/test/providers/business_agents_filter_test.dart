import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('filters Agent tenants with user id', () {
    final tenants = [
      Tenant(name: 'Cashier', type: 'Cashier', userId: 'u1'),
      Tenant(name: 'Agent A', type: 'Agent', userId: 'u2'),
      Tenant(name: 'No uid', type: 'Agent'),
      Tenant(name: 'Agent B', type: 'Agent', userId: 'u3'),
    ];

    final agents = tenants
        .where(FlipperBaseModel.isAgentTenantForSale)
        .toList();
    expect(agents.length, 2);
    expect(agents[0].name, 'Agent A');
    expect(agents[1].name, 'Agent B');
  });
}
