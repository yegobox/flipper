# Variant Model Validation Rules

This document outlines all possible validation rules for fields in the Variant model based on the analysis of `variant.model.dart` and `DesktopProductAdd.dart`.

## Field Validation Rules

### Basic Fields
- **id** (String)
  - Required: Yes (auto-generated if not provided)
  - Validation: Should be a valid UUID (auto-generated)

- **name** (String)
  - Required: Yes
  - Minimum length: 3 characters
  - Validation: Cannot be null or empty

- **color** (String?)
  - Required: No
  - Validation: Should be a valid hexadecimal color code if provided

- **sku** (String?)
  - Required: No (in regular mode), Yes (in composite mode)
  - Validation: Cannot be null or empty when required in composite products

- **productName** (String)
  - Required: Yes
  - Validation: Cannot be null or empty

- **productId** (String?)
  - Required: No
  - Validation: Should refer to an existing product ID if provided

- **categoryId** (String?)
  - Required: No (but UI requires selection)
  - Validation: Should refer to an existing category ID if provided

- **categoryName** (String?)
  - Required: No
  - Validation: Display field for category name

### Branch & Business Fields
- **branchId** (int?)
  - Required: No (auto-set from context)
  - Validation: Should be a valid branch ID from current context

### RRA/EBM Fields  
- **itemSeq** (int?)
  - Default: 1
  - Validation: Should be a positive integer

- **isrccCd** (String?)
  - Required: No
  - Validation: Should follow RRA coding standards if provided

- **isrccNm** (String?)
  - Required: No  
  - Validation: Should be a valid name if provided

- **isrcRt** (int?)
  - Default: 0
  - Validation: Should be a non-negative integer

- **isrcAmt** (int?)
  - Default: 0
  - Validation: Should be a non-negative integer

- **taxTyCd** (String?)
  - Required: No
  - Validation: Should be a valid tax type code (e.g., "B" for VAT, "D" for non-VAT)

- **bcd** (String?)
  - Required: No (for regular mode), Yes (in composite mode)
  - Validation: Cannot be null or empty when required in composite products

- **itemClsCd** (String?)
  - Required: No
  - Validation: Should follow RRA item class coding standards if provided

- **itemTyCd** (String?)
  - Required: No
  - Validation: Should be a valid item type code (e.g., "3" for service items)

- **itemStdNm** (String?)
  - Required: No
  - Validation: Should be a valid standard name if provided

- **orgnNatCd** (String?)
  - Required: No  
  - Validation: Should be a valid origin country code if provided

- **pkg** (int?)
  - Default: 1
  - Validation: Should be a positive integer

- **itemCd** (String?)
  - Required: No
  - Validation: Should follow RRA item coding standards if provided

- **pkgUnitCd** (String?)
  - Required: No
  - Validation: Should be a valid packaging unit code

- **qtyUnitCd** (String?)
  - Required: No
  - Validation: Should be a valid quantity unit code

- **itemNm** (String?)
  - Required: Yes
  - Validation: Cannot be null or empty, minimum length may apply

### Pricing Fields
- **prc** (double?)
  - Default: 0.0
  - Validation: Should be a non-negative number

- **splyAmt** (double?)
  - Default: 0.0
  - Validation: Should be a non-negative number

- **supplyPrice** (double?)
  - Required: No
  - Validation: Should be a non-negative number, less than or equal to retailPrice

- **retailPrice** (double?)
  - Required: Yes
  - Validation: Should be a non-negative number, greater than or equal to supplyPrice
  - UI Validation: Both retailPrice and supplyPrice must be valid numbers

- **taxPercentage** (num?)
  - Default: 18.0
  - Validation: Should be a non-negative percentage value

- **dftPrc** (double?)
  - Default: 0.0
  - Validation: Should be a non-negative number

- **dcRt** (double?)
  - Default: 0.0
  - Validation: Should be a non-negative number (discount rate)

- **dcAmt** (double?)
  - Default: 0.0
  - Validation: Calculated field, should be non-negative

- **taxblAmt** (double?)
  - Validation: Calculated field based on pricing

- **taxAmt** (double?)
  - Validation: Calculated field based on tax percentage

- **totAmt** (double?)
  - Validation: Calculated field based on pricing and taxes

### Registration & History Fields
- **regrId** (String?)
  - Required: No
  - Default: First 15 characters of a random number string (e.g., `randomNumber().toString().substring(0, 15)`)
  - Validation: Should be a string of up to 15 characters if provided manually

- **regrNm** (String?)
  - Required: No
  - Validation: Should be a valid user name if provided

- **modrId** (String?)
  - Required: No (auto-generated)
  - Default: First 5 characters of a UUID (e.g., `uuid.substring(0, 5)`)
  - Validation: Should be exactly 5 alphanumeric characters if provided manually
  - Context: Used for modification tracking, 5-character length from UUID ensures consistency

- **modrNm** (String?)
  - Required: No
  - Default: First 5 characters of a UUID (e.g., `uuid.substring(0, 5)`) or first 8 characters of random string in tax operations
  - Validation: Should be either 5 or 8 characters depending on context
  - Context: 5 characters for internal operations, 8 characters for tax/RRA operations

- **lastTouched** (DateTime?)
  - Required: No (auto-set)
  - Validation: Should be a valid date/time if provided

### Supplier Fields
- **spplrItemClsCd** (String?)
  - Required: No
  - Validation: Should follow supplier item class coding standards if provided

- **spplrItemCd** (String?)
  - Required: No
  - Validation: Should follow supplier item coding standards if provided

- **spplrItemNm** (String?)
  - Required: No
  - Validation: Should be a valid supplier item name if provided

- **spplrNm** (String?)
  - Required: No
  - Validation: Should be a valid supplier name if provided

- **agntNm** (String?)
  - Required: No
  - Validation: Should be a valid agent name if provided

### Import/Customs Fields  
- **totWt** (int?)
  - Default: 0
  - Validation: Should be a non-negative integer (total weight)

- **netWt** (int?)
  - Default: 0
  - Validation: Should be a non-negative integer (net weight)

- **invcFcurAmt** (num?)
  - Default: 0.0
  - Validation: Should be a non-negative amount

- **invcFcurCd** (String?)
  - Required: No
  - Validation: Should be a valid foreign currency code if provided

- **invcFcurExcrt** (double?)
  - Default: 0.0
  - Validation: Should be a positive exchange rate value if provided

- **exptNatCd** (String?)
  - Required: No
  - Validation: Should be a valid export country code if provided

- **dclNo** (String?)
  - Required: No
  - Validation: Should follow declaration number format if provided

- **taskCd** (String?)
  - Required: No
  - Validation: Should follow task coding standards if provided

- **dclDe** (String?)
  - Required: No
  - Validation: Should follow declaration date format if provided

- **hsCd** (String?)
  - Required: No
  - Validation: Should be a valid HS code if provided

- **imptItemSttsCd** (String?)
  - Required: No
  - Validation: Should follow import item status coding if provided

### Status & Configuration Fields
- **ebmSynced** (bool?)
  - Default: false
  - Validation: Should be a boolean value

- **useYn** (String?)
  - Required: No
  - Validation: Should be "Y" or "N" if provided

- **isrcAplcbYn** (String?)
  - Required: No
  - Validation: Should be "Y" or "N" if provided

- **addInfo** (String?)
  - Required: No
  - Validation: Should follow additional information format if provided

- **pchsSttsCd** (String?)
  - Required: No
  - Validation: Should follow purchase status coding if provided

### Helper Fields (UI/Helper only - not persisted)
- **barCode** (String?)
  - Required: No (in regular mode), Yes (in composite mode)
  - Validation: Cannot be null or empty when required in composite products

- **bcdU** (String?)
  - Required: No
  - Validation: Helper field only

- **quantity** (double?)
  - Required: No
  - Validation: Should be a non-negative number

- **category** (String?)
  - Required: No
  - Validation: Helper field only

### Other Fields
- **unit** (String?)
  - Required: No
  - Validation: Should be a valid unit of measure if provided

- **taxName** (String?)
  - Required: No
  - Validation: Should be a valid tax name if provided

- **tin** (int?)
  - Default: 0
  - Validation: Should be a valid tax identification number if provided

- **bhfId** (String?)
  - Required: No
  - Validation: Should be a valid business head office ID if provided

- **purchaseId** (String?)
  - Required: No
  - Validation: Should refer to an existing purchase ID if provided

- **propertyTyCd** (String?)
  - Required: No
  - Validation: Should be a valid property type code if provided

- **roomTypeCd** (String?)
  - Required: No
  - Validation: Should be a valid room type code if provided

- **ttCatCd** (String?)
  - Required: No
  - Validation: Should be a valid tax category code if provided

- **expirationDate** (DateTime?)
  - Required: No
  - Validation: Should be a valid future date if provided

- **qty** (double?)
  - Default: 1.0
  - Validation: Should be a non-negative number (stock quantity)

- **rsdQty** (double?)
  - Validation: Should be a non-negative number (residual quantity)

- **isShared** (bool?)
  - Default: false
  - Validation: Boolean value

- **assigned** (bool?)
  - Default: false
  - Validation: Boolean value

- **stockSynchronized** (bool?)
  - Default: true
  - Validation: Boolean value

## Business Logic Validations

### Price Relationship Validations
- `retailPrice` should be greater than or equal to `supplyPrice`
- Both `retailPrice` and `supplyPrice` must be valid non-negative numbers
- `supplyPrice` should be less than or equal to `retailPrice`

### RRA/EBM Compliance Validations
- If EBM is enabled, certain fields like `taxTyCd` must follow RRA standards
- For composite products, `itemTyCd` should be "3" (service type) to avoid stock reporting
- `pkgUnitCd` should match RRA packaging unit codes

### Required Field Validations Based on Context
- In composite products: `sku` and `bcd` fields become required
- When EBM is enabled: Additional RRA fields become mandatory
- `productName` is always required for UI validation

## UI Validation Examples

### Product Name Validation
- Cannot be null or empty
- Must be at least 3 characters long

### Price Validation
- Retail Price and Supply Price cannot be null or invalid
- Both must be valid numeric values
- Price must be a positive number

### SKU Validation
- Cannot be null or empty when required in composite products

### Barcode Validation
- Cannot be null or empty when required in composite products

### Color Validation
- Should be a valid hexadecimal color code

## Field Pattern Validations

### ID Field Length Constraints
Based on actual code implementation:

- **modrId**: Exactly 5 alphanumeric characters (from `uuid.substring(0, 5)`)
- **modrNm**: Either 5 characters (internal operations) or 8 characters (tax operations)
- **regrId**: Up to 15 characters (from `randomNumber().toString().substring(0, 15)`)

### Context-Specific Validations
- In RRA/Tax operations: modrNm uses 8-character random strings (`randomString().substring(0, 8)`)
- In internal operations: modrNm uses 5-character UUID substrings
- Transaction contexts use 5-character transaction ID substrings for modrId/modrNm