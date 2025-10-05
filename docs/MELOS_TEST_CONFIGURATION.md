# Melos Test Configuration for supabase_models

## ✅ Confirmation

The `supabase_models` package **IS** properly configured in melos and will be tested automatically.

### Package Inclusion

**Location**: `/packages/supabase_models/`

**Melos Pattern Match**: 
```yaml
packages:
  - packages/**
  - packages/**/**
```

This pattern includes `supabase_models` in the melos workspace.

### Test Files Present

The package has the following test files:
- `test/stock_recount_test.dart` - Tests for StockRecount model (19 tests)
- `test/stock_recount_item_test.dart` - Tests for StockRecountItem model (19 tests)
- `test/counter_ditto_adapter_test.dart` - Ditto adapter tests
- `test/ditto_sync_generated_test.dart` - Generated sync tests

**Total Stock Recount Tests**: 38 unit tests ✅

## 🧪 Test Commands Added

I've added three new test scripts to `melos.yaml`:

### 1. Test All supabase_models
```bash
melos run test:supabase_models
```
Runs all tests in the supabase_models package with coverage.

### 2. Test Only Stock Recount
```bash
melos run test:stock_recount
```
Runs only the stock recount-specific tests (stock_recount_test.dart and stock_recount_item_test.dart).

### 3. CI/CD Pipeline Updated
```bash
melos run test:ci
```
Now includes supabase_models tests in the CI/CD pipeline:
- flipper_dashboard
- flipper_auth
- flipper_web
- **supabase_models** ← NEW

## 📋 How Tests Are Run

### General Test Command
```bash
melos run test
```
This command automatically includes supabase_models because:
- It selects all packages with a `test` directory
- `supabase_models` has a test directory
- It's not in the ignore list

### Unit Test with Coverage
```bash
melos run unit_test
```
This runs tests for ALL packages including supabase_models with coverage reporting.

### All Tests
```bash
melos run test:all
```
Runs tests for all packages (regular, web, e2e) including supabase_models.

## 🎯 Verifying Stock Recount Tests

To verify the stock recount tests work:

```bash
# Run all supabase_models tests
cd packages/supabase_models
flutter test --dart-define=FLUTTER_TEST_ENV=true

# Or using melos from root
cd /Users/richard/Developer/flipper
melos run test:stock_recount

# Or run specific test files
cd packages/supabase_models
flutter test test/stock_recount_test.dart
flutter test test/stock_recount_item_test.dart
```

## 📊 Test Coverage

The stock recount feature has comprehensive test coverage:

### StockRecount Model Tests (19 tests)
- ✅ Creates valid recount
- ✅ Validates required fields
- ✅ Status transitions (draft → submitted → synced)
- ✅ Status transition guards
- ✅ Timestamp tracking (createdAt, submittedAt, syncedAt)
- ✅ Submit and sync operations
- ✅ Device tracking

### StockRecountItem Model Tests (19 tests)
- ✅ Creates valid items
- ✅ Calculates differences
- ✅ Validates countedQuantity (non-negative)
- ✅ Links to variant and stock
- ✅ Product name denormalization
- ✅ Notes field
- ✅ Quantity tracking (previous vs counted)

## 🔄 Integration with Melos Workflow

### Quality Check
```bash
melos run qualitycheck
```
Runs complete quality check including all tests (supabase_models included).

### Clean and Test
```bash
melos clean
melos bootstrap
melos run test:all
```

### Coverage Report
```bash
melos run unit_test_and_coverage
```
Generates merged coverage report including supabase_models tests.

## ✨ Summary

- ✅ `supabase_models` is included in melos workspace
- ✅ Stock recount tests exist (38 unit tests)
- ✅ Tests run automatically with general test commands
- ✅ New dedicated test scripts added for convenience
- ✅ CI/CD pipeline updated to include supabase_models tests
- ✅ Coverage reporting includes supabase_models

**No additional configuration needed** - everything is properly set up! 🎉
