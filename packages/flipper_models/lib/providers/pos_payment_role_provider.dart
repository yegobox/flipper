import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/pos_payment_role_tenant.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// True when the signed-in user may tender / complete POS sales.
///
/// Grants collection when:
/// - [Tenant.type] is Owner / Admin / Manager, **or**
/// - current user id matches the active business owner (`Business.userId`), **or**
/// - the user has an active Write/Admin grant on the [AppFeature.Tickets]
///   permission (lets an owner grant a plain Cashier till-collection rights via
///   the User Management permission matrix, without making them an Admin).
///
/// Fail-closed while all signals are unknown so staff cannot bypass the gate.
final canCollectPosPaymentProvider = Provider<bool>((ref) {
  final userId = ProxyService.box.getUserId() ?? '';
  if (userId.isEmpty) {
    talker.warning(
      'POS till role DENIED: empty userId (session box has no user)',
    );
    return false;
  }

  final tenantAsync = ref.watch(tenantProvider(userId));
  final tenant = tenantAsync.asData?.value;
  final businessOwnerAsync = ref.watch(_businessOwnerUserIdProvider);
  final businessOwnerUserId = businessOwnerAsync.asData?.value;

  final typeMatch = tenantCanCollectPosPayment(tenant);
  final isBusinessOwner = userOwnsBusinessForPosPayment(
    userId: userId,
    businessOwnerUserId: businessOwnerUserId,
  );
  final hasTicketsGrant = _hasActiveTillCollectGrant(
    ref.watch(userAccessesProvider(userId, featureName: AppFeature.Tickets))
        .asData
        ?.value,
  );
  final canCollect = typeMatch || isBusinessOwner || hasTicketsGrant;

  final tenantState = tenantAsync.hasError
      ? 'error:${tenantAsync.error}'
      : tenantAsync.isLoading
      ? 'loading'
      : tenantAsync.hasValue
      ? (tenant == null ? 'value:null' : 'value:found')
      : 'idle';

  final businessOwnerState = businessOwnerAsync.hasError
      ? 'error:${businessOwnerAsync.error}'
      : businessOwnerAsync.isLoading
      ? 'loading'
      : 'value:$businessOwnerUserId';

  talker.info(
    'POS till role decision: canCollect=$canCollect | '
    'userId=$userId | '
    'tenantAsync=$tenantState | '
    'tenantId=${tenant?.id} | '
    'tenantType=${tenant?.type} | '
    'tenantName=${tenant?.name} | '
    'typeMatch=$typeMatch | '
    'businessOwnerAsync=$businessOwnerState | '
    'isBusinessOwner=$isBusinessOwner | '
    'hasTicketsGrant=$hasTicketsGrant',
  );

  return canCollect;
});

/// True when [accesses] contains an active, non-expired Write/Admin grant on the
/// Tickets feature. Deliberately does NOT use [featureAccessProvider] — that
/// short-circuits to true in debug builds, which would make every user a
/// collector and break the cashier/till split during testing.
bool _hasActiveTillCollectGrant(List<Access>? accesses) {
  if (accesses == null || accesses.isEmpty) return false;
  final now = DateTime.now();
  return accesses.any((a) {
    final level = (a.accessLevel ?? '').toLowerCase();
    final isWriteOrAdmin = level == 'write' ||
        level == 'admin' ||
        level == 'read_write' ||
        level == 'readwrite';
    return a.featureName == AppFeature.Tickets &&
        isWriteOrAdmin &&
        a.status == 'active' &&
        (a.expiresAt == null || a.expiresAt!.isAfter(now));
  });
}

/// Active business owner user id (local Brick lookup; best-effort).
final _businessOwnerUserIdProvider = FutureProvider<String?>((ref) async {
  try {
    final business = await ProxyService.strategy.activeBusiness();
    return business?.userId?.trim();
  } catch (e, st) {
    talker.warning('POS till role: activeBusiness lookup failed: $e', st);
    return null;
  }
});

/// Metadata for a parked ticket a till role is collecting payment for.
class SettlingTillTicket {
  const SettlingTillTicket({
    required this.transactionId,
    required this.displayRef,
    required this.creatorName,
    required this.createdAt,
    this.branchId,
    this.ticketName,
    this.ticketNote,
  });

  final String transactionId;
  final String displayRef;
  final String creatorName;
  final DateTime createdAt;

  /// Branch the ticket lives in — used to scope the settling cart's line-item
  /// query to the exact branch. Falls back to the active branch when null.
  final String? branchId;
  final String? ticketName;
  final String? ticketNote;
}

/// Non-null while a Manager/Admin is settling a queued till ticket in the cart.
final settlingTillTicketProvider =
    StateProvider<SettlingTillTicket?>((ref) => null);
