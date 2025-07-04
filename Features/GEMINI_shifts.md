# Feature: Multi-User Shifts

This document outlines the plan to introduce a multi-user shift management system into the Flipper application. This feature will allow different users to operate the point of sale on the same device while tracking their activities independently.

## 1. Goal

The primary goal of the Shifts feature is to enhance accountability and provide better operational insights. By tracking sales, cash flow, and other activities per user shift, business owners can:
*   Know who was responsible for the cash drawer at any given time.
*   Track user performance.
*   Identify cash discrepancies (surpluses or shortages) for each shift.
*   Improve security by ensuring users log their actions under their own credentials.

## 2. Core Concepts

*   **Shift:** A single, continuous period of work for a user on a specific device. A shift starts when a user logs in and ends when they log out or "close out".
*   **Cash Drawer Management:** Tracking the flow of cash from the start to the end of a shift.
    *   **Opening Float:** The initial amount of cash in the drawer when a shift begins.
    *   **Closing Balance:** The final cash amount at the end of a shift.
    *   **Cash Surplus/Shortage:** The difference between the expected cash (from transactions) and the actual closing balance.

## 3. Data Models

A new model will be created in a suitable package (e.g., `packages/flipper_models`).

### **Shift Model**

```dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';

enum ShiftStatus { Open, Closed }

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'shifts'),
)
class Shift extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true, primaryKey: true)
  @Sqlite(unique: true, primaryKey: true)
  final String id;

  @Sqlite(index: true)
  final int businessId;

  @Sqlite(index: true)
  final int userId;

  final DateTime startAt;
  final DateTime? endAt;

  // Opening cash float
  final num openingBalance;

  // Closing cash amount
  final num? closingBalance;

  @Sqlite(columnType: Column.String)
  final ShiftStatus status;

  // Expected cash from sales, minus refunds etc.
  final num? cashSales;
  
  // Total cash expected at the end of the shift
  final num? expectedCash;

  // Difference between closingBalance and expectedCash
  final num? cashDifference;


  Shift({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.startAt,
    this.endAt,
    required this.openingBalance,
    this.closingBalance,
    this.status = ShiftStatus.Open,
    this.cashSales,
    this.expectedCash,
    this.cashDifference,
  });
}
```

### **Transaction Model Update**

The existing `Transaction` model will be updated to include a `shiftId`.

```dart
// In existing Transaction model
// ...
@Sqlite(index: true)
final String? shiftId;
// ...
```

## 4. Phased Implementation Plan

### Phase 1: Core Backend and Data Structures (Completed)

*   **1.1. Implement `Shift` Model:** Created the `Shift` model.
*   **1.2. Define Shift Service Interface and Mixins:**
    *   **Interface (`ShiftApi`):** Defined `ShiftApi` and extended `DatabaseSyncInterface`.
    *   **Implementation Mixins:** `ShiftMixin` implemented for `CoreSync`.
*   **1.3. Update `Transaction` Model:** Added the `shiftId` field to the `Transaction` model.
*   **1.4. Update Transaction Integration:** `ITransaction` updated with `shiftId`, and `KeyPadService` integrates `shiftId` with transactions.

### Phase 2: User Workflow and UI (Completed)

*   **2.1. Login Flow and Shift Start:** Implemented logic to check for active shifts and present "Start Shift" dialog if none exists.
*   **2.2. Implement "Close Shift" Screen:** Created and integrated the "Close Shift" dialog for ending shifts, including summary display and cash reconciliation.
*   **2.3. Active User Display:** (Not directly implemented by me, but part of the overall UI plan)
*   **2.4. Switch User / Log Out Shift Functionality:** Implemented "Log Out Shift" in `EnhancedSideMenu` with dialog for closing balance and navigation to login.

### Phase 3: Reporting and Management (Partially Completed)

*   **3.1. Shift History Screen (Implemented):**
    *   Developed a new screen to list all shifts (both open and closed).
    *   Visibility is restricted to admin users using `eligibleToSeeIfYouAre`.
    *   Each list item shows key details (User, Start/End Time, Cash Difference).
*   **3.2. Shift Details View:**
    *   Tapping on a shift from the history list will navigate to a details screen.
    *   This screen will show the full shift summary (as seen in the "Close Shift" flow).
    *   It will also provide a list of all transactions recorded during that shift.
*   **3.3. Update Existing Reports:**
    *   Modify existing financial and sales reports to allow filtering by shift.

### Phase 5: Testing and Verification (Pending)

*   **Unit Tests:**
    *   For `ShiftApi` implementations (`ShiftMixin`, `CapellaShiftMixin`): Verify correct creation, retrieval, and updating of `Shift` objects.
    *   For `ShiftService` logic (e.g., balance calculations in `endShift`).
*   **Integration Tests:**
    *   Verify that new `ITransaction` records are correctly associated with the active `shiftId`.
    *   Test the full flow of starting a shift, making transactions, and ending a shift to ensure data consistency and accurate cash difference calculation.
*   **UI/UX Testing:**
    *   Ensure the user flow for starting, ending, and switching shifts is intuitive and error-free.
    *   Verify that the active user display updates correctly.
    *   Test the Shift History and Shift Details screens for accurate data presentation and filtering.

### Phase 6: Future Enhancements (Pending)

*   **Budgeting**.
*   **Bank Reconciliation**.
*   **Multi-currency Support**.
*   **Tax Preparation Reports**.
