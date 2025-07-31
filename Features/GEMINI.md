# Development Guidelines

## Writing Unbreakable Dart Code

To enhance code quality and prevent runtime errors, we will adopt the principles of "unbreakable code" inspired by functional programming and the `df_safer_dart` package. This approach focuses on handling potential failures (like nulls, exceptions, and async errors) in a predictable and explicit way.

### Core Principles

1.  **Eliminate Nulls with `Option`**
    *   **Instead of:** Using nullable types (`String?`, `int?`).
    *   **Use:** An `Option` type, which can be either `Some(value)` or `None`.
    *   **Why:** This makes the absence of a value explicit in the type system, forcing developers to handle the `None` case and preventing unexpected `null` pointer exceptions.

2.  **Replace `try-catch` with `Result`**
    *   **Instead of:** Throwing exceptions for operations that can fail (e.g., parsing, validation).
    *   **Use:** A `Result` type, which returns either `Ok(value)` for success or `Err(error)` for failure.
    *   **Why:** This makes potential failures a predictable part of a function's return value, transforming runtime exceptions into manageable data that can be handled gracefully.

3.  **Manage Asynchronous Failures with `Async`**
    *   **Instead of:** Using `Future<T>` for asynchronous operations that might fail.
    *   **Use:** An `Async` outcome type, which is effectively a `Future<Result<T, E>>`.
    *   **Why:** This cleanly represents a future operation that will resolve to either a success (`Ok`) or an error (`Err`), making it ideal for robustly handling network requests, database calls, and other async tasks.

4.  **Create Resilient Pipelines with Chaining**
    *   **Instead of:** Nested `if-else` blocks or `try-catch` statements.
    *   **Use:** The chaining capabilities of `Option`, `Result`, and `Async`.
    *   **Why:** This allows for the creation of clean, linear data processing pipelines. If any step in the chain fails, the entire operation short-circuits and returns the failure, avoiding complex and deeply nested error-handling logic.

By adhering to these principles, we will build a more robust, predictable, and maintainable codebase.

## Migration Strategy

We will migrate to `df_safer_dart` on new features. Existing code will be refactored as time permits, but the priority is to use these principles for all new development.

## Test Setup Guidelines

When writing tests, especially with `flutter_test` and `mocktail`, it's crucial to structure `setUpAll` and `setUp` correctly to ensure reliable and maintainable tests.

### `setUpAll` vs. `setUp`

-   **`setUpAll`**: Use `setUpAll` for one-time setup that applies to all tests in a `group`. This is ideal for:
    -   Initializing `TestEnvironment` and its core mocks (e.g., `mockDbSync`, `mockBox`).
    -   Registering fallback values for `mocktail`'s `any()` or `captureAny()`.
    -   Performing any asynchronous setup that only needs to run once (e.g., `env.init()`).
    -   `setUpAll` should be `async` if it contains `await` calls.

-   **`setUp`**: Use `setUp` for setup that needs to run before *each* test within a `group`. This is ideal for:
    -   Resetting mocks to a clean state before each test to prevent test pollution.
    -   Stubbing common method calls on mocks that are consistent across most tests.
    -   Ensuring `ProxyService` or other global dependencies point to the correct mock instances for the current test.

### Recommended Structure

```dart
void main() {
  late TestEnvironment env;
  late MockDatabaseSync mockDbSync;
  late MockBox mockBox;
  // Declare other mocks here

  setUpAll(() async {
    // 1. Initialize TestEnvironment (if it has async setup)
    env = TestEnvironment();
    await env.init(); // Await if env.init() is async

    // 2. Assign initialized mocks from TestEnvironment
    mockDbSync = env.mockDbSync;
    mockBox = env.mockBox;
    // Assign other mocks from env as needed

    // 3. Register fallback values for mocktail
    registerFallbackValue(SomeComplexObject());
    registerFallbackValue(Uri());
    // ... other fallbacks
  });

  setUp(() {
    // 1. Reset mocks before each test
    reset(mockDbSync);
    reset(mockBox);
    // Reset other mocks

    // 2. Inject mocks into ProxyService or other global singletons
    env.injectMocks(); // Assuming this sets ProxyService.strategy, ProxyService.box etc.
    env.stubCommonMethods(); // Stub common behaviors for mocks

    // 3. Set up specific mock behaviors for the current test if needed
    when(() => mockBox.getBranchId()).thenReturn(1);
    // ... other specific stubs
  });

  tearDown(() {
    // Clean up resources after each test if necessary
    // e.g., service.dispose();
  });

  group('Your Test Group', () {
    test('Your test case', () async {
      // Test logic here
    });
  });
}
```

### Common Pitfalls to Avoid

-   **Re-initializing mocks in `setUp`**: Avoid `mockDbSync = MockDatabaseSync();` inside `setUp` if it's already initialized in `setUpAll`. This creates new mock instances for each test, which might not be what you intend and can lead to `LateInitializationError` if not handled carefully.
-   **Missing `await` in `setUpAll`**: If `env.init()` or other setup in `setUpAll` is asynchronous, ensure you `await` it. Otherwise, subsequent lines might try to access uninitialized fields.
-   **Incorrect `ProxyService` injection**: Ensure that `ProxyService` (or any other global service locator) is correctly pointed to your mock instances in `setUp` (or `setUpAll` if the mocks are truly global and don't need resetting per test).
