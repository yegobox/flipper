# Plan for Full Accounting Feature Integration in Flipper

This document outlines a phased approach to build and integrate a comprehensive accounting module into the Flipper application. The goal is to provide users with robust financial tracking and reporting capabilities, moving beyond simple transaction listing.

## Phase 1: Foundation - Core Accounting Models and Services

This phase focuses on establishing the data structures and backend logic, which will be the foundation for all accounting features.

### 1.1. Define Core Data Models
Create new models in a new `packages/accounting_models` package. The models should follow the `brick_offline_first_with_supabase` pattern.

#### **Enums**

```dart
enum AccountType { Asset, Liability, Equity, Revenue, Expense }

enum JournalEntryStatus { Draft, Posted, Reversed }

enum JournalLineType { Debit, Credit }

enum FinancialPeriodStatus { Open, Closed }
```

#### **Model Definitions (Dart Code)**

**1. Chart of Accounts**

```dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'chart_of_accounts'),
)
class ChartOfAccounts extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true, primaryKey: true)
  @Sqlite(unique: true, primaryKey: true)
  final String id;

  @Sqlite(index: true)
  final int businessId;

  final String accountName;

  final String? accountCode;

  @Sqlite(columnType: Column.String)
  final AccountType accountType;

  final String? description;

  @Sqlite(index: true)
  final String? parentAccountId;

  @Supabase(defaultValue: true)
  @Sqlite(defaultValue: 1)
  final bool isActive;

  ChartOfAccounts({
    required this.id,
    required this.businessId,
    required this.accountName,
    this.accountCode,
    required this.accountType,
    this.description,
    this.parentAccountId,
    this.isActive = true,
  });
}
```

**2. Journal Entry**

```dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:flipper_models/accounting_models.dart'; // For JournalLine

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'journal_entries'),
)
class JournalEntry extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true, primaryKey: true)
  @Sqlite(unique: true, primaryKey: true)
  final String id;

  @Sqlite(index: true)
  final int businessId;

  final DateTime date;

  final String description;

  @Sqlite(index: true)
  final String? transactionId; // For idempotency

  @Supabase(defaultValue: 'Posted')
  @Sqlite(columnType: Column.String)
  final JournalEntryStatus status;
  
  @OfflineFirst(where: {'journalEntryId': 'id'})
  final List<JournalLine> journalLines;

  JournalEntry({
    required this.id,
    required this.businessId,
    required this.date,
    required this.description,
    this.transactionId,
    this.status = JournalEntryStatus.Posted,
    required this.journalLines,
  });
}
```

**3. Journal Line**

```dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'journal_lines'),
)
class JournalLine extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true, primaryKey: true)
  @Sqlite(unique: true, primaryKey: true)
  final String id;

  @Sqlite(index: true)
  final String journalEntryId;

  @Sqlite(index: true)
  final String accountId; // Foreign key to ChartOfAccounts

  @Sqlite(columnType: Column.String)
  final JournalLineType type; // Debit or Credit

  final double amount;

  JournalLine({
    required this.id,
    required this.journalEntryId,
    required this.accountId,
    required this.type,
    required this.amount,
  });
}
```

**4. Financial Period**

```dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'financial_periods'),
)
class FinancialPeriod extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true, primaryKey: true)
  @Sqlite(unique: true, primaryKey: true)
  final String id;

  @Sqlite(index: true)
  final int businessId;

  final DateTime startDate;
  final DateTime endDate;

  @Supabase(defaultValue: 'Open')
  @Sqlite(columnType: Column.String)
  final FinancialPeriodStatus status;

  FinancialPeriod({
    required this.id,
    required this.businessId,
    required this.startDate,
    required this.endDate,
    this.status = FinancialPeriodStatus.Open,
  });
}
```

**5. Accounting Settings (New)**

```dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'accounting_settings'),
)
class AccountingSettings extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true, primaryKey: true)
  @Sqlite(unique: true, primaryKey: true)
  final String id;

  @Sqlite(index: true)
  final int businessId;

  final String? cashAccountId;
  final String? accountsReceivableAccountId;
  final String? inventoryAccountId;
  final String? accountsPayableAccountId;
  final String? taxesPayableAccountId;
  final String? ownersEquityAccountId;
  final String? salesRevenueAccountId;
  final String? costOfGoodsSoldAccountId;
  final String? salesReturnsAccountId;

  AccountingSettings({
    required this.id,
    required this.businessId,
    this.cashAccountId,
    this.accountsReceivableAccountId,
    this.inventoryAccountId,
    this.accountsPayableAccountId,
    this.taxesPayableAccountId,
    this.ownersEquityAccountId,
    this.salesRevenueAccountId,
    this.costOfGoodsSoldAccountId,
    this.salesReturnsAccountId,
  });

  AccountingSettings copyWith({
    String? id,
    int? businessId,
    String? cashAccountId,
    String? accountsReceivableAccountId,
    String? inventoryAccountId,
    String? accountsPayableAccountId,
    String? taxesPayableAccountId,
    String? ownersEquityAccountId,
    String? salesRevenueAccountId,
    String? costOfGoodsSoldAccountId,
    String? salesReturnsAccountId,
  }) {
    return AccountingSettings(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      cashAccountId: cashAccountId ?? this.cashAccountId,
      accountsReceivableAccountId: accountsReceivableAccountId ?? this.accountsReceivableAccountId,
      inventoryAccountId: inventoryAccountId ?? this.inventoryAccountId,
      accountsPayableAccountId: accountsPayableAccountId ?? this.accountsPayableAccountId,
      taxesPayableAccountId: taxesPayableAccountId ?? this.taxesPayableAccountId,
      ownersEquityAccountId: ownersEquityAccountId ?? this.ownersEquityAccountId,
      salesRevenueAccountId: salesRevenueAccountId ?? this.salesRevenueAccountId,
      costOfGoodsSoldAccountId: costOfGoodsSoldAccountId ?? this.costOfGoodsSoldAccountId,
      salesReturnsAccountId: salesReturnsAccountId ?? this.salesReturnsAccountId,
    );
  }
}
```

### 1.2. Backend Service/Repository
In `packages/flipper_services`, create a new `AccountingService`.

*   **Default Chart of Accounts**: A function to create a standard set of accounts for a new business. **(Implemented in `TransactionAccountingMixin` and saves default account IDs to `AccountingSettings`)**
*   **CRUD Operations**: Methods for managing the `ChartOfAccounts`.
*   **Journal Entry Creation**: A core function `createJournalEntry(entry)` that is **idempotent** (checking `transactionId` to prevent duplicates) and ensures **Total Debits = Total Credits**. **(Implemented in `TransactionAccountingMixin` with UUID generation and balance checks)**
*   **Period Management**: Functions to open and close `FinancialPeriod`s. Journal entries cannot be posted to a closed period.
*   **`getAccountId`**: Now retrieves account IDs from `AccountingSettings` based on a key (e.g., 'cash', 'salesRevenue') instead of hardcoded names.

## Phase 2: Integrating with Existing Business Logic

### 2.1. Transaction-to-Journal-Entry Service
Create a service to translate Flipper events into double-entry records.

*   **On Sale**: Generate a `JournalEntry`. **(Implemented in `TransactionAccountingMixin` using `AccountingSettings` for account IDs)**
    *   **Example (Cash Sale with Tax)**:
        *   Debit `Cash` (Asset).
        *   Credit `Sales Revenue` (Revenue).
        *   Credit `Taxes Payable` (Liability).
        *   (If tracking inventory) Debit `Cost of Goods Sold` (Expense) and Credit `Inventory` (Asset).
*   **On Purchase**: Generate a `JournalEntry`. **(Implemented in `TransactionAccountingMixin` using `AccountingSettings` for account IDs)**
    *   **Example (Cash Purchase)**:
        *   Debit `Inventory` (Asset).
        *   Credit `Cash` (Asset) or `Accounts Payable` (Liability).
*   **On Return/Refund**: Generate a reversing `JournalEntry`. **(Implemented in `TransactionAccountingMixin` using `AccountingSettings` for account IDs)**
    *   **Example (Cash Refund)**:
        *   Debit `Sales Returns` (a contra-revenue account).
        *   Credit `Cash` (Asset).

### 2.2. Modify Existing Services
Update the `TransactionService` to call the new `AccountingService` after a transaction is successfully processed.

## Phase 3: User Interface - Management and Visualization

Develop a new package: `packages/flipper_accounting`.

### 3.1. Chart of Accounts Management Screen
*   Hierarchical view of accounts.
*   Allows users to add, edit, or disable accounts.

### 3.2. General Ledger Screen
*   View all journal entries for an account in a date range.
*   Include a **running balance** column.
*   Filtering and sorting capabilities.

### 3.3. Manual Journal Entry Screen
*   A form for manual entries that enforces the "Debits = Credits" rule.

## Phase 4: Financial Reporting

### 4.1. Reporting Logic in `AccountingService`
*   **`generateIncomeStatement(periodId)`**: Calculates Net Income for the period. **(Implemented in `TransactionAccountingMixin`)**
*   **`generateBalanceSheet(asOfDate)`**: Calculates Assets, Liabilities, and Equity. Must validate that `Assets = Liabilities + Equity`. **(Implemented in `TransactionAccountingMixin`)**
*   **`generateCashFlowStatement(periodId)`**: Tracks cash movements. **(Implemented in `TransactionAccountingMixin` - simplified categorization)**
*   **Transaction Locking**: Ensure data consistency by preventing changes to a period while reports are being generated.

### 4.2. Reporting UI
*   Dedicated screens for each financial statement.
*   **Drill-down capability**: Allow users to click a line item (e.g., "Sales Revenue") to navigate to the General Ledger for that account.
*   Date-range pickers and export options (PDF, CSV).

## Phase 5: Accounting Settings

Create a new settings area for accounting configuration.

*   **Fiscal Year Start**: Allow users to define their fiscal year.
*   **Default Accounts**: Set default accounts for different transaction types. **(Backend implementation for storing default account IDs in `AccountingSettings` is complete)**
*   **Period Management**: A UI to view and manually close financial periods.

## Phase 6: Testing and Validation

*   **Unit Tests**: For `AccountingService` and report generation.
*   **Integration Tests**: For the automated journal entry creation.
*   **UI Tests**: For the new accounting and reporting screens.

## Phase 7: Future Enhancements

*   **Budgeting**.
*   **Bank Reconciliation**.
*   **Multi-currency Support**.
*   **Tax Preparation Reports**.