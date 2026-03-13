# Investigation: Missing Credit Transactions in Tickets List

## Findings

1.  **Case-Sensitivity Mismatch**: 
    - In `flipper_services/lib/constants.dart`, the standard list of payment types uses `"CREDIT"` (all caps).
    - In `flipper_dashboard/lib/widgets/payment_methods_card.dart`, the dropdown uses these all-caps values from `constants.dart`.
    - In `flipper_dashboard/lib/mixins/previewCart.dart`, the method `markTransactionAsCompleted` specifically checks for `"Credit"` (Title Case):
      ```dart
      final totalCredit = paymentMethods
          .where((p) => p.method == "Credit")
          .fold<double>(0, (sum, p) => sum + p.amount);
      ```
    - Because of this mismatch, when a user selects "CREDIT", `totalCredit` is calculated as `0`.

2.  **Impact on Transaction Status**:
    - If `totalCredit` is `0` and the transaction is fully paid (which it often is if the user enters the full amount in the "Credit" field), `shouldBeLoan` becomes `false`.
    - This results in the transaction status being set to `COMPLETE` instead of `PARKED`.
    - Parked transactions (loans) are what show up in the "Tickets" list for later resumption. `COMPLETE` transactions are hidden from this view.

3.  **Inconsistent Usage**:
    - `payments.dart` also uses `"Credit"` (Title Case), while most of the newer UI (like `PaymentMethodsCard`) uses `"CREDIT"`.

## Root Cause
The root cause is the inconsistent casing of the "Credit" payment method string across different modules, specifically between the UI selection (`CREDIT`) and the transaction finalization logic (`Credit`).

## Proposed Solution
Standardize the "Credit" payment method string to use all-caps `"CREDIT"` across the codebase, or ensure all checks are case-insensitive. Given that `constants.dart` defines it in all caps, standardizing on `"CREDIT"` is the most robust approach.

## Implementation Plan

### 1. Standardize Payment Method Strings
- **Modified `flipper_dashboard/lib/mixins/previewCart.dart`**: [x]
    - Changed `"Credit"` to `"CREDIT"` in `markTransactionAsCompleted`.
- **Modified `flipper_dashboard/lib/payments.dart`**: [x]
    - Changed `"Credit"` to `"CREDIT"` in all hardcoded instances.

### 2. Verification
- Perform manual verification by completing a "Credit" transaction and checking the Tickets list.
- (Optional) Add a regression test in `preview_cart_test.dart` once the mixin is testable.

