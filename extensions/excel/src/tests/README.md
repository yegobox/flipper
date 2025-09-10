# Testing Documentation

This directory contains comprehensive unit tests for the Flipper Excel add-in.

## 📁 Test Structure

```
src/tests/
├── setup.ts              # Test setup and mocks
├── utils.ts              # Test utilities and helpers
├── README.md             # This documentation
└── __tests__/           # Test files
    ├── FlipperApp.test.ts      # Main app tests
    ├── ExcelOperations.test.ts  # Excel.js operation tests
    └── UIInteractions.test.ts   # UI interaction tests
```

## 🚀 Running Tests

### Basic Commands

```bash
# Run all tests
npm test

# Run tests in watch mode (development)
npm run test:watch

# Run tests with coverage report
npm run test:coverage

# Run tests for CI/CD
npm run test:ci
```

### Running Specific Tests

```bash
# Run tests matching a pattern
npm test -- --testNamePattern="highlight"

# Run tests in a specific file
npm test -- FlipperApp.test.ts

# Run tests with verbose output
npm test -- --verbose
```

## 📊 Coverage Reports

After running `npm run test:coverage`, you'll find coverage reports in:

- **HTML Report**: `coverage/lcov-report/index.html`
- **LCOV Report**: `coverage/lcov.info`
- **Console Output**: Terminal shows summary

### Coverage Thresholds

- **Branches**: 80%
- **Functions**: 80%
- **Lines**: 80%
- **Statements**: 80%

## 🧪 Test Categories

### 1. FlipperApp Tests (`FlipperApp.test.ts`)

Tests the main application class and its methods:

- **Initialization**: App startup, Office.js integration
- **UI State Management**: Loading, error, and success states
- **Excel Operations**: All Excel.js interactions
- **Data Validation**: Form validation and data cleanup
- **Recent Actions**: History tracking and display
- **Notifications**: User feedback system
- **Event Listeners**: Button clicks and form interactions
- **Error Handling**: Graceful error management

### 2. Excel Operations Tests (`ExcelOperations.test.ts`)

Focused tests for Excel.js functionality:

- **Range Operations**: Getting and manipulating ranges
- **Table Operations**: Creating and formatting tables
- **Data Validation**: Applying validation rules
- **Data Cleanup**: Removing duplicates, trimming spaces
- **Worksheet Operations**: Working with worksheets
- **Error Handling**: Excel operation failures
- **Performance Tests**: Large dataset handling

### 3. UI Interactions Tests (`UIInteractions.test.ts`)

Tests for user interface behavior:

- **Button Interactions**: All button click handlers
- **Select Interactions**: Dropdown and form controls
- **DOM State Management**: Showing/hiding elements
- **CSS Classes**: Styling and responsive design
- **Accessibility**: ARIA labels and keyboard navigation
- **Responsive Design**: Different viewport sizes
- **Error Handling**: Missing elements and invalid inputs
- **Performance**: Rapid interactions and multiple changes

## 🛠️ Test Utilities

### Mock Setup (`setup.ts`)

Provides mocks for:
- **Office.js**: `Office.onReady`, `Office.HostType`
- **Excel.js**: `Excel.run`, `Excel.RequestContext`
- **DOM APIs**: `IntersectionObserver`, `ResizeObserver`
- **Console**: Muted console methods for cleaner output

### Test Utilities (`utils.ts`)

Helper functions for:
- **Data Creation**: `createTestData()`, `createMockExcelContextWithData()`
- **Async Operations**: `waitForAsync()`
- **Event Tracking**: `createEventSpy()`, `createNotificationSpy()`
- **Validation**: `validateExcelOperation()`, `validateRangeFormatting()`
- **Performance**: `createPerformanceTest()`
- **Accessibility**: `createAccessibilityTest()`
- **Responsive Design**: `createResponsiveTest()`

## 📝 Writing Tests

### Test Structure

```typescript
describe('Feature Name', () => {
  let app: FlipperApp;
  let mockExcelContext: any;

  beforeEach(() => {
    // Setup mocks and DOM
    createMockDOM();
    mockExcelContext = createMockExcelContext();
    jest.clearAllMocks();
  });

  afterEach(() => {
    // Cleanup
    jest.clearAllMocks();
    document.body.innerHTML = '';
  });

  test('should do something specific', async () => {
    // Arrange
    const expectedResult = 'expected value';
    
    // Act
    const result = await app.someMethod();
    
    // Assert
    expect(result).toBe(expectedResult);
  });
});
```

### Best Practices

1. **Use Descriptive Test Names**
   ```typescript
   // Good
   test('should highlight selection with professional colors', async () => {
   
   // Bad
   test('should work', async () => {
   ```

2. **Test One Thing at a Time**
   ```typescript
   // Good - focused test
   test('should apply email validation', async () => {
     // Test only email validation
   });
   
   // Bad - testing multiple things
   test('should handle all validations', async () => {
     // Testing email, phone, date, number all at once
   });
   ```

3. **Use Mocks Appropriately**
   ```typescript
   // Mock external dependencies
   (global.Excel as any).run = jest.fn().mockImplementation(async (callback) => {
     await callback(mockExcelContext);
   });
   ```

4. **Test Error Conditions**
   ```typescript
   test('should handle Excel operation errors', async () => {
     mockExcelContext.sync.mockRejectedValue(new Error('Excel error'));
     
     await expect(app.highlightSelection()).rejects.toThrow('Excel error');
   });
   ```

5. **Use Test Utilities**
   ```typescript
   import { validateExcelOperation, createTestData } from '../tests/utils';
   
   test('should format data correctly', async () => {
     const testData = createTestData();
     
     await validateExcelOperation(async () => {
       await app.formatData();
     });
   });
   ```

## 🔧 Configuration

### Jest Configuration (`jest.config.js`)

- **Preset**: `ts-jest` for TypeScript support
- **Environment**: `jsdom` for DOM testing
- **Coverage**: Comprehensive coverage reporting
- **Timeout**: 10 seconds for async operations
- **Mocks**: Automatic mock restoration

### TypeScript Configuration

Tests use the same TypeScript configuration as the main application, ensuring type safety across the codebase.

## 🐛 Debugging Tests

### Common Issues

1. **Async Operations Not Completing**
   ```typescript
   // Use waitForAsync utility
   await waitForAsync(100);
   ```

2. **DOM Elements Not Found**
   ```typescript
   // Ensure DOM is set up before test
   beforeEach(() => {
     createMockDOM();
   });
   ```

3. **Mock Not Working**
   ```typescript
   // Clear mocks between tests
   afterEach(() => {
     jest.clearAllMocks();
   });
   ```

### Debug Mode

```bash
# Run tests with debugging
npm test -- --verbose --detectOpenHandles

# Run specific test with debugging
npm test -- --testNamePattern="specific test" --verbose
```

## 📈 Continuous Integration

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test:ci
      - uses: codecov/codecov-action@v2
```

## 🎯 Test Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Integration Tests**: Critical user flows
- **Error Scenarios**: All error conditions
- **Edge Cases**: Boundary conditions
- **Performance**: Large dataset handling

## 📚 Additional Resources

- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [Testing Library](https://testing-library.com/docs/)
- [Office.js Testing](https://docs.microsoft.com/en-us/office/dev/add-ins/testing/testing)
- [TypeScript Testing](https://www.typescriptlang.org/docs/handbook/testing.html)

test('should handle invalid element types', () => {
  const validationSelect = document.getElementById('data-validation') as HTMLSelectElement;
  // Add the invalid option for testing
  const option = document.createElement('option');
  option.value = 'invalid-value';
  validationSelect.appendChild(option);

  expect(() => {
    simulateChange(validationSelect, 'invalid-value');
  }).not.toThrow();

  expect(validationSelect.value).toBe('invalid-value');
}); 