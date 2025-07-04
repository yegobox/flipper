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
  final double openingBalance;

  // Closing cash amount
  final double? closingBalance;

  @Sqlite(columnType: Column.String)
  final ShiftStatus status;

  // Expected cash from sales, minus refunds etc.
  final double? cashSales;
  
  // Total cash expected at the end of the shift
  final double? expectedCash;

  // Difference between closingBalance and expectedCash
  final double? cashDifference;


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

### Phase 1: Core Backend and Data Structures

*   **1.1. Implement `Shift` Model:** Create the `Shift` model as defined above.
*   **1.2. Define Shift Service Interface and Mixins:**
    *   **Interface (`ShiftApi`):** The shift management contract will be defined as a new abstract class `ShiftApi` within `packages/flipper_models/lib/DatabaseSyncInterface.dart`. The `DatabaseSyncInterface` will then extend this new `ShiftApi`.
        *   `Future<Shift> startShift({required int userId, required double openingBalance});`
        *   `Future<Shift> endShift({required String shiftId, required double closingBalance});`
        *   `Future<Shift?> getCurrentShift({required int userId});`
        *   `Stream<List<Shift>> getShifts({required int businessId, DateTimeRange? dateRange});`
    *   **Implementation Mixins:**
        *   **`ShiftMixin`:** A new mixin will be created to implement `ShiftApi` for the default backend. This will be added to the `CoreSync` class in `packages/flipper_models/lib/CoreSync.dart`.
        *   **`CapellaShiftMixin`:** A corresponding mixin will be created to implement `ShiftApi` for the Capella backend, to be used by the `CapellaSync` class in `packages/flipper_models/lib/sync/capella/capella_sync.dart`.
*   **1.3. Update `Transaction` Model:** Add the `shiftId` field to the `Transaction` model.
*   **1.4. Update Transaction Integration:**
    *   The `ITransaction` model has been updated to include a `shiftId` field.
    *   The `KeyPadService` (specifically `getPendingTransaction`) now retrieves the currently active `shiftId` and passes it to the `manageTransaction` method when creating or retrieving a pending transaction. This ensures all new transactions are associated with the active shift.

### Phase 2: User Workflow and UI

*   **2.1. Login Flow and Shift Start:**
    *   The existing PIN login screen remains the entry point.
    *   **After successful PIN entry and branch selection (in `login_choices.dart` or automatic selection in `app_service.dart`):**
        *   The system will check if the currently logged-in user has an active shift.
        *   If no active shift is found, a "Start Shift" screen will be presented, prompting the user for the opening cash float.
        *   Upon successful shift start, the user will proceed to the main application dashboard (`FlipperAppRoute`).
    *   If an active shift exists, the user will proceed directly to the main application.
*   **2.2. Implement "Close Shift" Screen (Implemented):**
    *   A "Close Shift" screen has been created.
    *   This screen allows the user to end their shift.
    *   It prompts for the final cash count (closing balance).
    *   It displays a summary:
        *   Opening Float
        *   Cash Sales
        *   Expected Cash in Drawer
        *   Actual Cash Counted
        *   Surplus / Shortage
    *   Upon confirmation, the shift is marked as `Closed`.
*   **2.3. Active User Display:**
    *   The app's main navigation bar or a prominent UI element should always display the name of the currently logged-in user.
*   **2.4. Switch User / Log Out Shift Functionality (Implemented):**
    *   A "Log Out Shift" button has been added to the `EnhancedSideMenu` (for larger screens) and to `MyDrawer` (for mobile view).
    *   Tapping this button will:
        *   Prompt the user to enter the closing balance via a dialog.
        *   Call `ProxyService.strategy.endShift` for the current user's active shift with the provided `closingBalance`.
        *   Navigate the user back to the login screen (`LoginRoute`), effectively ending their session on the device.

### Phase 3: Reporting and Management

*   **3.1. Shift History Screen:**
    *   Develop a new screen to list all shifts (both open and closed).
    *   Allow filtering by date and user.
    *   Each list item should show key details (User, Start/End Time, Cash Difference).
*   **3.2. Shift Details View:**
    *   Tapping on a shift from the history list will navigate to a details screen.
    *   This screen will show the full shift summary (as seen in the "Close Shift" flow).
    *   It will also provide a list of all transactions recorded during that shift.
*   **3.3. Update Existing Reports:**
    *   Modify existing financial and sales reports to allow filtering by shift.

### Phase 5: Testing and Verification

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

### Phase 6: Future Enhancements

*   **Budgeting**.
*   **Bank Reconciliation**.
*   **Multi-currency Support**.
*   **Tax Preparation Reports**.
