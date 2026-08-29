/// Preference keys that describe "who is signed in and what were they doing".
///
/// Shared by [SharedPreferenceStorage.clearSessionKeys] (which drops them on
/// logout) and [migrateLegacyPreferencesFileIfNeeded] (which must never put
/// them back), so the two can never drift apart — a key present in one list but
/// not the other is exactly how a logged-out user gets signed back in.
library;

/// Millis timestamp of the last session clear (logout). Written by
/// `clearSessionKeys()`; read by every code path that merges an older copy of
/// the preferences back in, so a logout can outrank a stale snapshot.
const String kSessionClearedAtKey = 'sessionClearedAt';

/// Everything that belongs to "who is signed in and what were they doing".
///
/// Deliberately excludes device-level prefs that must survive logout:
/// `encryptionKey`, `databaseFilename`, `queueFilename`, `dbVersion`,
/// `thisDeviceId`, `getServerUrl`, `defaultLanguage`, cached MFA secrets
/// (offline authenticator login) and EBM/tax config (`tin`, `bhfId`, `mrc`,
/// `vatEnabled`), which are only re-hydrated conditionally after login.
const Set<String> kSessionPrefKeys = {
  // Identity
  'userId',
  'userIdString',
  'userPhone',
  'userName',
  'uid',
  'isAnonymous',
  'yegoboxLoggedInUserPermission',
  'commissionOnlySession',
  // Tokens / auth state
  'authComplete',
  'bearerToken',
  'token',
  'UToken',
  'otp',
  'getIsTokenRegistered',
  'pinLogin',
  'from_login',
  'freshSignup',
  // Business / branch selection
  'businessId',
  'currentBusinessId',
  'getBusinessServerId',
  'branchId',
  'branchIdString',
  'currentBranchId',
  'active_branch_id',
  'getBranchServerId',
  'branch_switched',
  'branch_switching',
  'last_branch_switch_timestamp',
  // Landing app / mode
  'defaultApp',
  'getDefaultApp',
  'isPosDefault',
  'isOrdersDefault',
  'isProformaMode',
  'isTrainingMode',
  // In-flight sale state
  'transactionId',
  'currentOrderId',
  'transactionInProgress',
  'transactionCompleting',
  'customerName',
  'customerTin',
  'currentSaleCustomerPhoneNumber',
  'pendingCustomerName',
  'pendingCustomerTin',
  'getCashReceived',
  'getRefundReason',
  'couponCode',
  'discountRate',
  'purchaseCode',
  // Branch-scoped artifacts
  'receiptLogoBase64',
  'lastZReportDate',
};
