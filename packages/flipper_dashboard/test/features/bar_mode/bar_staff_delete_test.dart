import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

void main() {
  group('barStaffDeleteAllowed', () {
    test('allows deleting another staff member', () {
      expect(
        barStaffDeleteAllowed(
          target: Tenant(id: 't2', userId: 'u2', type: 'Agent'),
          currentUserId: 'u1',
        ),
        isTrue,
      );
    });

    test('blocks self-delete', () {
      expect(
        barStaffDeleteAllowed(
          target: Tenant(id: 't1', userId: 'u1', type: 'Agent'),
          currentUserId: 'u1',
        ),
        isFalse,
      );
    });

    test('blocks deleting admin-role rows', () {
      expect(
        barStaffDeleteAllowed(
          target: Tenant(id: 't2', userId: 'u2', type: 'Admin'),
          currentUserId: 'u1',
        ),
        isFalse,
      );
    });
  });

  group('barStaffRowMatchesDeleted', () {
    test('matches by tenant id', () {
      final row = Tenant(id: 'tenant-a', userId: 'user-a');
      final deleted = Tenant(id: 'tenant-a', userId: 'user-b');
      expect(barStaffRowMatchesDeleted(row, deleted), isTrue);
    });

    test('matches by user id when tenant ids differ', () {
      final row = Tenant(id: 'synthetic', userId: 'user-a');
      final deleted = Tenant(id: 'real-uuid', userId: 'user-a');
      expect(barStaffRowMatchesDeleted(row, deleted), isTrue);
    });

    test('does not match unrelated rows', () {
      final row = Tenant(id: 't1', userId: 'u1');
      final deleted = Tenant(id: 't2', userId: 'u2');
      expect(barStaffRowMatchesDeleted(row, deleted), isFalse);
    });
  });

  testWidgets('BarDeleteButton shows spinner while loading', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BarDeleteButton(onPressed: null, isLoading: true),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });

  testWidgets('BarDeleteButton shows trash icon when idle', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BarDeleteButton(onPressed: () {}, isLoading: false),
        ),
      ),
    );

    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
