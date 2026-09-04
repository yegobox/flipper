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

/// True when the signed-in user may build/edit a sale cart — add items, change
/// quantities, park, checkout, attach a customer, transfer stock.
///
/// Broader than [canCollectPosPaymentProvider] (which only governs *tendering*
/// payment): a plain cashier with Sales write builds carts and parks them for a
/// till role even when they cannot collect. Defined as write/admin on Sales OR
/// Add Product, OR the collector population. Read-only staff (read grants only)
/// get a browse-only catalog and this returns false.
final canSellProvider = Provider<bool>((ref) {
  final userId = ProxyService.box.getUserId() ?? '';
  if (userId.isEmpty) return false;
  final canSellCatalog = ref.watch(
    featureAccessProvider(userId: userId, featureName: AppFeature.Sales),
  );
  final canManageCatalog = ref.watch(
    featureAccessProvider(userId: userId, featureName: AppFeature.AddProduct),
  );
  return canSellCatalog ||
      canManageCatalog ||
      ref.watch(canCollectPosPaymentProvider);
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
    this.seedItems = const <TransactionItem>[],
    this.ticketSnapshot,
    this.recovered = false,
  });

  final String transactionId;
  final String displayRef;
  final String creatorName;

  /// Wall-clock when the ticket was sent to the till (park `lastTouched`),
  /// captured **before** resume bumps `lastTouched`. Drives "sent N min ago".
  final DateTime createdAt;

  /// Branch the ticket lives in — used to scope the settling cart's line-item
  /// query to the exact branch. Falls back to the active branch when null.
  final String? branchId;
  final String? ticketName;
  final String? ticketNote;

  /// Line items pre-fetched at Collect time so the settling cart paints on the
  /// first frame instead of flashing empty while the cold Ditto item stream
  /// registers its observer and delivers its first snapshot.
  final List<TransactionItem> seedItems;

  /// Full ticket row captured at Collect/Resume so Pay/completion can bind to
  /// this sale before [transactionByIdProvider] resolves (avoids completing
  /// the collector's empty pending cart).
  final ITransaction? ticketSnapshot;

  /// True when this session was rebuilt from the cart row itself
  /// ([recoverSettlingTillTicketFromResumedCart]) instead of being handed over
  /// by Collect/Resume.
  ///
  /// Collect forces `ticketSnapshot.status = PENDING` at hand-off, so re-park
  /// paths can trust it; a recovered snapshot is only as fresh as the pending
  /// row it came from, so **re-read the row before parking on it** — parking a
  /// sale that has since completed would resurrect it as a ticket.
  final bool recovered;
}

/// Short human reference for a ticket — `reference` when set, else a truncated
/// transaction id. Mirrors what the tickets list and the settling banner show.
String settlingTicketDisplayRef(ITransaction ticket) {
  final reference = ticket.reference?.trim();
  if (reference != null && reference.isNotEmpty) return reference.toUpperCase();
  final id = ticket.id;
  if (id.length >= 6) return id.substring(0, 6).toUpperCase();
  return id.toUpperCase();
}

/// Rebuilds a settling session from a resumed till ticket still sitting in the
/// cart.
///
/// [settlingTillTicketProvider] is in-memory only, so a reload / restart / route
/// rebuild between Collect and Pay dropped it while the ticket stayed PENDING on
/// screen — the checkout then rendered the ticket's lines with no settling
/// banner and no way back to a new sale. Resume keeps `ticketName` (only park
/// writes it, and a freshly minted pending cart never has one), so a PENDING row
/// carrying one is a resumed ticket and can seed a session again.
///
/// `createdAt` is the park stamp ([parkSaleTicketFast] writes it, resume leaves
/// it alone), so the banner's elapsed time stays honest.
SettlingTillTicket? recoverSettlingTillTicketFromResumedCart(
  ITransaction? ticket,
) {
  if (ticket == null || ticket.id.isEmpty) return null;
  if ((ticket.status ?? '').toLowerCase() != PENDING.toLowerCase()) return null;
  final ticketName = ticket.ticketName?.trim() ?? '';
  if (ticketName.isEmpty) return null;

  return SettlingTillTicket(
    transactionId: ticket.id,
    displayRef: settlingTicketDisplayRef(ticket),
    // The sender is not recoverable from the row — resume overwrites `agentId`
    // with the collector — so fall back to the same generic name Collect uses.
    creatorName: 'Staff',
    createdAt: ticket.createdAt ?? ticket.lastTouched ?? DateTime.now(),
    branchId: ticket.branchId,
    ticketName: ticketName,
    ticketNote: ticket.note,
    ticketSnapshot: ticket,
    recovered: true,
  );
}

/// The cart row a settling session may be rebuilt from, or null.
///
/// Pure so the precedence and the suppression guard can be tested without Ditto.
/// Mirrors [posCartPendingTransactionIdProvider]: a pin wins outright (mobile
/// checkout and ticket resume pin their sale, and while a pin is held the cache
/// / stream may still be pointing at the operator's other cart), otherwise the
/// cache is preferred over the stream. [pinnedRow] is the pinned id looked up
/// directly — only needed when neither [cached] nor [streamed] holds it.
///
/// A suppressed id yields null: a just-completed or just-re-parked ticket is
/// suppressed *before* its row leaves PENDING, and rebuilding a session from it
/// would re-show the banner over the next sale, or re-park a completed one.
ITransaction? settlingRecoveryCartRow({
  ITransaction? cached,
  ITransaction? streamed,
  ITransaction? pinnedRow,
  String? pinnedId,
  String? suppressedId,
}) {
  if (pinnedId != null && pinnedId.isNotEmpty) {
    if (suppressedId == pinnedId) return null;
    for (final candidate in [cached, streamed, pinnedRow]) {
      if (candidate != null && candidate.id == pinnedId) return candidate;
    }
    return null;
  }

  final row = (cached != null && cached.id.isNotEmpty) ? cached : streamed;
  if (row == null || row.id.isEmpty) return null;
  if (suppressedId != null && suppressedId == row.id) return null;
  return row;
}

/// Non-null while a Manager/Admin is settling a queued till ticket in the cart.
final settlingTillTicketProvider =
    StateProvider<SettlingTillTicket?>((ref) => null);
