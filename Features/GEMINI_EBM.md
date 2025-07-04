# EBM Integration: TurboTaxService Documentation

This document outlines the purpose, usage, and key functionalities of the `TurboTaxService` within the Flipper application. This service is central to the Electronic Billing Machine (EBM) integration, ensuring that critical business data is synchronized with tax authority systems.

## 1. Purpose of TurboTaxService

The `TurboTaxService` is responsible for managing the synchronization of various data entities (product variants, transactions, and customer information) between the local Flipper database and the external EBM system. Its primary goal is to ensure compliance with tax regulations by accurately reporting sales and stock movements to the tax authority.

## 2. Key Components and Usage Across the App

The `TurboTaxService` is typically accessed via `ProxyService.tax`, which acts as a facade to the underlying tax-related functionalities.

### 2.1. `handleProformaOrTrainingMode()`

*   **Purpose:** This static method checks if the application is currently operating in "proforma" or "training" mode. In these modes, EBM synchronization is bypassed to prevent sending test data to the live tax system.
*   **Usage:** Called at the beginning of EBM-related synchronization processes (e.g., `stockIo`) to determine if the sync should proceed or be skipped.
*   **Location:** Used within `TurboTaxService` methods.

### 2.2. `stockIo({Variant? variant, required String serverUrl, ITransaction? transaction, String? sarTyCd})`

*   **Purpose:** This is a core method for synchronizing product variants and stock movements with the EBM system. It handles both item master data (for variants) and stock in/out operations (via transactions).
*   **Key Functionality:**
    *   **Item Master Data:** If a `variant` is provided, it attempts to save the item and its stock master data to the EBM.
    *   **Stock Movements:** It orchestrates the synchronization of stock adjustments or sales transactions.
    *   **Error Handling:** Crucially, this method and its internal calls (`_syncStockItems`) are designed **not to throw exceptions**. This is vital because they are often called within loops (e.g., processing multiple transaction items), and an unhandled exception would break the loop, leading to inconsistent data saving in the local database. Instead, failures are handled internally by recording them in the `Retryable` model.
*   **Usage Across App:**
    *   Called by `ProxyService.strategy.syncVariant` when a variant is created or updated.
    *   Called by `ProxyService.strategy.syncTransaction` when a transaction is completed and needs to be reported to EBM.
    *   Used internally by `_syncStockItems`.

### 2.3. `_handleFailedSync({required String entityId, required String entityTable, required String failureReason})`

*   **Purpose:** An internal helper method to record synchronization failures. When an EBM sync operation fails, this method creates or updates a `Retryable` entry in the local database.
*   **Key Functionality:**
    *   Stores the `entityId`, `entityTable`, and `failureReason` for the failed sync.
    *   Increments a `retryCount` for existing failed entries, allowing for tracking and potential re-attempts.
*   **Usage:** Called by `stockIo` and `_syncStockItems` when EBM API calls return non-success codes.

### 2.4. `_syncStockItems({required ITransaction? transaction, required String serverUrl, Variant? variant, String? sarTyCd})`

*   **Purpose:** An internal method responsible for the actual process of sending stock-related transaction data to the EBM.
*   **Key Functionality:**
    *   Retrieves transaction items.
    *   Calculates taxes (e.g., for tax type "B").
    *   Calls `ProxyService.tax.saveStockItems` to send the data to the EBM.
    *   Handles success and failure by updating `Retryable` entries.
*   **Usage:** Called by `stockIo`.

### 2.5. `syncTransactionWithEbm({required ITransaction instance, required String serverUrl, required String sarTyCd})`

*   **Purpose:** Synchronizes a complete transaction with the EBM system.
*   **Key Functionality:**
    *   Ensures the transaction is in a `COMPLETE` status and has necessary customer information.
    *   Delegates the actual item-level synchronization to `stockIo`.
    *   Logs successful synchronization.
*   **Usage Across App:** Called by `ProxyService.strategy.syncTransaction` after a transaction is finalized.

### 2.6. `syncCustomerWithEbm({required Customer instance, required String serverUrl})`

*   **Purpose:** Synchronizes customer information with the EBM system.
*   **Key Functionality:**
    *   Sends customer data to the tax authority's system.
    *   Updates the local customer record to mark it as synced upon success.
*   **Usage Across App:** Called by `ProxyService.strategy.syncCustomer` when a customer record is created or updated.

## 3. Importance for Future Edits

Understanding the `TurboTaxService` is crucial for any future development related to EBM integration or data synchronization:

*   **Data Consistency:** The internal error handling (using `Retryable` and avoiding exceptions in loops) is designed to maintain local data consistency even if EBM sync fails. Developers should adhere to this pattern.
*   **EBM Compliance:** Any changes to how variants, transactions, or customers are handled must consider their impact on EBM reporting.
*   **Performance:** Batching or optimizing EBM calls should be considered for large data volumes, but always within the established error handling and retry mechanisms.
*   **Extensibility:** If new EBM requirements arise, new methods or modifications to existing ones should follow the established patterns for data handling and error reporting.

By adhering to the documented usage and understanding the underlying mechanisms, future edits can be made safely and efficiently, minimizing the risk of breaking EBM integration or compromising data integrity.
