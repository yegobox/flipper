import 'package:flipper_models/helpers/pos_payment_role.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

export 'package:flipper_models/helpers/pos_payment_role.dart';

/// Whether [tenant] may collect POS payment via [Tenant.type] alone.
bool tenantCanCollectPosPayment(Tenant? tenant) {
  return tenantTypeCanCollectPosPayment(tenant?.type);
}

/// Whether [tenant] is a Cashier — the only role required to open a shift.
bool tenantIsCashier(Tenant? tenant) {
  return tenantTypeIsCashier(tenant?.type);
}

/// Full till-role decision used by POS (type **or** business ownership).
bool canCollectPosPaymentDecision({
  required String? userId,
  Tenant? tenant,
  String? businessOwnerUserId,
}) {
  if (tenantCanCollectPosPayment(tenant)) return true;
  return userOwnsBusinessForPosPayment(
    userId: userId,
    businessOwnerUserId: businessOwnerUserId,
  );
}
