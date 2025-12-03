# RW Tax Errors and Resolutions

This document lists possible errors that can occur in `packages/flipper_models/lib/rw_tax.dart`, their causes, and actionable resolutions.

## Initialization (`initApi`)

| Error Message | Cause | Action |
| :--- | :--- | :--- |
| `Ebm not found for branch $branchId` | The `Ebm` configuration object could not be found for the active branch in the local database. | **User:** Ensure the device is properly registered and initialized with EBM settings.<br>**Dev:** Check `ProxyService.strategy.ebm` and database synchronization. |
| `Invalid response from server: $responseBody` | The server returned a response that could not be parsed as JSON. | **User:** Check internet connection. Retry later.<br>**Dev:** Verify the API endpoint URL and server status. Check if the server is returning HTML (e.g., 500 error page) instead of JSON. |
| `Failed to load BusinessInfo: HTTP ${statusCode}` | The server returned a non-200 HTTP status code. | **User:** Retry later. If persistent, contact support.<br>**Dev:** Check server logs for the specific HTTP error code. |
| *(API Error Message)* | The API returned a `resultCd` other than `0000`. | **User:** Read the specific error message provided. It often indicates invalid input (TIN, BHF ID, Device Serial No).<br>**Dev:** Inspect `jsonResponse['resultMsg']`. |

## Stock Operations (`saveStockItems`, `saveStockMaster`)

| Error Message | Cause | Action |
| :--- | :--- | :--- |
| `No stock items to save` | The list of items to save is empty (possibly after filtering out service items). | **User:** Ensure you are trying to save valid stock items, not just service items.<br>**Dev:** Check the filtering logic in `saveStockItems`. |
| `Missing TIN number` | The variant being saved does not have a TIN associated with it. | **Dev:** Ensure `variant.tin` is populated before calling `saveStockMaster`. |
| `Missing remaining stock quantity` | The variant's `rsdQty` (remaining stock quantity) is null. | **Dev:** Ensure `variant.rsdQty` is calculated and set. |
| `Missing item code` | The variant's `itemCd` is null or the string "null". | **Dev:** Ensure the item has been successfully registered with RRA and has a valid `itemCd`. |
| `Invalid data while saving stock` | `itemCd` is empty OR `itemTyCd` is '3' (Service). | **Dev:** Service items should not be saved in stock master. Check `itemTyCd`. Ensure `itemCd` is valid. |
| `Invalid product` | The product name is `TEMP_PRODUCT`. | **User:** Rename the product to a valid name.<br>**Dev:** Prevent saving items with placeholder names. |

## Item Registration (`saveItem`)

| Error Message | Cause | Action |
| :--- | :--- | :--- |
| `Invalid Tin Number ${variation.name}` | The variation does not have a TIN. | **Dev:** Ensure `variation.tin` is set. |
| `itemTyCd is null ${variation.name}` | The variation's item type code is null. | **Dev:** Set a valid `itemTyCd` (e.g., '1' for Raw Material, '2' for Finished Product, '3' for Service). |
| `Empty itemTyCd ${variation.name}` | The variation's item type code is an empty string. | **Dev:** Set a valid `itemTyCd`. |
| `failed to save item` | The server returned a non-200 status code. | **Dev:** Check server logs and API endpoint `items/saveItems`. |

## Sales & Receipts (`generateReceiptSignature`)

| Error Message | Cause | Action |
| :--- | :--- | :--- |
| `Invoice number already exists.` | The generated invoice number conflicts with an existing one. | **System:** The system attempts to auto-resolve this by incrementing counters.<br>**User:** Retry the transaction. |
| `Error occurred, please try again. If the problem persists, contact support.` | The invoice number conflict could not be resolved after retries. | **User:** Contact support.<br>**Dev:** Investigate counter synchronization and `_handleInvoiceDuplicate` logic. |
| `Failed to send request. Status Code: ${statusCode}` | The server returned a non-200 status code. | **User:** Check internet connection. Retry.<br>**Dev:** Verify `trnsSales/saveSales` endpoint. |
| `Failed to get tax config` | Could not find a `Configurations` object for the item's tax type (A, B, C, D). | **Dev:** Ensure tax configurations are seeded/synced for the branch. |
| `Failed to get TT tax config` | Could not find a `Configurations` object for 'TT' tax type when processing a tourism tax item. | **Dev:** Ensure 'TT' tax configuration exists if using tourism tax. |

## Imports & Purchases (`savePurchases`, `selectImportItems`, `updateImportItems`)

| Error Message | Cause | Action |
| :--- | :--- | :--- |
| *(API Error Message)* | API returned error code `894` or other non-success codes. | **User:** Read the specific error message.<br>**Dev:** `894` often implies data validation issues on the RRA server side. |
| `Failed to fetch import items. Status code: ${statusCode}` | The server returned a non-200 status code. | **Dev:** Check `imports/selectImportItems` or `trnsPurchase/savePurchases` endpoints. |

## General Network

| Error Message | Cause | Action |
| :--- | :--- | :--- |
| `Error sending GET request: ${errorMessage}` | A GET request failed (e.g., `DioException`). | **User:** Check internet connection.<br>**Dev:** Check the `baseUrl` and `queryParameters` in `sendGetRequest`. |
